/*
* File: fifo_top.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo top file containing instantiations of 
* interface, DUT, test. Also contains clock generation logic
* and reset logic.
*/

// Include and Import RTL files
//`include "fifo_rtl_pkg.sv"
//import fifo_rtl_pkg::*;

// Include and Import TB files
//`include "fifo_tb_pkg.sv"
//import fifo_tb_pkg::*;

`include "test.sv"

module fifo_top;		// Testbench top file
	// Clock gen logic
	bit clk;
	
	always begin
		#5 clk = ~clk;
	end
	
	
	wire wr_en;
	wire rd_en;
	wire [`DEF_FIFO_WIDTH-1:0] data_in;
	wire [`DEF_FIFO_WIDTH-1:0] data_out;
	wire empty;
	wire full;	

	logic rstN;
	
	initial begin
		rstN = 0;
		#100 rstN = 1;
	end
		
	// instantiate interface 
	fifo_intf 	#(.FIFO_WIDTH(`DEF_FIFO_WIDTH),
			.FIFO_DEPTH(`DEF_FIFO_DEPTH))
			intf 	
				(.clk(clk),
				.rstN(rstN),
				.wr_en(wr_en),			// write enable
				.data_in(data_in),		// Input Data
				.rd_en(rd_en),			// read enable
				.empty(empty),			// fifo empty
				.full(full),			// fifo full
				.data_out(data_out)		// Output data
			);
	
	
	// Connect DUT and interface signals
	fifo 	 	#(.FIFO_WIDTH(`DEF_FIFO_WIDTH),
			.FIFO_DEPTH(`DEF_FIFO_DEPTH))
			DUT	(
			.clk(intf.clk),
			.rstN(intf.rstN),
			.wr_en(intf.wr_en),
			.rd_en(intf.rd_en),
			.data_in(intf.data_in),
			.data_out(intf.data_out),
			.empty(intf.empty),
			.full(intf.full)
			);	
			
	

	test t1(intf);

	

	initial begin
		$dumpfile("dump.wlf");
		$dumpvars;
	end
endmodule
