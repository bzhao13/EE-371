
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
	
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic [31:0] clk;
	parameter whichClock = 24;
	clock_divider cdiv (CLOCK_50, clk);
	
	logic [4:0] addr_w, addr_r;
	logic [3:0] din;
	assign addr_w = SW[8:4];
	assign din = SW[3:0];
	assign wren = SW[9];
	assign reset = ~KEY[0];
	logic [3:0] dout;
	
	ram32x4 ram(.clock(CLOCK_50), .data(din), .rdaddress(addr_r), .wraddress(addr_w), .wren, .q(dout));
	
	counter raddr(.clk(clk[whichClock]), .reset, .out(addr_r));
	
	// Hex displays for the write address
	display addr_w0(.in({addr_w[3:0]}), .hex(HEX4));
	display addr_w1(.in({3'b000, addr_w[4]}), .hex(HEX5));
	
	// Hex displays for the read address
	display addr_r0(.in({addr_r[3:0]}), .hex(HEX2));
	display addr_r1(.in({3'b000, addr_r[4]}), .hex(HEX3));
	
	// Hex displays for the data in
	display din_disp(.in(din), .hex(HEX1));
	
	// Hex displays for the read
	display dout_disp(.in(dout), .hex(HEX0));
endmodule

// divided_clocks[0] = 25MHz, [1] = 12.5Mhz, ... [23] = 3Hz, [24] = 1.5Hz, [25] = 0.75Hz, ...
module clock_divider (clock, divided_clocks);
	input logic clock;
	output logic [31:0] divided_clocks;
	
	initial begin
		divided_clocks <= 0;
	end
	
	always_ff @(posedge clock) begin
		divided_clocks <= divided_clocks + 1;
	end
endmodule
