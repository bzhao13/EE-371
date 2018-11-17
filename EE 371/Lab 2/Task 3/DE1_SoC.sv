
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	
	logic [4:0] addr;
	logic [3:0] din;
	assign addr = SW[8:4];
	assign din = SW[3:0];
	assign we = SW[9];
	assign clk = ~KEY[0];
	logic [3:0] dout;
	
	ram32x4 ram(.addr, .clk, .din, .we, .dout);
	
	// Hex displays for the address
	display addr_0(.in({addr[3:0]}), .hex(HEX4));
	display addr_1(.in({3'b000, addr[4]}), .hex(HEX5));
	
	// Hex displays for the data in
	display din_disp(.in(din), .hex(HEX2));
	
	// Hex displays for the read
	display dout_disp(.in(dout), .hex(HEX0));
endmodule
