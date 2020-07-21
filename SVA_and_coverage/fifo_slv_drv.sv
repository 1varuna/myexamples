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
			`SLAVE_IF.rd_en<=0;

			$display("\tSLAVE::%0t Reading data from FIFO output",$time);

			@(posedge fifo_vif.clk);
			if(trans.rd_en) begin
				if(`SLAVE_IF.empty==1)
				begin
					$warning("\tfifo_slv_drv::run() %0t Disabling read on an empty fifo! Exiting...",$time);
				end
				else begin
					`SLAVE_IF.rd_en <= trans.rd_en;
					@(posedge fifo_vif.clk);
					`SLAVE_IF.rd_en <= 0;
					@(posedge fifo_vif.clk);
					trans.data_out <= `SLAVE_IF.data_out;
					$display("\tSLAVE::%0t Reading data from fifo %0h",$time,trans.data_out);
				end
			end
		end
	endtask

endclass
`endif
