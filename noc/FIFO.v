`timescale 1ns / 1ps
module FIFO ( clk, reset, reqUpStr , gntUpStr , full, PacketIn,
                         reqInCtr , gntInCtr , empty, PacketOut );
// ------------------------ Parameter Declarations --------------------------- //
parameter packetwidth = 55; // number of bits for data bus
parameter addressWidth = 4;// number of bits for address bus
parameter fifoDepth =  ( ( 1 << addressWidth ) - 1 ); // number of entries in fifo buffer
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
input reqUpStr;// Up stream router request  
input reqInCtr;// Input controller request  
input [packetwidth-1:0] PacketIn;// input data Packet to fifo
// ------------------------ Outputs Declarations ----------------------------- //
output gntUpStr;// Up stream router grant  
output gntInCtr;// Input controller grant  
output full;// indicator for FIFO buffer .. if full = 1 else = 0
output empty;// indicator for FIFO buffer .. if empty = 1 else = 0
output [packetwidth-1:0] PacketOut;// output data Packet form fifo
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
wire reqUpStr;// Up stream router request  
reg  gntUpStr=0;// Up stream router grant  
wire reqInCtr;// Input controller request  
wire [packetwidth-1:0] PacketIn;// input data Packet to fifo
wire [packetwidth-1:0] PacketOut;// output data Packet form fifo
wire full;// indicator for FIFO buffer .. if full = 1 else = 0
wire empty;// indicator for FIFO buffer .. if empty = 1 else = 0
reg writeEnable=0;// write enable to ram buffer
reg readEnable=0;// read enable to ram buffer
// ------------------------ Registers Declarations --------------------------- // 
reg gntInCtr=0;// Input controller grant 
reg [addressWidth-1:0] writeAddr=0;// write address to ram buffer
reg [addressWidth-1:0] readAddr=0;// read address from ram buffer
reg EnableGnt=1;
// ------------------------  instantiation Devices --------------------------- //
/* instantiate ram to buffer received Packet. */
ram # (.packetwidth(packetwidth),.addressWidth(addressWidth)) fifoBuffer
(
.clk(clk),
.reset(reset),
.writeEn(writeEnable),
.readEn(readEnable),
.writeAddr(writeAddr),
.readAddr(readAddr),
.dataIn(PacketIn),
.dataOut(PacketOut)
);
	
// ----------------------- Sequential  Logic  -------------------------------- //
always @(posedge clk or negedge reset)
  begin
    if( !reset)//reset all registers
      begin 
        gntInCtr 	<= 0;
		gntUpStr	<= 0;
		readEnable	<= 0;
		writeEnable <= 0;
        writeAddr 	<= 0;
        readAddr 	<= 0;
		EnableGnt   <= 1;
      end
    else
      begin
// handle request from up stream router 
			if ( !reqUpStr)
				EnableGnt <= 1;			
			if ( reqUpStr && ! full  && EnableGnt)
				begin
					gntUpStr 	<= 1;
					EnableGnt 	<= 0;
					writeEnable <= 1;
					writeAddr	<= writeAddr + 1'b1;
				end
			else
				begin
					gntUpStr 	<= 0;
					writeEnable <= 0;
				end
			if ( reqInCtr && ! empty )
				begin						
					gntInCtr		<= 1; 
					readEnable  <= 1;
					readAddr 	<= readAddr +1'b1;						
				end
			else 
				begin
					readEnable  <= 0;
					gntInCtr	<= 0;
				end
      end // reset
  end // always  
// ----------------------- Combinational Logic  ------------------------------ //
assign full = ( writeAddr == readAddr-1 ); 
assign empty = ( writeAddr == readAddr );

endmodule