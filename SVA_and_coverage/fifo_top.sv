module fifo_top;		// Testbench top file
	// Clock gen logic
	bit clk;
	forever begin
		#clk = ~clk;
	end
	
	bit rstN;
	initial begin
		rstN = 0;
		#5 rstN = 0;
	end
	
	// instantiate interface to connect DUT and test
	fifo_intf intf(clk,rstN);
	test t1(intf);

	// Connect DUT and interface signals
	fifo DUT(
	.clk(intf.clk),
	.rstN(intf.rstN),
	.wr_en(intf.wr_en),
	.read_en(intf.rd_en),
	.data_in(intf.data_in),
	.data_out(intf.data_out),
	.empty(intf.empty),
	.full(intf.full)
	);

	initial begin
		$dumpfile("dump.wlf");
		$dumpvars;
	end
endmodule
