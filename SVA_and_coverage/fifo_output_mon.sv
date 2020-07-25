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
			trans.rd_en = fifo_vif.rd_en;
			trans.data_out = fifo_vif.data_out;
			trans.full = fifo_vif.full;
			trans.empty = fifo_vif.empty;
			$display("\tOUTPUT MONITOR::sample() : Transaction info: wr_en = %0d, rd_en = %0d, data_out=%0d, full : %0d, empty: %0d\n",trans.wr_en,trans.rd_en,trans.data_out,trans.full,trans.empty);
			@(posedge fifo_vif.clk);
			out_mon2sb.put(trans);
		end
	endtask
endclass
