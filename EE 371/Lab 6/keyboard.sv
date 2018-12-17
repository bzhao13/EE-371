module keyboard (
	input logic CLOCK_50,
	input logic PS2_DAT, // PS2 data line
	input logic PS2_CLK, // PS2 clock line
	input logic reset,
	output logic [9:0] keyboardNum
);
	logic [7:0] outCode;
	logic valid;
	logic makeBreak;
	logic keySignal1, keySignal2;
	keyboard_press_driver k (.CLOCK_50, .valid, .makeBreak, .outCode, .PS2_DAT, .PS2_CLK, .reset);
	//userInput u (.Clock(CLOCK_50), .L(key1), .R(key2), .Reset(reset), .KEY3(keySignal1), .KEY0(keySignal2),
	//.leftWin(0), .rightWin(0), .HEX5(0), .HEX0(0));
	//no_holding_key n (.clk(CLOCK_50), .in(keySignal1), .out(key1), .reset);
	always_comb begin
		//key1 = (outCode == 8'b01110101) ? 1: 0;
		//key2 = makeBreak;
		//key3 = (outCode == 8'b01110101 && makeBreak) ? 1:0;
		keyboardNum[0] = (outCode == 8'b01000101 && makeBreak) ? 1:0;
		keyboardNum[1] = (outCode == 8'b00010110 && makeBreak) ? 1:0;
		keyboardNum[2] = (outCode == 8'b00011110 && makeBreak) ? 1:0;
		keyboardNum[3] = (outCode == 8'b00100110 && makeBreak) ? 1:0;
		keyboardNum[4] = (outCode == 8'b00100101 && makeBreak) ? 1:0;
		keyboardNum[5] = (outCode == 8'b00101110 && makeBreak) ? 1:0;
		keyboardNum[6] = (outCode == 8'b00110110 && makeBreak) ? 1:0;
		keyboardNum[7] = (outCode == 8'b00111101 && makeBreak) ? 1:0;
		keyboardNum[8] = (outCode == 8'b00111110 && makeBreak) ? 1:0;
		keyboardNum[9] = (outCode == 8'b01000110 && makeBreak) ? 1:0;
	end
	
endmodule 