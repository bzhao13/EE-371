
module display(cars, count1, count10, hex5, hex4, hex3, hex2, hex1, hex0);
	input logic [4:0] cars;
	input logic [3:0] count1, count10;
	
	output logic [6:0] hex5, hex4, hex3, hex2, hex1, hex0;

	
	always @(*) begin
		case (cars)
			default: begin // Standard parking lot display when it is neither full nor empty
							hex5 = 7'b1111111;
							hex4 = 7'b1111111;
							hex3 = 7'b1111111;
							hex2 = 7'b1111111;
							case (count1) // Display for the ones digit
								4'b0000: hex0 = 7'b1000000;	// 0
								4'b0001: hex0 = 7'b1111001;	// 1
								4'b0010: hex0 = 7'b0100100;	// 2
								4'b0011: hex0 = 7'b0110000;	// 3
								4'b0100: hex0 = 7'b0011001;	// 4
								4'b0101: hex0 = 7'b0010010;	// 5
								4'b0110: hex0 = 7'b0000010;	// 6
								4'b0111: hex0 = 7'b1111000;	// 7
								4'b1000: hex0 = 7'b0000000;	// 8
								4'b1001: hex0 = 7'b0010000;	// 9
								default: hex0 = 7'b1111111;
							endcase // Display for the tens digit
							case (count10)
								4'b0000: hex1 = 7'b1111111;
								4'b0001: hex1 = 7'b1111001;	// 1
								4'b0010: hex1 = 7'b0100100;	// 2
								4'b0011: hex1 = 7'b0110000;	// 3
								4'b0100: hex1 = 7'b0011001;	// 4
								4'b0101: hex1 = 7'b0010010;	// 5
								4'b0110: hex1 = 7'b0000010;	// 6
								4'b0111: hex1 = 7'b1111000;	// 7
								4'b1000: hex1 = 7'b0000000;	// 8
								4'b1001: hex1 = 7'b0010000;	// 9
								default: hex1 = 7'b1111111;
							endcase
						end
			25: 		begin // Display when parking lot is full
							hex5 = 7'b0001110;	// F
							hex4 = 7'b1000001;	// U
							hex3 = 7'b1000111;	// L
							hex2 = 7'b1000111;	// L
							hex1 = 7'b0100100;	// 2
							hex0 = 7'b0010010;	// 5
						end
			0:			begin // Display when parking lot is empty
							hex5 = 7'b0000110;	// E
							hex4 = 7'b1101010;	// m
							hex3 = 7'b0001100;	// P
							hex2 = 7'b0000111;	// t
							hex1 = 7'b0010001;	// y
							hex0 = 7'b1000000;	// 0
						end
		endcase
	end	
endmodule

module display_tb();
	logic [4:0] cars;
	logic [3:0] count1, count10;
	logic [6:0] hex5, hex4, hex3, hex2, hex1, hex0;
	
	display dut(cars, count1, count10, hex5, hex4, hex3, hex2, hex1, hex0);
	
	integer i;
	initial begin
		count10 = 0;
		for(i = 0; i < 10; i++) begin
			cars = i; count1 = i; #10;
		end
		for(i = 0; i < 10; i++) begin
			cars = i + 10; count1 = i; count10 = 1; #10;
		end
		for(i = 0; i < 6; i++) begin
			cars = i + 20; count1 = i; count10 = 2; #10;
		end
		$stop;
	end
endmodule
