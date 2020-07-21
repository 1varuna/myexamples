//`include "fifo_trans.sv"
class fifo_gen #(parameter FIFO_WIDTH=32, parameter FIFO_DEPTH=2**5);

	rand fifo_trans trans;			// Create an instance of trans class
	rand int num_data;			// Random number of data packets to be generated
	mailbox gen2drv;			// Outward bound (GEN-->DRV) packet 
	mailbox gen2slv_drv;			// Outward bound (GEN-->DRV) packet 
	
	constraint num_data_c{		// constraint on data generation
		num_data inside {
				[10:FIFO_DEPTH]
				};	
	}

	function new(mailbox m1, mailbox m2);		// fifo_gen class constructor 
		this.gen2drv = m1;
		this.gen2slv_drv = m2;
	endfunction 

	task run;

		//int num_data = $urandom_range(63,255);
		$display("No. of input data : %0d",num_data);	
		repeat(num_data) begin
			trans = new();
			if(!trans.randomize())
				$fatal("\tGEN:: Transaction class randomization failed! Exiting...");
			gen2drv.put(trans);
			gen2slv_drv.put(trans);
		end
	endtask	
endclass
