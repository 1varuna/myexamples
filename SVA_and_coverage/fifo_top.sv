`include "defines.sv"

module fifo_top;		// Testbench top file
	// Clock gen logic
	bit clk;
	
	always begin
		#5 clk = ~clk;
	end
	
	bit rstN;
	initial begin
		rstN = 0;
		#5 rstN = 0;
	end
	
	// instantiate interface to connect DUT and test
	//fifo_intf intf(clk,rstN);
	fifo_intf 	#(.FIFO_WIDTH(`DEF_FIFO_WIDTH),
			.FIFO_DEPTH(`DEF_FIFO_DEPTH))
			intf 	
				(.clk(clk),
				.rstN(rstN));

	test t1(intf);

	// Connect DUT and interface signals
	fifo 	 	#(.FIFO_WIDTH(`DEF_FIFO_WIDTH),
			.FIFO_DEPTH(`DEF_FIFO_DEPTH))
			DUT	(
			.clk(intf.clk),
			.rstN(intf.rstN),
			.write_en(intf.wr_en),
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
