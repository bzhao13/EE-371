
module t1_datapath(
	input logic clk, reset,
	input logic [7:0] data_A,
	input logic load_data, inc_counter, r_shift,
	output logic A_eq_0, a0,
	output logic [3:0] result
	);

	logic [7:0] A;
	
	always_ff @(posedge clk) begin
		if (reset) begin
			A <= 8'b0;
			result <= 4'b0;
		end
		if (load_data) begin
			A <= data_A;
			result <= 4'b0;
		end
		if (inc_counter)
			result <= result + 1;
		if (r_shift)	
			A <= A >> 1;
	end
	
	// Feedback output to control
	assign A_eq_0 = (A == 8'b0);
	assign a0 = (A[0]);
endmodule

module t1_datapath_tb();
	logic clk, reset;
	logic [7:0] data_A;
	logic load_data, inc_counter, r_shift;
	logic A_eq_0, a0;
	logic [3:0] result;
	
	t1_datapath dut(clk, reset, data_A, load_data, inc_counter, r_shift, A_eq_0, a0, result);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; data_A <= 32; load_data <= 0; inc_counter <= 0; r_shift <= 0; @(posedge clk);
		reset <= 0; @(posedge clk);
		load_data <= 1; @(posedge clk); @(posedge clk);
		load_data <= 0; @(posedge clk); @(posedge clk);
		inc_counter <= 1; r_shift <= 1; @(posedge clk); @(posedge clk);
		inc_counter <= 0; r_shift <= 0; @(posedge clk); @(posedge clk);
		inc_counter <= 1; r_shift <= 1; @(posedge clk); @(posedge clk);
		inc_counter <= 0; r_shift <= 0; @(posedge clk); @(posedge clk);
		inc_counter <= 1; r_shift <= 1; @(posedge clk); @(posedge clk);
		inc_counter <= 0; r_shift <= 0; @(posedge clk); @(posedge clk);
		inc_counter <= 1; r_shift <= 1; @(posedge clk); @(posedge clk);
		inc_counter <= 0; r_shift <= 0; @(posedge clk); @(posedge clk);
		$stop;
	end
endmodule

