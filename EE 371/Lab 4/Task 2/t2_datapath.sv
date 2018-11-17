
module t2_datapath(
	input logic clk, reset,
	input logic [7:0] target, data,
	input logic load_data, new_high_ptr, new_mid_ptr, new_low_ptr, out_addr,
	output logic mid_val_eq_target, eq_ptrs, target_gt_mid_val, target_lt_mid_val, found_val,
	output logic [4:0] addr, mid_ptr, high_ptr, low_ptr
	);

	logic [7:0] target_reg;
	
	// Data processing
	always_ff @(posedge clk) begin
		if (reset) begin
			target_reg <= 8'b0;
			addr <= 5'b0;
			high_ptr <= 31;
			low_ptr <= 0;
		end else begin
			if (load_data) begin
				target_reg <= target;
				high_ptr <= 31;
				low_ptr <= 0;
				addr <= 5'b0;
			end
			if (new_mid_ptr)
				mid_ptr <= ((high_ptr + low_ptr) / 2);
			else if (new_high_ptr)
				high_ptr <= mid_ptr - 1;
			else if (new_low_ptr)
				low_ptr <= mid_ptr + 1;
			if (out_addr)
				addr <= mid_ptr;
		end
	end
	
	// Feedback signals
	assign mid_val_eq_target = (data == target_reg);
	assign eq_ptrs = (high_ptr == low_ptr);
	assign target_gt_mid_val = (target_reg > data);
	assign target_lt_mid_val = (target_reg < data);
	assign found_val = (data == target_reg);
endmodule

module t2_datapath_tb();
	logic clk, reset;
	logic [7:0] target, data;
	logic load_data, new_high_ptr, new_mid_ptr, new_low_ptr, out_addr;
	logic mid_val_eq_target, eq_ptrs, target_gt_mid_val, target_lt_mid_val, found_val;
	logic [4:0] addr, mid_ptr, high_ptr, low_ptr;
	
	t2_datapath dut(
	clk, reset,
	target, data,
	load_data, new_high_ptr, new_mid_ptr, new_low_ptr, out_addr,
	mid_val_eq_target, eq_ptrs, target_gt_mid_val, target_lt_mid_val, found_val,
	addr, mid_ptr, high_ptr, low_ptr
	);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		load_data <= 1; new_high_ptr <= 0; new_mid_ptr <= 0; new_low_ptr <= 0; out_addr <= 0; target <= 17; data <= 0; @(posedge clk); @(posedge clk);
		load_data <= 0; new_mid_ptr <= 1; @(posedge clk); @(posedge clk);
		new_high_ptr <= 1; @(posedge clk); @(posedge clk);
		new_high_ptr <= 0; new_low_ptr <= 1; @(posedge clk); @(posedge clk);
		out_addr <= 1; @(posedge clk); @(posedge clk);
		data <= 17; @(posedge clk); @(posedge clk);
		$stop;
	end
endmodule
