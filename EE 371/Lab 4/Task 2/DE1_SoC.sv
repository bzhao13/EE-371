
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	
	logic reset, start, sync;
	logic [7:0] target;
	logic [4:0] addr, mid_ptr, high_ptr, low_ptr;
	logic [2:0] state;
	logic [7:0] data;
	logic [7:0] hex1, hex0;
	
	assign reset = ~KEY[0];
	assign target = {SW[7], SW[6], SW[5], SW[4], SW[3], SW[2], SW[1], SW[0]};
	
	
	// sync start
	flipflop U1(.D(SW[8]), .reset, .clk(CLOCK_50), .Q(sync));
	flipflop U2(.D(sync), .reset, .clk(CLOCK_50), .Q(start));
	
	binary_search bi(
	.clk(CLOCK_50), .reset, .start,
	.target,
	.found(LEDR[9]),
	.addr, .mid_ptr, .high_ptr, .low_ptr,
	.state,
	.data
	);

	// Displays
	display d0(.in(addr[3:0]), .hex(HEX0));
	display d1(.in({3'b000, addr[4]}), .hex(HEX1));
	assign HEX5 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX2 = 7'b1111111;
endmodule
