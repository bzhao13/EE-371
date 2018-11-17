
module n_sample_fir_filter 
#(
	parameter ADDR_WIDTH = 4, // ADDR_WIDTH = n number of samples in filter
	parameter DATA_WIDTH = 24,
	parameter DATA_DEPTH = 2**ADDR_WIDTH

)
(
	input logic clk, reset, enable,
	input logic signed [DATA_WIDTH - 1:0] in,
	output logic [DATA_WIDTH - 1:0] out
);

	// FIFO control signals
	logic [ADDR_WIDTH - 1:0] words_used;
	logic rd, wr;
	logic [DATA_WIDTH - 1:0] w_data;
	logic [DATA_WIDTH - 1:0] r_data;
	
	Altera_UP_SYNC_FIFO_sv #(.DATA_WIDTH(DATA_WIDTH), .DATA_DEPTH(DATA_DEPTH), .ADDR_WIDTH(ADDR_WIDTH)) fifo (.clk, .reset, .write_en(wr),
	.write_data(w_data), .read_en(rd), .fifo_is_empty(empty), .fifo_is_full(full), .words_used, .read_data(r_data));
	
	// Internal logic
	assign wr = enable;
	assign w_data = in / DATA_DEPTH;
	assign rd = enable & ((DATA_DEPTH - 1) == words_used);
	
	// Accumulator
	always_ff @(posedge clk) begin
		if (reset)
			out <= 0;
		else
			if (enable)
				if (out === 24'bx) // for valid simulation
					out <= w_data - r_data;
				else
					out <= out + w_data - r_data;
			else
				out <= 0;
	end	
endmodule 

`timescale 1ns/1ps
module t3_tb
#(
	parameter ADDR_WIDTH = 4,
	parameter DATA_WIDTH = 24,
	parameter DATA_DEPTH = 2**ADDR_WIDTH

)
();
	
	logic clk, reset, enable;
	logic signed [DATA_WIDTH - 1:0] in;
	logic [DATA_WIDTH - 1:0] out;
	
	t3 dut(.clk, .reset, .enable, .in, .out);
	
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	initial begin
		integer i;
		reset <= 1; enable <= 0; in <= 0; @(posedge clk);
		reset <= 1; enable <= 1; @(posedge clk);
		reset <= 0; in <= 256; @(posedge clk);
		for (i = 0; i < 30; i++) begin
			in <= 512; @(posedge clk);
		end
		$stop;
	end
endmodule
