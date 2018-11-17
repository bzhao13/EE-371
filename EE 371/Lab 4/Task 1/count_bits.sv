 module count_bits(
	input logic clk, reset, start,
	input logic [7:0] data_A,
	output logic done,
	output logic [3:0] result
	);
	
	// Signals from control to datapath
	logic load_data, inc_counter, r_shift;
	
	// Feedback from datapath to control
	logic A_eq_0, a0;
	
	// Control module
	t1_control cont(.clk, .reset, .start, .A_eq_0, .a0, .done, .load_data, .inc_counter, .r_shift);
	
	// Datapath module
	t1_datapath data(.clk, .reset, .data_A, .load_data, .inc_counter, .r_shift, .A_eq_0, .a0, .result);

endmodule

module count_bits_tb();
	logic clk, reset, start;
	logic [7:0] data_A;
	logic done;
	logic [3:0] result;
	
	count_bits dut(clk, reset, start, data_A, done, result);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	integer i = 0;
	initial begin
		reset <= 1; start <= 0; data_A <= 19; @(posedge clk);
		reset <= 0; @(posedge clk); @(posedge clk);
		start <= 1; @(posedge clk); @(posedge clk);
		for (i = 0; i < 20; i++)
			@(posedge clk);
		$stop;
	end
endmodule
