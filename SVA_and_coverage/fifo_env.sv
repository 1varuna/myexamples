`include "fifo_trans.sv"
`include "fifo_gen.sv"
`include "fifo_drv.sv"

class fifo_env #(parameter FIFO_WIDTH = 32,FIFO_DEPTH=32);
	// Instantiate Driver and Generator classes
	fifo_gen #(FIFO_WIDTH) gen;
	fifo_drv drv;

	// Create a mailbox to send/receive data packets

	mailbox gen2drv;
	// Instantiate a virtual interface
	virtual fifo_intf fifo_vif;

	// User-defined class constructor

	function new(virtual fifo_intf vif);
		this.fifo_vif = vif;
		gen2drv = new();

		// instantiate driver and generator
		drv = new(vif,gen2drv);
		gen = new(gen2drv);
	endfunction

	task pre_test;			// Run the reset task
		drv.reset();
	endtask
	
	task test;
		fork
			gen.run();
			drv.run();
		join_any
	endtask

	task post_test;
		// wait();	wait till end of generation is triggered
		// wait();	wait till repeat loop has iterated through no.
		// of generated transactions
	endtask

	task run;
		pre_test;
		test;
		//post_test;
		$finish;
	endtask

endclass
