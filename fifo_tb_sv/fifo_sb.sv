/*
* File: fifo_sb.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo Scoreboard class which helps
* check data, sampled using input and output monitors. 
	*/

       class fifo_sb #(parameter FIFO_WIDTH=32, parameter FIFO_DEPTH=32); 

	       mailbox in_mon2sb;
	       mailbox out_mon2sb;

	       // Initialize counter variable to keep 
	       // track of transactions processed

	       static int trans_count = 0;


	       // SB Constructor
	       function new(mailbox in_mon2sb,mailbox out_mon2sb);
		       this.in_mon2sb = in_mon2sb;
		       this.out_mon2sb = out_mon2sb;
	       endfunction

	       // Declare queues to save incoming
	       // data from monitors

	       logic [FIFO_WIDTH-1:0] in_stream_q[$];	// data_in queue
	       logic [FIFO_WIDTH-1:0] out_stream_q[$];	// data_out queue
	       logic [FIFO_WIDTH-1:0] temp_in_data;	// Temporary queue to hold input data
	       logic [FIFO_WIDTH-1:0] temp_out_data;	// Temporary queue to hold output data
	       /*
	       logic in_stream[$];	// Bit 0 - rd_en, 1 - wr_en, remaining: data_in
	       logic out_stream[$];	// Bit 0 - rd_en, 1 - empty, 2 - full, remaining : data_out
	       logic temp_in_data;	// Temporary queue to hold input data
	       logic temp_out_data;	// Temporary queue to hold output data
	       */
	      bit full_q[$];	// Queue to hold full signal values
	      bit empty_q[$];	// Queue to hold empty signal values
	      bit wr_en_q[$];
	      bit rd_en_q[$];

	      // Temporary output queues
	      bit temp_wr_en;
	      bit temp_rd_en;
	      bit temp_full;
	      bit temp_empty;

	      // Declare SB events
	      event data_in_ev;				// To signal when an input write and data arrive
	      event data_out_ev;			// To signal when an output read and data arrive

	      event read_rcv_ev;			// Check if read has been received
	      event full_ev;				// Check if FULL has been observed
	      event empty_ev;				// Check if EMPTY has been observed

	      task in_queue;
		      fifo_trans in_trans;		// Incoming trans from input monitor
		      in_trans = new();
		      $display("\t SCOREBOARD:: Inside in_queue() \n");
		      forever begin
			      in_mon2sb.get(in_trans);
			      $display("\tSCOREBOARD::in_queue() : Transaction info: wr_en = %0d, rd_en = %0d, data_in=%0d\n",in_trans.wr_en,in_trans.rd_en,in_trans.data_in);
			      if(in_trans.wr_en==1) begin
				      	trans_count++;
				      	wr_en_q.push_back(in_trans.wr_en);
			      		in_stream_q.push_back(in_trans.data_in);
			      		//$display("\t SB::in_queue() : Waiting for data_in event...\n");
			      		->data_in_ev;
			      		$display("\t SB::in_queue() : SENT data_in event...\n");
				end
				if(in_trans.rd_en==1) begin
				      	trans_count--;
					rd_en_q.push_back(in_trans.rd_en);
					->read_rcv_ev;
				end
		      end

	      endtask

	      task out_queue;
		      fifo_trans out_trans;	// Incoming trans from output monitor
		      out_trans = new();
		      $display("\t SCOREBOARD:: Inside out_queue() \n");
		      forever begin
			      out_mon2sb.get(out_trans);
			      $display("\tSCOREBOARD::out_queue() : Transaction info: wr_en = %0d, rd_en = %0d, data_out=%0d, full : %0d, empty: %0d\n",out_trans.wr_en,out_trans.rd_en,out_trans.data_out,out_trans.full,out_trans.empty);
			      if(out_trans.full==1'b1) begin
			      		full_q.push_back(out_trans.full);
					->full_ev;
			      		$display("\t SB::out_queue() : SENT full event...\n");
				end

				if(out_trans.empty==1'b1) begin
			      		empty_q.push_back(out_trans.empty);
					->empty_ev;
			      		$display("\t SB::out_queue() : SENT empty event...\n");
				end

				//if(out_trans.data_out!='h0) begin
			      		out_stream_q.push_back(out_trans.data_out);	// forcing wr_en to 0
			      		->data_out_ev;
			      		$display("\t SB::out_queue() : SENT data_out event...\n");
				//end
		      end
	      endtask

	      task chk_data_out;
		      forever begin
			      	@(read_rcv_ev or data_out_ev) begin
					if((in_stream_q.size()!=0) && (out_stream_q.size()!=0)) begin
			      			temp_in_data = in_stream_q.pop_front();
			     			temp_out_data = out_stream_q.pop_front();
						$display("\t SCOREBOARD::chk_data_out() : DATA CHECKING...");
						if(temp_in_data!=temp_out_data)
							$error("\t SCOREBOARD::chk_data_out() : Data Mismatch! \n\t Input Data: %0d is not equal to Output Data: %0d \n",temp_in_data,temp_out_data);
						else
							$display("\t SCOREBOARD::chk_data_out() : Data Matched! \n\t Input Data: %0d , Output Data: %0d \n",temp_in_data,temp_out_data);

					end
				end
		      end
	      endtask

	      task chk_full;
		      bit exp_full;		// EXP full from TB
		      forever begin
			@(full_ev) begin
				if(full_q.size()!=0) begin
				temp_full = full_q.pop_front();		// RTL full signal				
				exp_full = (trans_count==FIFO_DEPTH);
				if(temp_full!=exp_full)
					$error("\t SCOREBOARD::chk_full() At %t : FAILED \n \t EXP: %0d \t RTL : %0d\n",$time,exp_full,temp_full);
				else
					$display("\t SCOREBOARD::chk_full() At %t : PASSED \n \t EXP: %0d \t RTL : %0d\n",$time,exp_full,temp_full);
				end

			end
		      	end
	      endtask
	      
	      task chk_empty;
		      bit exp_empty;		// EXP empty from TB
		      forever begin
			@(empty_ev) begin
				if(empty_q.size()!=0) begin
				temp_empty = empty_q.pop_front();		// RTL empty signal				
				exp_empty = (trans_count==0);
				if(temp_empty!=exp_empty)
					$error("\t SCOREBOARD::chk_empty() At %t : FAILED \n \t EXP: %0d \t RTL : %0d\n",$time,exp_empty,temp_empty);
				else
					$display("\t SCOREBOARD::chk_empty() At %t : PASSED \n \t EXP: %0d \t RTL : %0d\n",$time,exp_empty,temp_empty);
				end

			end
		      	end
	      endtask

      task run;
		fork
		      in_queue;
		      out_queue;
		      chk_data_out;
		      chk_full;
		      chk_empty;
		join_none
      endtask
endclass
