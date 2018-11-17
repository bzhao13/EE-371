
module binary_search(
	input logic clk, reset, start,
	input logic [7:0] target,
	output logic found, // found also output of system
	output logic [4:0] addr, mid_ptr, high_ptr, low_ptr,
	output logic [2:0] state,
	output logic [7:0] data
	);
		
	// data to cont
	logic mid_val_eq_target, eq_ptrs, target_gt_mid_val, target_lt_mid_val, found_val;
	
	// cont to data
	logic load_data, new_high_ptr, new_mid_ptr, new_low_ptr, out_addr;
	
	
	t2_control control(
		.clk, .reset,
		.start, .mid_val_eq_target, .eq_ptrs, .target_gt_mid_val, .target_lt_mid_val, .found_val,
		.load_data, .new_high_ptr, .new_mid_ptr, .new_low_ptr, .out_addr, .found,
		.state
	);
	
	t2_datapath datapath(
		.clk, .reset,
		.target, .data,
		.load_data, .new_high_ptr, .new_mid_ptr, .new_low_ptr, .out_addr,
		.mid_val_eq_target, .eq_ptrs, .target_gt_mid_val, .target_lt_mid_val, .found_val,
		.addr, .mid_ptr, .high_ptr, .low_ptr
	);
	
	ram32x8 ram(.address(mid_ptr), .clock(clk), .din(8'bX), .wren(1'b0), .dout(data));
endmodule

`timescale 1 ps / 1 ps
module binary_search_tb();
	logic clk, reset, start;
	logic [7:0] target;
	logic found; // found also output of system
	logic [4:0] addr, mid_ptr, high_ptr, low_ptr;
	logic [2:0] state;
	logic [7:0] data;
	
	binary_search dut(
	clk, reset, start,
	target,
	found, // found also output of system
	addr, mid_ptr, high_ptr, low_ptr,
	state,
	data
	);
	
	// Set up the clock.
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	integer i;
	initial begin
		reset <= 1; start <= 0; target <= 8; @(posedge clk); @(posedge clk);
		reset <= 0; @(posedge clk); @(posedge clk);
		start <= 1;
		for (i = 0; i < 20; i++)
			@(posedge clk);
		reset <= 1; start <= 0; target <= 30; @(posedge clk); @(posedge clk);
		reset <= 0; @(posedge clk); @(posedge clk);
		start <= 1;
		for (i = 0; i < 20; i++)
			@(posedge clk);
		reset <= 1; start <= 0; target <= 0; @(posedge clk); @(posedge clk);
		reset <= 0; @(posedge clk); @(posedge clk);
		start <= 1;
		for (i = 0; i < 20; i++)
			@(posedge clk);
		reset <= 1; start <= 0; target <= 20; @(posedge clk); @(posedge clk);
		reset <= 0; @(posedge clk); @(posedge clk);
		start <= 1;
		for (i = 0; i < 20; i++)
			@(posedge clk);
		reset <= 1; start <= 1; target <= 0; @(posedge clk); @(posedge clk);
		for (i = 0; i < 10; i++)
			@(posedge clk);
		reset <= 0; @(posedge clk); @(posedge clk);
		for (i = 0; i < 25; i++)
			@(posedge clk);
		reset <= 1; start <= 1; target <= 0; @(posedge clk); @(posedge clk);
		for (i = 0; i < 10; i++)
			@(posedge clk);
		reset <= 0; @(posedge clk); @(posedge clk);
		for (i = 0; i < 25; i++)
			@(posedge clk);
		reset <= 1; start <= 1; target <= 0; @(posedge clk); @(posedge clk);
		for (i = 0; i < 10; i++)
			@(posedge clk);
		reset <= 0; @(posedge clk); @(posedge clk);
		for (i = 0; i < 25; i++)
			@(posedge clk);
		reset <= 1; start <= 0; target <= 8; @(posedge clk); @(posedge clk);
		reset <= 0; @(posedge clk); @(posedge clk);
		start <= 1;
		for (i = 0; i < 20; i++)
			@(posedge clk);
		reset <= 1; start <= 0; target <= 30; @(posedge clk); @(posedge clk);
		reset <= 0; @(posedge clk); @(posedge clk);
		start <= 1;
		for (i = 0; i < 20; i++)
			@(posedge clk);
		$stop;
	end
endmodule
