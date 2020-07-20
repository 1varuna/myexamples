//`include "fifo_trans.sv"
class fifo_gen #(parameter FIFO_WIDTH=32);

	rand fifo_trans trans;			// Create an instance of trans class

	mailbox gen2drv;			// Outward bound (GEN-->DRV) packet 

	function new(mailbox mbx);		// fifo_gen class constructor 
		this.gen2drv = mbx;
	endfunction 

	task run;

		int num_data = $urandom_range(63,255);

		repeat(num_data) begin
			trans = new();
			if(!trans.randomize())
				$fatal("\tGEN:: Transaction class randomization failed! Exiting...");
			gen2drv.put(trans);
		end
	endtask	
endclass
