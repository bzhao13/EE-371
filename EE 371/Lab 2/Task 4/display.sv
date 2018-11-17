
module display(in, hex);
	input logic [3:0] in;
	output logic [6:0] hex;
	
	always @(in) 
		case (in)
			0: hex = 7'b1000000;	// 0
			1: hex = 7'b1111001;	// 1
			2: hex = 7'b0100100;	// 2
			3: hex = 7'b0110000;	// 3
			4: hex = 7'b0011001;	// 4
			5: hex = 7'b0010010;	// 5
			6: hex = 7'b0000010;	// 6
			7: hex = 7'b1111000;	// 7
			8: hex = 7'b0000000;	// 8
			9: hex = 7'b0010000;	// 9
			10: hex = 7'b0001000;	// A
			11: hex = 7'b0000011;	// b
			12: hex = 7'b1000110;	// C
			13: hex = 7'b0100001;	// d
			14: hex = 7'b0000110;	// E
			15: hex = 7'b0001110;	// F
		endcase
endmodule
