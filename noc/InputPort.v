`timescale 1ns / 1ps
module InputPort ( clk, reset, reqUpStr , gntUpStr , full, PacketIn, PacketOut );
// ------------------------ Parameter Declarations --------------------------- //
parameter routerNo 		= 24; // change depends on mesh size 
parameter packetwidth = 55; // number of bits for data bus
parameter datawidth=25;
parameter addressWidth = 4;// number of bits for address bus
parameter fifoDepth =  ( ( 1 << addressWidth ) - 1 ); // number of entries in fifo buffer
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset; 
input reqUpStr;// Up stream router request 
input [packetwidth-1:0] PacketIn;// input data Packet to fifo
// ------------------------ Outputs Declarations ----------------------------- //
output full;
output gntUpStr;// Up stream router grant  
output [packetwidth-1:0] PacketOut;// output data Packet form fifo
/*            North (1)
               |
               |
 West (2)---- Local(4) ---- East(0)
               |
               |
             South (3)
 */ 
// --------------------------------------------------------------------------- //
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
wire reqUpStr , gntUpStr;// request & grant  fifo buffer   
wire full; 
// grant bus from output controller which grant communication with other routers 
wire [packetwidth-1:0] PacketIn;// input data Packet from fifo
wire [packetwidth-1:0] PacketOut;// output data Packet to output Controller
// connection between fifo and Input Controller
wire emptyFifoInCntr, reqFifoInCntr, gntFifoInCntr;
wire [packetwidth-1:0] PacketFifoInCntr;
// --------------------------------------------------------------------------- //
// ------------------------ Registers Declarations --------------------------- //
// --------------------------------------------------------------------------- //
// ------------------------  instantiation Devices --------------------------- //
/* instantiate FIFO buffer */
FIFO # (.packetwidth(packetwidth),.addressWidth(addressWidth),
        .fifoDepth(fifoDepth)) fifo
(
.clk(clk),
.reset(reset),
.reqUpStr(reqUpStr),
.gntUpStr(gntUpStr),
.full(full), 
.PacketIn(PacketIn),
.reqInCtr(reqFifoInCntr),
.gntInCtr(gntFifoInCntr),
.empty(emptyFifoInCntr),
.PacketOut(PacketFifoInCntr)
);
// --------------------------------------------------------------------------- //

InputPortController # (.packetwidth(packetwidth)) InputPortController
(
.clk(clk),
.reset(reset),
.req(reqFifoInCntr),
.gnt(gntFifoInCntr),
.empty(emptyFifoInCntr),
.PacketIn(PacketFifoInCntr),
.PacketOut(PacketOut)
);
// --------------------------------------------------------------------------- //
// ----------------------- Sequential  Logic  -------------------------------- //
// --------------------------------------------------------------------------- //
// ----------------------- Combinational Logic  ------------------------------ //
// --------------------------------------------------------------------------- //
endmodule
// ----------------------------- End of File --------------------------------- //

