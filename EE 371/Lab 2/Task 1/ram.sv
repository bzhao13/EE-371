
module ram(clk, addr, din, we, dout);
	input logic clk;
	input logic [4:0] addr;
	input logic we;
	input logic [3:0] din;
	output logic [3:0] dout;
	
	ram32x4 ram(.address(addr), .clock(clk), .data(din), .wren(we), .q(dout));
endmodule

`timescale 1 ps / 1 ps

module ram_tb();
	logic clk, we;
	logic [4:0] addr;
	logic [3:0] din, dout;
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	ram dut(clk, addr, din, we, dout);
	
	initial begin
		we <= 0; addr <= 0; din <= 0; @(posedge clk);
		we <= 1; @(posedge clk);
		addr <= 17; din <= 10; @(posedge clk); @(posedge clk);
		addr <= 25; din <= 9; @(posedge clk); @(posedge clk);
		addr <= 13; din <= 4; @(posedge clk); @(posedge clk);
		addr <= 27; din <= 5; @(posedge clk); @(posedge clk);
		addr <= 1; din <= 11; @(posedge clk); @(posedge clk);
		addr <= 6; din <= 15; @(posedge clk); @(posedge clk);
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
