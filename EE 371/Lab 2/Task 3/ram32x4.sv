
module ram32x4(addr, clk, din, we, dout);
	input logic clk, we;
	input logic [4:0] addr;
	input logic [3:0] din;
	output logic [3:0] dout;
	
	// Signal declaration
	logic [3:0] memory_array [0:31];
	logic [3:0] data_reg;
	
	always_ff @(posedge clk) begin
		// Write
		if (we)
			memory_array[addr] <= din;
		// Read
		data_reg <= memory_array[addr];
	end
	
	// Output
	assign dout = data_reg;
endmodule

module ram32x4_tb();
	logic clk, we;
	logic [4:0] addr;
	logic [3:0] din, dout;
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	ram32x4 dut(addr, clk, din, we, dout);
	
	initial begin
		we <= 0; addr <= 0; din <= 0; @(posedge clk);
		we <= 1; @(posedge clk);
		addr <= 17; din <= 10; @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
		addr <= 25; din <= 9; @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
		addr <= 13; din <= 4; @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
		addr <= 27; din <= 5; @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
		addr <= 1; din <= 11; @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
		addr <= 6; din <= 15; @(posedge clk); @(posedge clk); @(posedge clk); @(posedge clk);
		we <= 0; addr <= 0; din <= 0; @(posedge clk); @(posedge clk);
		addr <= 17; @(posedge clk); @(posedge clk);
		addr <= 25; @(posedge clk); @(posedge clk);
		addr <= 13; @(posedge clk); @(posedge clk);
		addr <= 27; @(posedge clk); @(posedge clk);
		addr <= 1; @(posedge clk); @(posedge clk);
		addr <= 6; @(posedge clk); @(posedge clk);
		$stop;
	end
endmodule
