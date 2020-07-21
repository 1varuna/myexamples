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

	/*	TODO Remove task
	task reset;		// On Reset, reset interface signals to default values
		fifo_vif.rstN <= 0;

		$display("\tDRIVER :: %0t ns \t reset task starting...\n ",$time);
		
		`DRV_IF.wr_en <= 0;
		`DRV_IF.data_in <= 'h0;
		
		#100 fifo_vif.rstN <= 1;
		$display("\tDRIVER :: %0t ns \t reset task finishing...\n ",$time);
	endtask
	*/
	task run;		// This task puts generated pkts from gen to drv
		forever begin
			fifo_trans trans;

			`DRV_IF.wr_en<=0;

			gen2drv.get(trans);

			$display("\tDRIVER::%0t Getting data packets from Generator",$time);

			@(posedge fifo_vif.clk);
			if(trans.wr_en)
			begin
				`DRV_IF.wr_en <= trans.wr_en;
				`DRV_IF.data_in <= trans.data_in;

				@(posedge fifo_vif.clk);
			end

		end
	endtask

endclass	
