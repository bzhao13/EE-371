
module t2_control(
	input logic clk, reset,
	input logic start, mid_val_eq_target, eq_ptrs, target_gt_mid_val, target_lt_mid_val, found_val,
	output logic load_data, new_high_ptr, new_mid_ptr, new_low_ptr, out_addr, found,
	output logic [2:0] state
	);
		
	logic [2:0] ps, ns;
	parameter s0 = 3'b000;
	parameter s1 = 3'b001;
	parameter s2 = 3'b010;
	parameter s3 = 3'b011;
	parameter s4 = 3'b100;
	
	// Next state logic
	always_comb
		case (ps)
			s0:	if (start)
						ns = s1;
					else
						ns = s0;
			s1:	if (eq_ptrs)
						ns = s3;
					else
						ns = s2;
			s2:	ns = s4;
			s3:	if (start)
						ns = s3;
					else
						ns = s0;
			s4:	if (mid_val_eq_target)
						ns = s3;
					else
						ns = s1;
		endcase
		
	// Output logic
	always_comb begin
		load_data = 0;
		new_high_ptr = 0;
		new_mid_ptr = 0;
		new_low_ptr = 0;
		out_addr = 0;
		found = 0;
		
		case (ps)
			s0:	if (~start)
						load_data = 1;
			s1:	new_mid_ptr = 1;
			s3:	if (found_val) begin
						found = 1;
						out_addr = 1;
					end
			s4:	if (target_gt_mid_val)
						new_low_ptr = 1;
					else if (target_lt_mid_val)
						new_high_ptr = 1;
		endcase
	end
	
	assign state = ps;
	
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= s0;
		else
			ps <= ns;
	end
endmodule

module t2_control_tb();
	logic clk, reset;
	logic start, mid_val_eq_target, eq_ptrs, target_gt_mid_val, target_lt_mid_val, found_val;
	logic load_data, new_high_ptr, new_mid_ptr, new_low_ptr, out_addr, found;
	logic [1:0] state;
	
	t2_control dut(
	clk, reset,
	start, mid_val_eq_target, eq_ptrs, target_gt_mid_val, target_lt_mid_val, found_val,
	load_data, new_high_ptr, new_mid_ptr, new_low_ptr, out_addr, found,
	state
	);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; start <= 0; mid_val_eq_target <= 0; eq_ptrs <= 0; target_gt_mid_val <= 0; found_val <= 0; @(posedge clk); @(posedge clk);
		reset <= 0; start <= 1; @(posedge clk); @(posedge clk);
		target_gt_mid_val <= 1; @(posedge clk); @(posedge clk);
		mid_val_eq_target <= 1; found_val <= 1; @(posedge clk); @(posedge clk);
		start <= 0; @(posedge clk); @(posedge clk);
		$stop;
	end
endmodule
