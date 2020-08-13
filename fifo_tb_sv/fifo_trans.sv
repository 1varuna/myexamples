/*
* File: fifo_trans.sv
* Author: Varun Anand
* Mentor: Varsha Anand, Verification Engineer
* Description: Transaction class containing randomizable data members
* and constraints.
*/
class fifo_trans #(parameter FIFO_WIDTH=32);

	`define S_DATA (2**((FIFO_WIDTH)/4))	// Defining range for small data values	
	`define M_DATA (2**((FIFO_WIDTH)/2))	// Defining range for medium data values	
	`define L_DATA (2**(FIFO_WIDTH))	// Defining range for large data values	

	rand bit [FIFO_WIDTH-1:0] data_in;
	rand bit wr_en, rd_en;
	logic [FIFO_WIDTH-1:0] data_out;	// To observe output at FIFO slave driver
	logic full,empty;	
	//mailbox mbx_out;

	//function new(mailbox mbx);
	//	this.mbx_out = mbx;
	//endfunction
	constraint wr_rd {
		wr_en!=rd_en;		// Mutex condition for read write
	}

/*	
	constraint wr_en_c {
	wr_en dist {1:=80,0:=20};	// constraint on write enable
	}	

	constraint rd_en_c {
	rd_en dist {1:=20,0:=80};	// constraint on write enable
	}
*/	

	// TODO Check why data_in constraint does not work
	

	/*	
	constraint data_in_c{		// constraint on data generation
		//data_in inside {[`M_DATA:`L_DATA-1]};
		data_in dist
		{
			[1000:`S_DATA-1] :=40,
			[`S_DATA:`M_DATA-1] :=40,
			[`M_DATA:`L_DATA] :=20
		};
		
		/*
		data_in dist {
	[0:(2<<FIFO_WIDTH)/2] := 50,
	[((2<<FIFO_WIDTH)/2):(2<<FIFO_WIDTH-1)] := 50
		};
		*/
	//}

endclass
