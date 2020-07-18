module fifo (
  clk, 
  rstN, 
  write_en, 
  read_en, 
  data_in, 
  data_out, 
  empty, 
  full
);
parameter FIFO_WIDTH = 8;
parameter FIFO_DEPTH = 2<<5;

input wire clk;
input wire rstN;
input wire write_en;
input wire read_en;
input wire [FIFO_WIDTH-1:0] data_in;
output reg [FIFO_WIDTH-1:0] data_out;
output wire empty;
reg tmp_empty;
output wire full;
reg tmp_full;

reg [FIFO_WIDTH-1:0] memory [FIFO_DEPTH-1:0];

integer write_ptr;
integer read_ptr;

// Defining reset conditions
always @(negedge rstN)
begin
data_out = 0;
tmp_empty = 1'b1;
tmp_full = 1'b0;
write_ptr=0;
read_ptr=0;
end	// reset

assign empty = tmp_empty;
assign full = tmp_full;

always @(posedge clk)
begin
if((write_en==1'b1)&&(tmp_full==1'b0))
begin
memory[write_ptr] = data_in;
tmp_empty <= 0;		// fifo no longer emnpty
// increment write pointer
write_ptr = (write_ptr+1)%FIFO_DEPTH;
if(read_ptr==write_ptr)		// check for fifo FULL condition
begin
tmp_full <= 1'b1;
end	// inner if
end	// outer if
if((read_en==1'b1)&&(tmp_empty==1'b0))
begin
data_out <= memory[read_ptr];
tmp_full <= 0;		// fifo no longer full
//  increment read pointer
read_ptr = (read_ptr+1)%FIFO_DEPTH;
if(read_ptr==write_ptr)
begin
tmp_empty <= 1'b1;
end	// inner if
end	// outer if
end	// fifo main op block

endmodule: fifo