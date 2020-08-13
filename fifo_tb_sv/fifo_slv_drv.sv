/*
* File: fifo_slv_drv.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Fifo Slave Driver class which helps
* send a read request to read data from FIFO. 
*/

`ifndef FIFO_SLAVE
`define FIFO_SLAVE

class fifo_slv_drv;	

	virtual interface fifo_intf fifo_vif;
	`define SLAVE_IF fifo_vif.fifo_slv_drv_cb

	mailbox gen2slv_drv;		// Incoming pkt (GEN-->DRV)
	function new(virtual interface fifo_intf intf,mailbox mbx);
		this.fifo_vif = intf;
		this.gen2slv_drv = mbx;
		
	endfunction

	task run;
		forever begin
			fifo_trans trans;
			gen2slv_drv.get(trans);
			$display("\tSLAVE DRIVER::run() Transaction info FROM GEN: %0t ns wr_en = %0d, rd_en = %0d, data_in = %0d\n",$time,trans.wr_en,trans.rd_en,trans.data_in);
			`SLAVE_IF.rd_en<=0;

			$display("\tSLAVE::%0t Reading data from FIFO output",$time);

			@(posedge fifo_vif.clk);
			if(trans.rd_en) begin
				if(`SLAVE_IF.empty==1)
				begin
					$warning("\tfifo_slv_drv::run() %0t Attempting read on an empty fifo! \n",$time);
				end
				else begin
					$display("\tSLAVE DRIVER::run() Transaction info INTO DUT: %0t ns rd_en = %0d \n",$time,trans.rd_en);
					`SLAVE_IF.rd_en <= trans.rd_en;
					@(posedge fifo_vif.clk);
					`SLAVE_IF.rd_en <= 0;
					
					/* TODO Move to Monitor Logic
					@(posedge fifo_vif.clk);
					trans.data_out <= `SLAVE_IF.data_out;
					$display("\tSLAVE::%0t Reading data from fifo %0h",$time,trans.data_out);
					*/
				end
			end
		end
	endtask

endclass
`endif
