
module flipflop(
	input logic D, reset, clk,
	output logic Q
	);
		
	always_ff @(posedge clk)
		if (reset)
			Q <= 0;
		else
			Q <= D;
endmodule
