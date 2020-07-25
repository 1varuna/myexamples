/*
* File: fifo_input_mon.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo Input Monitor class which helps
* monitor write request and input data into DUT. 
*/

// Uncomment below for standalone compile
//`include "fifo_trans.sv"
//`include "fifo_intf.sv"

class fifo_input_mon;
	
	virtual fifo_intf fifo_vif;

	mailbox in_mon2sb;		// Mailbox from input monitor to SB

	// constructor
	function new(virtual fifo_intf vif, mailbox mbx);
		this.fifo_vif = vif;
		this.in_mon2sb = mbx;
	endfunction

	task sample;
		forever begin
			fifo_trans trans;
			trans = new();

			@(posedge fifo_vif.clk);
			trans.wr_en = fifo_vif.wr_en;
			trans.data_in = fifo_vif.data_in;
			trans.rd_en = fifo_vif.rd_en;
			$display("\tINPUT MONITOR::sample() : Transaction info: wr_en = %0d, rd_en = %0d, data_in=%0d\n",trans.wr_en,trans.rd_en,trans.data_in);
			@(posedge fifo_vif.clk);
			in_mon2sb.put(trans);
		end
	endtask
endclass
