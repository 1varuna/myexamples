class fifo_gen;

	rand fifo_trans trans;			// Create an instance of trans class

	mailbox mbx_out;			// Mailbox used to send data to driver (outward bound)
	rand bit[FIFO_WIDTH-1:0] data_in;	// Generate random data
       	rand bit wr_en;				// Generate wr_en randomly

	mailbox gen2drv;			// Outward bound (GEN-->DRV) packet 

	function new(mailbox mbx);		// fifo_gen class constructor 
		this.gen2drv = mbx;
	endfunction 

	task run;

		int num_data = $urandom(63,255);

		repeat(num_data) begin
			trans = new();
			if(!trans.randomize())
				$fatal("\tGEN:: Transaction class randomization failed! Exiting...");
			gen2drv.put(trans);
		end
	endtask	
endclass
