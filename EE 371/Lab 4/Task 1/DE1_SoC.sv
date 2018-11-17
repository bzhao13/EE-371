
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	
	
	// Top level inputs
	logic reset, start, sync;
	logic [7:0] data_A;

	// Top level outputs
	logic [3:0] result;
	
	// Key and switch assignments
	assign reset = ~KEY[0];
	assign data_A = {SW[7], SW[6], SW[5], SW[4], SW[3], SW[2], SW[1], SW[0]};
	
	// sync start
	flipflop U1(.D(SW[8]), .reset, .clk(CLOCK_50), .Q(sync));
	flipflop U2(.D(sync), .reset, .clk(CLOCK_50), .Q(start));
	
	// Bit counter
	count_bits c1(.clk(CLOCK_50), .reset, .start, .data_A, .done(LEDR[9]), .result);

	display d1(.in(result), .hex(HEX0));
	assign HEX5 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX1 = 7'b1111111;
endmodule
