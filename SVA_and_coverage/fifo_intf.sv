interface fifo_intf #(parameter FIFO_WIDTH=32, parameter FIFO_DEPTH=(2**5))(
	input clk,				// input clock
	input rstN,				//active low reset
	input wr_en,				// write enable
	input [FIFO_WIDTH-1:0] data_in,		// Input Data
	input rd_en,				// read enable
	output empty,				// fifo empty
	output full,				// fifo full
	output [FIFO_WIDTH-1:0] data_out	// Output data
	);

	default clocking fifo_mon_cb @(posedge clk);	// Monitor clocking Block : Default	
	default input #2ns output #2ns;			// Defining default input and output clock skews
	
	//input clk;				// input clock
	//input rstN;				//active low reset
	input wr_en;				// write enable
	input data_in;				// Input Data
	input rd_en;				// read enable
	input empty;				// fifo empty
	input full;				// fifo full
	input data_out;				// Output data

	endclocking
	
	modport fifo_mon_mp(clocking fifo_mon_cb,input clk,input rstN);	// Defining port directions for fifo monitor

	clocking fifo_drv_cb @(posedge clk);
		default input #2ns output #2ns;
		//input clk;
		//input rstN;
		output data_in;
		output wr_en;
	endclocking

	modport fifo_drv_mp(clocking fifo_drv_cb,input clk,input rstN);	// Defining port directions for fifo driver

	clocking fifo_slave_cb @(posedge clk);
		default input #2ns output #2ns;
		//input clk;
		//input rstN;
		input data_out;
		input full;
		input empty;
		output rd_en; 
		
	endclocking

	modport fifo_slave_mp(clocking fifo_slave_cb,input clk,input rstN);	// Defining port directions for fifo slave

endinterface
