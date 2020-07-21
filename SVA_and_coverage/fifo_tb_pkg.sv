// Package cannot include Interface file!!
package fifo_tb_pkg;

	`include "defines.sv"		// Contains defines for FIFO DUT
	`include "fifo_trans.sv"
	`include "fifo_gen.sv"
	`include "fifo_drv.sv"
	`include "fifo_slave.sv"
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
