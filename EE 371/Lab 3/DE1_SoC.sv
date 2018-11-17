
module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, CLOCK_50, 
	VGA_R, VGA_G, VGA_B, VGA_BLANK_N, VGA_CLK, VGA_HS, VGA_SYNC_N, VGA_VS);
	
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY;
	input logic [9:0] SW;

	input CLOCK_50;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_BLANK_N;
	output VGA_CLK;
	output VGA_HS;
	output VGA_SYNC_N;
	output VGA_VS;
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = SW;
	
	// Generate clk off of CLOCK_50, whichClock picks rate.
	logic [31:0] clk;
	parameter whichClock = 10; // clock for drawing
	parameter whichClock2 = 1; // clock for clear screen
	clock_divider cdiv (CLOCK_50, clk);
	
	logic reset, clear, compD, compC;
	assign reset = ~KEY[3]; // reset the animation
	assign clear = ~KEY[2]; // clear screen
	
	logic [10:0] xd0, yd0, xd1, yd1, xDraw, yDraw; // points for drawing
	logic [10:0] xc0, yc0, xc1, yc1, xClear, yClear; // points for clear screen
	logic [10:0] x, y; // points into frame buffer
	
	VGA_framebuffer fb(.clk50(CLOCK_50), .reset(1'b0), .x, .y,
				.pixel_color(~clear), .pixel_write(1'b1),
				.VGA_R, .VGA_G, .VGA_B, .VGA_CLK, .VGA_HS, .VGA_VS,
				.VGA_BLANK_n(VGA_BLANK_N), .VGA_SYNC_n(VGA_SYNC_N));	
	
	// Line drawer for animation
	line_drawer lines(.clk(CLOCK_50), .reset, .x0(xd0), .y0(yd0), .x1(xd1), .y1(yd1), .x(xDraw), .y(yDraw), .complete(compD));

	// Point picker for animation
	always_ff @(posedge clk[whichClock]) begin
		if (reset) begin
			xd0 <= 160;
			yd0 <= 0;
			xd1 <= 40;
			yd1 <= 200;
		end else if (compD && (xd1 < 280)) begin
			xd1 += 1;
		end else if (compD && (xd1 == 280)) begin // finish at single point (280, 0)
			xd0 <= 280;
			yd0 <= 0;
			xd1 <= 280;
			yd1 <= 0;
		end
	end
	
	// Line drawer for clear screen
	line_drawer clear_screen(.clk(CLOCK_50), .reset(1'b0), .x0(xc0), .y0(yc0), .x1(xc1), .y1(yc1), .x(xClear), .y(yClear), .complete(compC));
	
	// Point picker for clear screen
	always_ff @(posedge clk[whichClock2]) begin
		if (compC) begin
			if (xc1 >= 640) begin
				xc0 <= 0;
				yc0 <= 0;
				xc1 <= 0;
				yc1 <= 480;
			end else begin // sweeping vertical line
				xc0 += 1;
				xc1 += 1;
			end
		end
	end
	
	always_comb begin
		if (clear) begin
			x = xClear;
			y = yClear;
		end else begin
			x = xDraw;
			y = yDraw;
		end
	end
	
	initial begin
		// first line from (160, 0) to (40, 200)
		xd0 = 160;
		yd0 = 0;
		xd1 = 40;
		yd1 = 200;
		
		// vertical line at left side
		xc0 = 0;
		yc0 = 0;
		xc1 = 0;
		yc1 = 480;
	end	
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
