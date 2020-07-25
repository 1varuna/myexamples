/*
* File: fifo_output_mon.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo Output Monitor class which helps
* monitor read request and output data from DUT. 
*/

// Uncomment below for standalone compile
//`include "fifo_trans.sv"
//`include "fifo_intf.sv"

class fifo_output_mon;
	
	virtual fifo_intf fifo_vif;

	mailbox out_mon2sb;		// Mailbox from input monitor to SB

	// constructor
	function new(virtual fifo_intf vif, mailbox mbx);
		this.fifo_vif = vif;
		this.out_mon2sb = mbx;
	endfunction

	task sample;
		forever begin
			fifo_trans trans;
			trans = new();
		
			@(posedge fifo_vif.clk);
			if (fifo_vif.rstN) begin
					if ((fifo_vif.full==1'b1) || (fifo_vif.empty==1'b1)||(fifo_vif.data_out!='hx)) begin
						trans.full = fifo_vif.full;
						trans.empty = fifo_vif.empty;
						trans.data_out = fifo_vif.data_out;
						$display("\tOUTPUT MONITOR::sample() : FULL or EMPTY or DATA_OUT detected, updating mailbox to send to scoreboard. Transaction info: EMPTY = %0d, FULL = %0d, data_out = %0d\n",trans.empty,trans.full,trans.data_out);
						out_mon2sb.put(trans);
					end
			end
		end
	endtask
endclass
