
module counter(clk, reset, out);
	input logic clk, reset;
	output logic [4:0] out;
		
	always_ff @(posedge clk) begin
		if (reset) begin
			out <= 0;
		end else begin
			if (out < 32) begin
				out <= out + 1;
			end else begin // restart counter
				out <= 0;
			end
		end
	end
endmodule
