
module t1_control(
	input logic clk, reset, start,
	input logic A_eq_0, a0,
	output logic done,
	output logic load_data, inc_counter, r_shift
	);
	
	logic [1:0] ps, ns;
	parameter s1 = 2'b00;
	parameter s2 = 2'b01;
	parameter s3 = 2'b10;

	// Next state logic
	always @(ps, start, A_eq_0)
		case (ps)
			s1:	if (start)
						ns = s2;
					else
						ns = s1;
			s2:	if (A_eq_0)
						ns = s3;
					else
						ns = s2;
			s3:	if (start)
						ns = s3;
					else
						ns = s1;
		endcase

	// Output logic
	always @(ps, start, A_eq_0, a0) begin
		load_data = 0;
		inc_counter = 0;
		r_shift = 0;
		done = 0;
		
		case (ps)
			s1:	if (~start)
							load_data = 1;
			s2:	if (~A_eq_0) begin
						if (a0)
							inc_counter = 1;
						r_shift = 1;
					end
			s3: done = 1;
		endcase
	end
		
	// DFFs
	always_ff @(posedge clk)
		if (reset)
			ps <= s1;
		else
			ps <= ns;
endmodule

module t1_control_tb();
	logic clk, reset, start;
	logic A_eq_0, a0;
	logic done;
	logic load_data, inc_counter, r_shift;
	
	t1_control dut(clk, reset, start, A_eq_0, a0, done, load_data, inc_counter, r_shift);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; start <= 0; A_eq_0 <= 0; a0 <= 0; @(posedge clk); @(posedge clk);
		reset <= 0; start <= 1; @(posedge clk); @(posedge clk);
		a0 <= 1; @(posedge clk); @(posedge clk);
		A_eq_0 <= 1; @(posedge clk); @(posedge clk);
		start <= 1; @(posedge clk); @(posedge clk);
		$stop;
	end
endmodule
