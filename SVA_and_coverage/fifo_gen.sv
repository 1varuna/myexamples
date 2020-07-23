/*
* File: fifo_gen.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Generator class which generates input transactions
* and puts it onto a mailbox for the master and slave driver. 
	*/

       // Uncomment below for standalone compile
       //`include "fifo_trans.sv" 

       class fifo_gen #(parameter FIFO_WIDTH=32, parameter FIFO_DEPTH=2**5);

	       rand fifo_trans trans;			// Create an instance of trans class
	       rand int num_data;			// Random number of data packets to be generated
	       mailbox gen2drv;			// Outward bound (GEN-->DRV) packet 
	       mailbox gen2slv_drv;			// Outward bound (GEN-->DRV) packet 

	       constraint num_data_c{		// constraint on volume of data generation
		       num_data inside {
		       [25:FIFO_DEPTH]
	       };	
       }

       int mode_val = 1;			// Control randomization of trans rand variables
       string test = "rand";			// Default value - can be over written in test

       function new(mailbox m1, mailbox m2);		// fifo_gen class constructor 
	       this.gen2drv = m1;
	       this.gen2slv_drv = m2;
       endfunction 

       task run;

	       int count = 0;

	       //int num_data = $urandom_range(63,255);	// Commented:
	       //Externally driven through test.sv file

	       $display("No. of input data : %0d",num_data);	
	       repeat(num_data) begin
		       trans = new();
		       trans.rand_mode(mode_val);		// Added to control rand mode from env
		       
		       if(mode_val&&(test=="rand"))		// Enable randomization
		       begin
			       $display("\tGEN::run() : %0tns New data_generated \t Data item no. %0d out of %0d\n",$time,count+1,num_data);

			       if(!trans.randomize())
				       $fatal("\tGEN:: Transaction class randomization failed! Exiting...\n");

			       $display("\tfifo_gen::run() : %0tns Putting packets on Master Driver and Slave Driver\n",$time);
			       $display("\tGEN::run() Transaction info: %0tns wr_en = %0d, rd_en = %0d, data_in = %0d\n",$time,trans.wr_en,trans.rd_en,trans.data_in);
		       end
		       else 	begin

			       if(test=="write_only")		// WRITE_ONLY_TEST
			       begin
				       trans.wr_en=1'b1;
				       trans.rd_en=1'b0;
				       trans.data_in = $urandom();
				       $display("\tGEN::run() : %0tns New data_generated \t Data item no. %0d out of %0d\n",$time,count+1,num_data);
				       $display("\tGEN::run() : %0tns Putting packets on Master Driver and Slave Driver\n",$time);
				       $display("\tGEN::run() Transaction info: %0tns wr_en = %0d, rd_en = %0d, data_in = %0d\n",$time,trans.wr_en,trans.rd_en,trans.data_in);
			       end				// END: WRITE_ONLY_TEST

			       if(test=="write_read")		// WRITE_READ_TEST
			       begin
				       if(count%2==0)
				       begin
					       trans.wr_en = 1'b1;
					       trans.rd_en = 1'b0;
				       end
				       else
				       begin
					       trans.wr_en = 1'b0;
					       trans.rd_en = 1'b1;
				       end
				       trans.data_in = $urandom();
				       $display("\tGEN::run() : %0tns New data_generated \t Data item no. %0d out of %0d\n",$time,count+1,num_data);
				       $display("\tGEN::run() : %0tns Putting packets on Master Driver and Slave Driver\n",$time);
				       $display("\tGEN::run() Transaction info: %0tns wr_en = %0d, rd_en = %0d, data_in = %0d\n",$time,trans.wr_en,trans.rd_en,trans.data_in);
			       end				// END: WRITE_READ_TEST
		       end
			       gen2drv.put(trans);
			       gen2slv_drv.put(trans);
			       count++;
	       end
       endtask	
endclass
