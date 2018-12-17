// Warning: the Terasic VGA controller appears to have a few off-by-one errors.  If your code is very 
// sensitive to the EXACT number of pixels per line, you may have issues.  You have been warned!

module Filter #(parameter WIDTH = 640, parameter HEIGHT = 480)
(
	input logic		          		VGA_CLK, // 25 MHz clock
 
	// *** Incoming VGA signals ***
	// Colors.  0 if iVGA_BLANK_N is false.  Higher numbers brighter
	input logic		     [7:0]		iVGA_B, // Blue
	input logic		     [7:0]		iVGA_G, // Green
	input logic		     [7:0]		iVGA_R, // Red
	// Horizontal sync.  Low between horizontal lines.
	input logic		          		iVGA_HS,
	// Vertical sync.  Low between video frames.
	input logic		          		iVGA_VS,
	// Always zero
	input logic		          		iVGA_SYNC_N,
	// True in area not shown, false during the actual image.
 	input logic		          		iVGA_BLANK_N,

	// *** Outgoing VGA signals ***
	output logic		  [7:0]		oVGA_B,
	output logic		  [7:0]		oVGA_G,
	output logic		  [7:0]		oVGA_R,
	output logic		       		oVGA_HS,
	output logic		       		oVGA_VS,
	output logic		       		oVGA_SYNC_N,
 	output logic		       		oVGA_BLANK_N,
	
	// *** Board outputs ***
	output logic		     [6:0]		HEX0,
	output logic		     [6:0]		HEX1,
	output logic		     [6:0]		HEX2,
	output logic		     [6:0]		HEX3,
	output logic		     [6:0]		HEX4,
	output logic		     [6:0]		HEX5,
	output logic		     [9:0]		LEDR,

	// *** User inputs ***
	input logic 		     [1:0]		KEY, // Key[2] reserved for reset, key[3] for auto-focus.
	input logic			     [8:0]		SW,   // SW[9] reserved for auto-focus mode.
	input logic					[9:0] 	keyboardNum,
	input logic makeBreak,
	input logic [7:0] outCode
);

	
	always_comb begin
		if (makeBreak) begin
			if (outCode == 8'b00010110) begin // when the 1 key is pressed on the keyboard; half brightness level 1
				oVGA_R = iVGA_R / 2;
				oVGA_G = iVGA_G / 2;
				oVGA_B = iVGA_B / 2;
			end else if (outCode == 8'b00011110) begin // 2; brightness level 2
				oVGA_R = iVGA_R * 6 / 5 > 255 ? 255 : iVGA_R * 6 / 5;
				oVGA_G = iVGA_G * 6 / 5 > 255 ? 255 : iVGA_G * 6 / 5;
				oVGA_B = iVGA_B * 6 / 5 > 255 ? 255 : iVGA_B * 6 / 5;
			end else if (outCode == 8'b00100110) begin // 3; brightness level 3
				oVGA_R = iVGA_R * 7 / 5 > 255 ? 255 : iVGA_R * 7 / 5;
				oVGA_G = iVGA_G * 7 / 5 > 255 ? 255 : iVGA_G * 7 / 5;
				oVGA_B = iVGA_B * 7 / 5 > 255 ? 255 : iVGA_B * 7 / 5;
			end else if (outCode == 8'b00100101) begin // 4; brightness level 4
				oVGA_R = iVGA_R * 8 / 5 > 255 ? 255 : iVGA_R * 8 / 5;
				oVGA_G = iVGA_G * 8 / 5 > 255 ? 255 : iVGA_G * 8 / 5;
				oVGA_B = iVGA_B * 8 / 5 > 255 ? 255 : iVGA_B * 8 / 5;
			end else if (outCode == 8'b00101110) begin // 5; brightness level 5
				oVGA_R = iVGA_R * 9 / 5 > 255 ? 255 : iVGA_R * 9 / 5;
				oVGA_G = iVGA_G * 9 / 5 > 255 ? 255 : iVGA_G * 9 / 5;
				oVGA_B = iVGA_B * 9 / 5 > 255 ? 255 : iVGA_B * 9 / 5;
			end else if (outCode == 8'b00110110) begin // 6; brightness level 6
				oVGA_R = iVGA_R * 10 / 5 > 255 ? 255 : iVGA_R * 10 / 5;
				oVGA_G = iVGA_G * 10 / 5 > 255 ? 255 : iVGA_G * 10 / 5;
				oVGA_B = iVGA_B * 10 / 5 > 255 ? 255 : iVGA_B * 10 / 5;
			end else if (outCode == 8'b00111101) begin // 7; invert colors
				oVGA_R = 255 - iVGA_R;
				oVGA_G = 255 - iVGA_G;
				oVGA_B = 255 - iVGA_B;
			end else if (outCode == 8'b00111110) begin // 8; grayscale
				oVGA_R = (iVGA_R + iVGA_G + iVGA_B) / 3;
				oVGA_G = (iVGA_R + iVGA_G + iVGA_B) / 3;
				oVGA_B = (iVGA_R + iVGA_G + iVGA_B) / 3;
			end else if (outCode == 8'b01000110) begin // 9; increase contrast
				oVGA_R = (iVGA_R < 127) ? (iVGA_R * 3 / 5) : ((iVGA_R * 8 / 5) > 255 ? 255 : (iVGA_R * 8 / 5));
				oVGA_G = (iVGA_G < 127) ? (iVGA_G * 3 / 5) : ((iVGA_G * 8 / 5) > 255 ? 255 : (iVGA_G * 8 / 5));
				oVGA_B = (iVGA_B < 127) ? (iVGA_B * 3 / 5) : ((iVGA_B * 8 / 5) > 255 ? 255 : (iVGA_B * 8 / 5));
			end else begin // default
				oVGA_R = iVGA_R;
				oVGA_G = iVGA_G;
				oVGA_B = iVGA_B;
			end
		end else begin // no keys are pressed
				oVGA_R = iVGA_R;
				oVGA_G = iVGA_G;
				oVGA_B = iVGA_B;
		end
		oVGA_HS = iVGA_HS;
		oVGA_VS = iVGA_VS;
		oVGA_SYNC_N = iVGA_SYNC_N;
		oVGA_BLANK_N = iVGA_BLANK_N;
	end
	
	assign HEX0 = '1;
	assign HEX1 = '1;
	assign HEX2 = '1;
	assign HEX3 = '1;
	assign HEX4 = '1;
	assign HEX5 = '1;
	assign LEDR = '0;
endmodule

module Filter_tb();
	logic clk;
	
	// VGA in
	logic [7:0] iVGA_B, iVGA_G, iVGA_R;
	logic iVGA_HS, iVGA_VS, iVGA_SYNC_N, iVGA_BLANK_N;

	// VGA out
	logic [7:0] oVGA_B, oVGA_G, oVGA_R;
	logic oVGA_HS, oVGA_VS, oVGA_SYNC_N, oVGA_BLANK_N;
	
	// *** Board outputs ***
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;

	// *** User inputs ***
	logic [1:0] KEY;
	logic [8:0] SW;
	logic [9:0] keyboardNum;
	logic makeBreak;
	logic [7:0] outCode;
	
	Filter dut (.VGA_CLK(clk), .*);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		iVGA_B <= 200; iVGA_G <= 200; iVGA_R <= 200; makeBreak <= 0; @(posedge clk);
		makeBreak <= 1; outCode <= 8'b00010110; @(posedge clk);
		outCode <= 8'b00011110; @(posedge clk);
		outCode <= 8'b00100110; @(posedge clk);
		outCode <= 8'b00100101; @(posedge clk);
		outCode <= 8'b00101110; @(posedge clk);
		outCode <= 8'b00110110; @(posedge clk);
		outCode <= 8'b00111101; @(posedge clk);
		outCode <= 8'b00111110; @(posedge clk);
		outCode <= 8'b01000110; @(posedge clk);
		outCode <= 0; @(posedge clk);
		$stop;
	end
endmodule
