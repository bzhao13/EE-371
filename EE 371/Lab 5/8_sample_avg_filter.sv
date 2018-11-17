
module 8_sample_avg_filter 
(
	input logic clk, enable,
	input logic signed [23:0] in,
	output logic [23:0] out
);

	logic signed [23:0] q1, q2, q3, q4, q5, q6, q7;
	
	// Samples
	always_ff @(posedge clk) begin
		if (enable) begin
			q1 <= in;
			q2 <= q1;
			q3 <= q2;
			q4 <= q3;
			q5 <= q4;
			q6 <= q5;
			q7 <= q6;
		end else begin
			q1 <= 0;
			q2 <= 0;
			q3 <= 0;
			q4 <= 0;
			q5 <= 0;
			q6 <= 0;
			q7 <= 0;
		end
	end
	
	assign out = (in / 8) + (q1 / 8) + (q2 / 8) + (q3 / 8) + (q4 / 8) + (q5 / 8) + (q6 / 8) + (q7 / 8);	
endmodule



module t2_testbench ();
	logic clk;
	logic signed [23:0] in;
	logic [23:0] out;
	logic enable;
	
	t2 dut (.*);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end	
		integer i;
		initial begin
			

			enable <= 1;
			@(posedge clk);
			in <= 256;
			for (i = 0; i < 15; i++)
				@(posedge clk);
			in <= 512;
			for (i = 0; i < 15; i++)
				@(posedge clk);
			$stop;
		
	end
	
endmodule 
	
	
