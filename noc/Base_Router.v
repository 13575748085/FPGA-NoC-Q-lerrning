`timescale 1ns / 1ps
//#################################################################################
/*                          North (7)
                             \
                             \
               West (6)---- Local(0) ---- East(4)
                             \
                             \
                           South (5)*/
//#################################################################################
module Base_Router(  clk, reset,
							eastReqUpStr,  eastGntUpStr,  eastUpStrFull,  eastPacketIn,
							eastReqDnStr,  eastGntDnStr,  eastDnStrFull,  eastPacketOut,
							northReqUpStr, northGntUpStr, northUpStrFull, northPacketIn,
							northReqDnStr, northGntDnStr, northDnStrFull, northPacketOut,
							westReqUpStr,  westGntUpStr , westUpStrFull,  westPacketIn,
							westReqDnStr,  westGntDnStr,  westDnStrFull,  westPacketOut,
							southReqUpStr, southGntUpStr, southUpStrFull, southPacketIn,
							southReqDnStr, southGntDnStr, southDnStrFull, southPacketOut,
							localReqUpStr, localGntUpStr, localUpStrFull, localPacketIn,
							localReqDnStr, localGntDnStr, localDnStrFull, localPacketOut);
//##################### Parameter Declarations ####################################
parameter routerID     	= 6'b000_000; 
parameter routerNo 		= 5'b00001;
parameter packetwidth = 55;
parameter datawidth=25;
parameter addressWidth 	= 4;
parameter fifoDepth 	= ((1 << addressWidth) - 1); 
//######################## Inputs Declarations ###################################
input clk;
input reset;
// Up stream routers requests  
input eastReqUpStr, northReqUpStr, westReqUpStr, southReqUpStr, localReqUpStr;
// fifo满信�?
input eastDnStrFull,  northDnStrFull, westDnStrFull, southDnStrFull, localDnStrFull ;
// Down stream routers grant 
input eastGntDnStr, northGntDnStr, westGntDnStr, southGntDnStr, localGntDnStr;
// input data Packet to fifo
input [packetwidth-1:0] eastPacketIn, northPacketIn, westPacketIn, southPacketIn, localPacketIn;
//########################## Outputs Declarations #################################
// Down stream routers requests 
output eastReqDnStr, northReqDnStr, westReqDnStr, southReqDnStr, localReqDnStr;  
// indicator for Up stream routers FIFO buffer .. if full = 1 else = 0
output eastUpStrFull, northUpStrFull, westUpStrFull, southUpStrFull, localUpStrFull;
// Up stream routers grant  
output eastGntUpStr, northGntUpStr, westGntUpStr, southGntUpStr, localGntUpStr;
// output data Packet form fifo
output [packetwidth-1:0] eastPacketOut, northPacketOut, westPacketOut, southPacketOut, localPacketOut ;
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
//#######################        Up Stream Part     ############################
// Request from Up stream routers to Down Stream routers
wire eastReqUpStr, northReqUpStr, westReqUpStr, southReqUpStr, localReqUpStr;
// indicator to Up stream routers from Down stream routers FIFO buffer .. if full = 1 else = 0
wire eastDnStrFull,  northDnStrFull, westDnStrFull, southDnStrFull, localDnStrFull ;
// Down stream routers grant 
wire eastGntDnStr, northGntDnStr, westGntDnStr, southGntDnStr, localGntDnStr; 
// output data Packet
wire [packetwidth-1:0] eastPacketOut, northPacketOut, westPacketOut, southPacketOut, localPacketOut ;
//#######################       Down Stream Part     ############################
// Down stream routers requests 
wire eastReqDnStr, northReqDnStr, westReqDnStr, southReqDnStr, localReqDnStr; 
// indicator for Up stream routers FIFO buffer .. if full = 1 else = 0
wire eastUpStrFull, northUpStrFull, westUpStrFull, southUpStrFull, localUpStrFull;
// Up stream routers grant  
wire  eastGntUpStr,  northGntUpStr, westGntUpStr, southGntUpStr, localGntUpStr;
// input data Packet to fifo
wire [packetwidth-1:0] eastPacketIn, northPacketIn, westPacketIn, southPacketIn, localPacketIn;
//#################################################################################################
// communication between input and output controllers for all ports
wire [packetwidth-1:0] eastPacket, northPacket, westPacket, southPacket, localPacket ;
//############################  instantiation Devices  ######################################
//#################################    East  Port  ###########################################
/* instantiate East Input Controller . */
InputPort  # (.routerNo(routerNo),.packetwidth(packetwidth),.datawidth(datawidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth)) eastInputController
(
.clk(clk),
.reset(reset),
.reqUpStr(eastReqUpStr),  
.gntUpStr(eastGntUpStr), 
//Buffering Status
.full(eastUpStrFull), //Own Buffer
//Packet Depending on Requests
.PacketIn(eastPacketIn),
.PacketOut(eastPacket)
);

/* instantiate East Output Controller . */
OutputController # (.direction(3'b100),.routerNo(routerNo),.datawidth(datawidth),.packetwidth(packetwidth)) eastOutputController
( 
.clk(clk), 
.reset(reset), 
.reqDnStr(eastReqDnStr),
.gntDnStr(eastGntDnStr),   
.full(eastDnStrFull), 
.PacketInPort_4(localPacket), 
.PacketInPort_3(southPacket), 
.PacketInPort_2(westPacket), 
.PacketInPort_1(northPacket),
.PacketInPort_0(eastPacket), 
.PacketOut(eastPacketOut)
);     	

//#################################    North Port  ##########################################
/* instantiate North Input Controller . */
InputPort  # (.routerNo(routerNo),.packetwidth(packetwidth),.datawidth(datawidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth)) northInputController
(
.clk(clk),
.reset(reset),
.reqUpStr(northReqUpStr), 
.gntUpStr(northGntUpStr),
//Buffering Status 
.full(northUpStrFull),  
.PacketIn(northPacketIn), 
.PacketOut(northPacket)
);

/* instantiate North Output Controller . */
OutputController # (.direction(3'b111),.routerNo(routerNo),.datawidth(datawidth),.packetwidth(packetwidth)) northOutputController
( 
.clk(clk), 
.reset(reset), 
.reqDnStr(northReqDnStr), 
.gntDnStr(northGntDnStr), 
.full(northDnStrFull), 
.PacketInPort_4(localPacket), 
.PacketInPort_3(southPacket), 
.PacketInPort_2(westPacket), 
.PacketInPort_1(northPacket),
.PacketInPort_0(eastPacket), 
.PacketOut(northPacketOut)
);

//#################################    West Port  ##########################################
/* instantiate West Input Controller . */
InputPort  # (.routerNo(routerNo),.packetwidth(packetwidth),.datawidth(datawidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth)) westInputController
(
.clk(clk),
.reset(reset),
.reqUpStr(westReqUpStr), 
.gntUpStr(westGntUpStr),
//Buffering Status  
.full(westUpStrFull), 
//Packet Depending on Requests
.PacketIn(westPacketIn), 
.PacketOut(westPacket)
);

/* instantiate West Output Controller . */                       
OutputController # (.direction(3'b110),.routerNo(routerNo),.datawidth(datawidth),.packetwidth(packetwidth)) westOutputController
( 
.clk(clk), 
.reset(reset), 
.reqDnStr(westReqDnStr), 
.gntDnStr(westGntDnStr), 
.full(westDnStrFull), 
.PacketInPort_4(localPacket), 
.PacketInPort_3(southPacket), 
.PacketInPort_2(westPacket), 
.PacketInPort_1(northPacket),
.PacketInPort_0(eastPacket), 
.PacketOut(westPacketOut)
);


//#################################    South Port  ##########################################
/* instantiate South Input Controller . */
InputPort  # (.routerNo(routerNo),.packetwidth(packetwidth),.datawidth(datawidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth)) southInputController
(
.clk(clk),
.reset(reset),
.reqUpStr(southReqUpStr),
.gntUpStr(southGntUpStr), 
//Buffering Status  
.full(southUpStrFull), 
.PacketIn(southPacketIn),
.PacketOut(southPacket)
);

/* instantiate South Output Controller . */
OutputController # (.direction(3'b101),.routerNo(routerNo),.datawidth(datawidth),.packetwidth(packetwidth)) southOutputController
( 
.clk(clk), 
.reset(reset), 
.reqDnStr(southReqDnStr),  
.gntDnStr(southGntDnStr), 
.full(southDnStrFull), 
.PacketInPort_4(localPacket), 
.PacketInPort_3(southPacket), 
.PacketInPort_2(westPacket), 
.PacketInPort_1(northPacket),
.PacketInPort_0(eastPacket), 
.PacketOut(southPacketOut)
);

//#################################    Local Port  ##########################################
/* instantiate Local Input Controller . */
InputPort  # (.routerNo(routerNo),.packetwidth(packetwidth),.datawidth(datawidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth)) localInputController
(
.clk(clk),
.reset(reset),
.reqUpStr(localReqUpStr), 
.gntUpStr(localGntUpStr),
.full(localUpStrFull), 
.PacketIn(localPacketIn),
.PacketOut(localPacket) 
);

/* instantiate Local Output Controller . */
OutputController # (.direction(3'b000),.routerNo(routerNo),.datawidth(datawidth),.packetwidth(packetwidth)) localOutputController
( 
.clk(clk), 
.reset(reset), 
.reqDnStr(localReqDnStr),
.gntDnStr(localGntDnStr),  
.full(localDnStrFull), 
.PacketInPort_4(localPacket), 
.PacketInPort_3(southPacket), 
.PacketInPort_2(westPacket), 
.PacketInPort_1(northPacket),
.PacketInPort_0(eastPacket), 
.PacketOut(localPacketOut));

endmodule
//############################## End of File ##########################################