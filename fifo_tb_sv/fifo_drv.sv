/*
* File: fifo_drv.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo Master Driver class which helps
* send a write request and input data into DUT. 
*/

// Uncomment below for standalone compile
//`include "fifo_trans.sv"
//`include "fifo_intf.sv"
class fifo_drv;
	virtual interface fifo_intf fifo_vif;
	`define DRV_IF fifo_vif.fifo_drv_cb

	// create a mailbox to receive pkt from gen
	mailbox gen2drv;		// Incoming pkt (GEN-->DRV)

	function new (virtual interface fifo_intf intf, mailbox mbx);	// Class constructor
		this.fifo_vif = intf;
		this.gen2drv = mbx;
	endfunction

	task run;		// This task puts generated pkts from gen to drv
		forever begin
			fifo_trans trans;

			`DRV_IF.wr_en<=0;

			gen2drv.get(trans);
			$display("\tMASTER DRIVER::run() Transaction info FROM GEN: %0t ns wr_en = %0d, rd_en = %0d, data_in = %0d\n",$time,trans.wr_en,trans.rd_en,trans.data_in);

			$display("\tDRIVER::%0t Getting data packets from Generator",$time);

			@(posedge fifo_vif.clk);
			if(trans.wr_en)
			begin
			$display("\tMASTER DRIVER::run() Transaction info INTO DUT: %0t ns wr_en = %0d, rd_en = %0d, data_in = %0d\n",$time,trans.wr_en,trans.rd_en,trans.data_in);
				`DRV_IF.wr_en <= trans.wr_en;
				`DRV_IF.data_in <= trans.data_in;

				@(posedge fifo_vif.clk);
				`DRV_IF.wr_en<=0;
			end

		end
	endtask

endclass	
