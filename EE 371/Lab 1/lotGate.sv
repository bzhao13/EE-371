
module lotGate(clk, reset, a, b, enter, exit);
	input logic clk, reset, a, b;
	
	output logic enter, exit;
	
	// State variables
	enum {none, enter1, exit1, enter2, exit2, enter3, exit3, enter4, exit4} ps, ns;
	
	// Next state logic
	always_comb begin
		case (ps)
			none:		if (a & ~b)
							ns = enter1;
						else if (~a & b)
							ns = exit1;
						else
							ns = none;
			enter1:	if (a & b)
							ns = enter2;
						else if (a & ~b)
							ns = enter1;
						else
							ns = none;
			exit1:	if (a & b)
							ns = exit2;
						else if (~a & b)
							ns = exit1;
						else
							ns = none;
			enter2:	if (~a & b)
							ns = enter3;
						else if (a & b)
							ns = enter2;
						else if (~a & b)
							ns = enter1;
						else
							ns = none;
			exit2:	if (a & ~b)
							ns = exit3;
						else if (a & b)
							ns = exit2;
						else if (a & ~b)
							ns = exit1;
						else
							ns = none;
			enter3:	if (a & b)
							ns = enter2;
						else if (~a & b)
							ns = enter3;
						else if (~a & ~b)
							ns = enter4;
						else
							ns = enter1;
			exit3:	if (a & b)
							ns = exit2;
						else if (a & ~b)
							ns = exit3;
						else if (~a & ~b)
							ns = exit4;
						else
							ns = exit1;
			enter4:	ns = none;
			exit4: 	ns = none;
		endcase
	end
	
	// Ouput logic
	assign enter = (ns == enter4);
	assign exit = (ns == exit4);
		
	// DFFs
	always_ff @(posedge clk) begin
		if (reset)
			ps <= none;
		else
			ps <= ns;
	end
endmodule

module lotGate_tb();
	logic clk, reset, a, b, enter, exit;
	
	lotGate dut(clk, reset, a, b, enter, exit);
	
	// Set up the clock
	parameter CLOCK_PERIOD = 100;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Set up initial inputs to the design
	initial begin
		reset <= 1;	a <= 1;	b <= 1;	@(posedge clk);
						a <= 0;	b <= 0;	@(posedge clk);
		reset <= 0;							@(posedge clk);
						a <= 1;	b <= 0;	@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
						a <= 1;	b <= 1;	@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
						a <= 0;	b <= 0;	@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
						a <= 1;	b <= 0;	@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
						a <= 0;	b <= 0;	@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
						a <= 0;	b <= 1;	@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
						a <= 1;	b <= 1;	@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
												$stop;
												
	end
endmodule
