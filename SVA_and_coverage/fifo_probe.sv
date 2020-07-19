`include "fifo_trans.sv"
`define PROBE_IF fifo_intf.fifo_probe_mp.fifo_probe_mp

class fifo_probe;

	virtual interface fifo_intf fifo_vif;

	mailbox mbx;

	function new(virtual interface fifo_intf intf, mailbox mbs);
		this.fifo_vif = intf;
		this.mbx = mbx;
	endfunction

	task run;
		forever begin
			fifo_trans trans;
			`PROBE_IF.rd_en<=0;

			$display("\tPROBE::%0t Reading data from DUT output",$time);

			@(posedge fifo_vif.clk);
			if(trans.rd_en)
			begin
				`PROBE_IF.rd_en <= trans.rd_en;
				`PROBE_IF.data_out <= trans.data_out;
			end

		end
	endtask

endclass
