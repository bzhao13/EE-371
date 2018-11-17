
module counter(clk, reset, in, out, count1, count10, cars);
	input logic clk, reset, in, out;
	
	output logic [4:0] cars;
	output logic [3:0] count1, count10;
	
	/*
		Gereral 0 to 99 circular Up/down counter
		For this module, counter is limited from 0 to 25
		with circular restart disabled
	*/
	always_ff @(posedge clk) begin
		if (reset) begin
			count1 <= 0;
			count10 <= 0;
			cars <= 0;
		end else if (in && cars < 25) begin // Up counter when lot is not full and car enters
			cars <= cars + 1;
			if (count1 < 9) // increment ones digit
				count1 <= count1 + 1;
			else begin // increment tens digit if ones digit reaches 9
				if (count10 < 9)
					count10 <= count10 + 1;
				else // restart counter at 00 if counter goes above 99
					count10 <= 0;
				count1 <= 0;
			end
		end else if (out && cars > 0) begin // Down counter when lot is not empty can car leaves
			cars <= cars - 1;
			if (count1 > 0) // decrement ones digit
				count1 <= count1 - 1;
			else begin // decrement tens digit if ones digit reaches 0
				if (count10 > 0)
					count10 <= count10 - 1;
				else // restart counter at 99 if counter goes below 00
					count10 <= 9;
				count1 <= 9;
			end
		end
	end
endmodule

module counter_tb();
	logic clk, reset, in, out;
	logic [3:0] count1, count10;
	logic [4:0] cars;
	
	counter dut(clk, reset, in, out, count10, count1, cars);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up initial inputs to the design. Each line is a clock cycle.
	integer i;
	initial begin
		reset <= 1;	in <= 0; out <= 0; @(posedge clk);
		reset <= 0;	@(posedge clk);
		for(i=0; i<20; i++) begin
			in <= 1;	@(posedge clk);
			in <= 0; @(posedge clk);
		end
		for(i=0; i<10; i++) begin
			out <= 1;	@(posedge clk);
			out <= 0; @(posedge clk);
		end
		for(i=0; i<20; i++) begin
			in <= 1;	@(posedge clk);
			in <= 0; @(posedge clk);
		end
		$stop;
	end
endmodule
