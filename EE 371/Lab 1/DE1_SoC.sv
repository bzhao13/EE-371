

module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW, GPIO_0);
	input logic CLOCK_50; // 50MHz clock.
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	output logic [35:0] GPIO_0;
	input logic [3:0] KEY; // True when not pressed, False when pressed
	input logic [9:0] SW;
		
	// Inputs and outputs
	assign reset = SW[9];
	assign a = ~KEY[0];
	assign b = ~KEY[1];
	assign GPIO_0[14] = ~KEY[0];
	assign GPIO_0[17] = ~KEY[1];
	logic come, go;
	logic [4:0] cars;
	logic [3:0] count1, count10;
	
	// Logic of the parking lot gate sensors
	lotGate Parking(.clk(CLOCK_50), .reset, .a, .b, .enter(come), .exit(go));
	
	// Counter for the total number of cars in the parking lot
	counter num(.clk(CLOCK_50), .reset, .in(come), .out(go), .count1, .count10, .cars);
	
	// Displays the number of cars in the parking lot
	display(.cars, .count1, .count10, .hex5(HEX5), .hex4(HEX4), .hex3(HEX3), .hex2(HEX2), .hex1(HEX1), .hex0(HEX0));
endmodule
