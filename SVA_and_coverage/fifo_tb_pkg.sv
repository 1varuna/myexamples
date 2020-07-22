/*
* File: fifo_tb_pkg.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Package containing all testbench files.
	* Called in test.sv file, included in the fifo_top.sv file 
*/

// NOTE: Package cannot include Interface file!!
package fifo_tb_pkg;

	`include "defines.sv"		// Contains defines for FIFO DUT
	`include "fifo_trans.sv"
	`include "fifo_gen.sv"
	`include "fifo_drv.sv"
	`include "fifo_slv_drv.sv"
	`include "fifo_env.sv"
	
	/*
	* Coverage and Assertions
	*/

	//`include "fifo_assertions.sv"
	//`include "fifo_coverage.sv"
	
	/*
	*	TODO Include test files here
	*/

endpackage
