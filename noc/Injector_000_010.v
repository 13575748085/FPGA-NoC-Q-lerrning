
`timescale 1ns / 1ps

module Injector_000_010(
// Global Settings 
/*-- for Injection rate (load) and typr of traffic (Random, ..etc) it will be defined in the 
Top module i.e. Traffic Generator.*/
reset,
clk, 
// -- Output Port Traffic: --
ReqDnStr,
GntDnStr,
DnStrFull,
PacketOut
);              
// ------------------------ Parameter Declarations --------------------------- //
//for 3x3 mesh
parameter routerID=6'b000_010; // change depends on mesh size 
parameter ModuleID =6'b000_010;
parameter CLOCK_MULT=3'b001; //// packet injection rate (percentage of cycles)
parameter packetwidth = 56;// number of bits for data bus
//Injector States 				
parameter 	    IDLE		=2'b00,
				PKT_PREP	=2'b01, 
				SEND_REQ	=2'b10, 
				WAIT_GRANT	=2'b11;	
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
input DnStrFull; //fifo状�?�标志位 indicator from Local about FIFO buffer status.. if full = 1 else = 0
input GntDnStr; //来自下降数据流路由器的许�? Grant from Down Stream Router
// ------------------------ Outputs Declarations ----------------------------- //
output ReqDnStr;  // Injector send request to router to send packets
output [packetwidth-1:0] PacketOut;// output data packet form Injector
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
wire DnStrFull;// indicator for Injector about Local FIFO buffer status .. if full = 1 else = 0
wire GntDnStr; // Grant from Down Stream Router
wire [packetwidth-1:0] PacketOut;// output data packet form fifo
// --------------------------------------------------------------------------- //
// ------------------------ Registers Declarations --------------------------- //
reg ReqDnStr; // request to Local Port FIFO Buffer  
reg [packetwidth-1:0] dataBuf;// data buffer register

///////////////////////// 
//Packet Contents
reg [1:0] STATE;
//PacketID and RandomInfo can be adjusted to fit the diminsion bits
reg [9:0]    PacketID;  	// 0:1023
reg [9:0]    RandomInfo; // 
reg [15:0]   CYCLE_COUNTER; //Timestamp 
integer Delay, Count;
//for Simulation log
//integer Injector_Log_0;
// --------------------------------------------------------------------------- //
initial 
   begin 		
		STATE	<= IDLE; CYCLE_COUNTER <= 0;
		dataBuf <= 0;   PacketID <= 0; RandomInfo <= 0; Count <= 0; Delay <= 0;
		//for Simulation log
		//Injector_Log_0 = $fopen("Injector_Log_0.txt","w");
		//$fdisplay(Injector_Log_0, "     SimulationTime ;   SendTime      ; SenderID   ; PacketID     ");	
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
	dataBuf <= 0; PacketID <= 0;RandomInfo <= 0;
	ReqDnStr<= 0; Count <= 0;
	STATE	<= IDLE;
	end  
else 					
	begin 
	case(STATE)
//################## STATE ###############################################	
	
IDLE:begin 
//Note: Comment Delay and Its Condition If you want to see Full Signal Or increase the Probability
//Delay between two consequence packets. to be changed to change Injection Rate		
Delay 	<= 200;//{$random}%3;// 0,1,2,3 are selected randomly
STATE	<=IDLE;
//������ע��STATE	<= PKT_PREP;
end
//######################################################################

PKT_PREP:begin//不在包里指定方向
PacketID <= PacketID + 1'b1; 
RandomInfo <= 9'b0;	
STATE	<= SEND_REQ;
end
//######################################################################
SEND_REQ:begin	
//######################################################################
if (PacketID != 1023)
begin
	if (Count == Delay)
		begin
		if (!DnStrFull) // Buffer not Full !=1
			begin
			ReqDnStr <= 1; //send request to Local Port
			dataBuf  <= {PacketID, ModuleID, RandomInfo} ;
			//PacketOut      <= dataBuf;
			STATE	<= WAIT_GRANT;
			Count <= 0;
			//$fdisplay(Injector_Log_0,  $time, " ; %d ; %d ; %d ", CYCLE_COUNTER, ModuleID,PacketID);			
			end //if
		else 
			begin
			STATE <= SEND_REQ;
			end 
		end//if delay
	else 
		begin
		Count <= Count+1'b1;					
		end
		 
end	//if (PacketID != 1023)		
end //SEND_REQ
//######################################################################	

WAIT_GRANT: begin
if (GntDnStr) // Buffer not Full
	begin
	ReqDnStr 			<=0; //send request to Local Port
	STATE	<= IDLE;
	end
else
	begin
	STATE	<= WAIT_GRANT;
	end
end
endcase
	end //else
end // always 
assign PacketOut = dataBuf;
endmodule


//#########################################################################################################