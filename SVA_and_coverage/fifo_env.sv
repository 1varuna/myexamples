/*
* File: test.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo env class which intantiates testench components
* like generator, master driver, slave driver and launches parallel
* threads for the run tasks in each of the classes.  
*/

`ifndef FIFO_ENV
`define FIFO_ENV

class fifo_env #(parameter FIFO_WIDTH = 32,parameter FIFO_DEPTH=32);
	// Instantiate Driver and Generator classes
	fifo_gen # (.FIFO_WIDTH(FIFO_WIDTH),.FIFO_DEPTH(FIFO_DEPTH)) gen;	// Fifo Generator
	fifo_drv drv;								// Fifo Master Driver
	fifo_slv_drv slv_drv;							// Fifo slave driver
	fifo_input_mon in_mon;							// Input monitor
	fifo_output_mon out_mon;						// Output monitor
	fifo_sb sb;								// Fifo Scoreboard

	// Create a mailbox to send/receive data packets

	mailbox gen2drv;
	mailbox gen2slv_drv;
	mailbox in_mon2sb;
	mailbox out_mon2sb;

	// Instantiate a virtual interface
	virtual fifo_intf fifo_vif;

	// User-defined class constructor

	function new(virtual fifo_intf vif);
		this.fifo_vif = vif;
		
		/* TODO:Check if necessary to use new() on mailbox*/
		gen2drv = new();
		gen2slv_drv = new();
		in_mon2sb = new();	
		out_mon2sb = new();	

		// instantiate al TB classes

		drv = new(vif,gen2drv);
		gen = new(gen2drv,gen2slv_drv);
		slv_drv = new(vif,gen2slv_drv);
		in_mon = new(vif,in_mon2sb);
		out_mon = new(vif,out_mon2sb);
		sb = new(in_mon2sb,out_mon2sb);

	endfunction

	task pre_test;			// Run the reset task
		//drv.reset();
	endtask
	
	task test;
		fork
			gen.run();
			drv.run();
			slv_drv.run();
			in_mon.sample();
			out_mon.sample();
			sb.run();
		join_any
	endtask

	task post_test;
		// wait();	wait till end of generation is triggered
		// wait();	wait till repeat loop has iterated through no.
		// of generated transactions
	endtask

	task run;
		//pre_test;
		test;
		//post_test;
		#1000
		$finish;
	endtask

endclass
`endif
