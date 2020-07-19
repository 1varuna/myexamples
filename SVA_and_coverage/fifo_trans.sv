class fifo_trans(#parameter FIFO_WIDTH=32);
	

	rand bit[FIFO_WIDTH-1:0] data_in;
	rand bit wr_en, rd_en;
	
	mailbox mbx_out;

	function new(mailbox mbx);
		this.mbx_out = mbx;
	endfunction

	constraint wr_rd {
		wr_en!=rd_en;		// Mutex condition for read write
	}

	constraint wr_en_c {
	wr_en dist {1:=50,0:=50};	// constraint on write enable
	}	

	constraint data_in_c{		// constraint on data generation
	data_in dist {
	[0:(2<<FIFO_WIDTHI)/2] := 50,
	[((2<<FIFO_WIDTH)/2):(2<<FIFO_WIDTH-1)] := 50
		};
	}I

endclass
