`timescale 1ns / 1ps

module Injector_000_000(
reset,
clk, 
enroute,
RouteInfoIn,
// -- Output Port Traffic: --
ReqDnStr,
GntDnStr,
DnStrFull,
PacketOut,
ReqRoute,
Sor_DesInfo,
Q_learn_ready,
switch
);              
// ------------------------ Parameter Declarations --------------------------- //
//for 3x3 mesh
parameter routerID=6'b000_000; // change depends on mesh size 
parameter ModuleID =6'b000_000;
parameter CLOCK_MULT=3'b001; //// packet injection rate (percentage of cycles)
parameter packetwidth = 55;// number of bits for data bus
//Injector States 				
parameter IDLE		        =3'b000,
				    PKT_PREP	=3'b001, 
				    SEND_REQ	=3'b010, 
				    WAIT_GRANT	=3'b011,
				    MEDIUMWAIT =3'b100;
// ------------------------ Inputs Declarations ------------------------------ //
input wire clk;
input wire reset;
input wire DnStrFull; //indicator from Local about FIFO buffer status.. if full = 1 else = 0
input wire GntDnStr; //Grant from Down Stream Router
input wire enroute;
input wire [29:0] RouteInfoIn;
input wire Q_learn_ready;
input wire switch;
// ------------------------ Outputs Declarations ----------------------------- //
output reg ReqDnStr;  // Injector send request to router to send packets
output reg [packetwidth-1:0] PacketOut;// output data packet form Injector
output reg ReqRoute=0;
output reg [9:0] Sor_DesInfo=0;
// ------------------------ Registers Declarations --------------------------- //
reg [packetwidth-1:0] dataBuf;// data buffer register
reg [2:0] STATE;
reg [9:0] PacketID;  	// 0:1023
reg [8:0] RandomInfo; // 
reg [15:0]CYCLE_COUNTER; 
integer Delay, Count;
// --------------------------------------------------------------------------- //
initial 
    begin 		
		STATE	<= IDLE; CYCLE_COUNTER <= 0;
		dataBuf <= 0;   PacketID <= 0; RandomInfo <=9'b101100111; Count <= 0; Delay <= 0;
    end
	
always @(posedge clk)
    begin 
        CYCLE_COUNTER <= CYCLE_COUNTER + 1'b1;   
    end	
//###########################   Modules(PEs) Injector ################################### 
always @(posedge clk or negedge reset)  
begin 
if( !reset)
	begin 
	dataBuf <= 0; 
	PacketID <= 0;
	RandomInfo <= 9'b101100111;
	ReqDnStr<= 0; Count <= 0;
	STATE	<= IDLE;
	end  
else 					
	begin 
	case(STATE)
//################## STATE ###############################################	
IDLE:
begin 
//发包延迟delay
    if(switch)
    begin
        Delay 	<= 3;
        STATE<= PKT_PREP;
    end
end
//######################################################################

PKT_PREP:
begin
    if(Q_learn_ready)
        begin
            PacketID <= PacketID + 1'b1; 
            STATE	<= SEND_REQ;
            Sor_DesInfo<=10'b01001_00001;
            ReqRoute<=1;
            STATE<=MEDIUMWAIT;
        end
end
//######################################################################
MEDIUMWAIT:
    begin
        	ReqRoute<=0;
        	STATE<=SEND_REQ;
    end
SEND_REQ:
begin	

if (enroute)//((PacketID != 1023)&&(enroute))
    begin
                        if (!DnStrFull) // Buffer not Full !=1
                            begin
		                          ReqDnStr <= 1; //send request to Local Port
		                          dataBuf  <= {RouteInfoIn,PacketID, ModuleID, RandomInfo} ;
			                      STATE	<= WAIT_GRANT;
			                      Count <= 0;
			                 end //if
		                else 
		                     begin
			                     STATE <= SEND_REQ;
			                 end 
    end	
 else 
		 begin
			   STATE <= SEND_REQ;
		 end 		
end 
//######################################################################	

WAIT_GRANT: 
begin
    if (GntDnStr) // Buffer not Full
        begin
           PacketOut<=dataBuf;
	       ReqDnStr 	<=0; //send request to Local Port
//	       STATE	<= WAIT_GRANT;//只发送一次，如果发多次改IDLE
            STATE	<= IDLE;//只发送一次，如果发多次改IDLE
	   end
    else
	   begin
	       PacketOut<=dataBuf;
	       STATE	<= WAIT_GRANT;
	   end
end
endcase
end //else
end // always 
endmodule