
module Collector_000_010
(
clk, 
reset, 
PacketIn, //connect to localpacketOut,
UpStrFull, // connect to localDnStrFull, 
ReqUpStr, // connect to localReqDnStr, 
GntUpStr
);
 // ------------------------ Parameter Declarations --------------------------- //
 //for 3x3 mesh
parameter routerID = 6'b000_010; 
parameter ModuleID =6'b000_010;
parameter packetwidth = 26;// number of bits for data bus
parameter 	WAIT_REQ=1'b0,RECEIVE_DATA=1'b1;
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
input ReqUpStr;//  routers' Local Port send request to collector to receive packets -- always receive
// ------------------------ Outputs Declarations ----------------------------- //
output UpStrFull;  // Collector send Full to router -- Always Not full it is the destination
output GntUpStr;  

input [packetwidth-1:0] PacketIn;// output data packet form Local Port to Collector
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
wire ReqUpStr;  // request from Local Port to Collector
wire [packetwidth-1:0] PacketIn;// Input data packet form Local Port
// ------------------------ Registers Declarations --------------------------- //
reg UpStrFull;// Always Not full it is the destination
reg GntUpStr;  
// data buffer register to accept the packet and Indicate its Information
reg [packetwidth-1:0] dataBuf;
//Packet Contents
reg [8:0]     data;
reg [9:0]     PacketID;
reg [15:0]    CYCLE_COUNTER; //Timestamp 
reg  STATE_Collector; //reg [1:0] STATE_Collector;
reg [5:0] SenderID;
//for Simulation log
integer Collector_Log_0;
initial 
   begin 
		PacketID 	<= 0; UpStrFull <= 0; GntUpStr		<=0;
		CYCLE_COUNTER <= 0;	SenderID <= 0; STATE_Collector <= WAIT_REQ;
   end

always @(posedge clk)
   begin 
   CYCLE_COUNTER = CYCLE_COUNTER + 1'b1;   
   end	
//###########################   Modules(PEs) Collector ################################### 
always @(posedge clk or negedge reset)
  begin
    if( !reset)// reset all registers   
      begin 
		PacketID 	<= 0; UpStrFull <= 0; GntUpStr		<=0;
		CYCLE_COUNTER <= 0;	SenderID <= 0; STATE_Collector <= WAIT_REQ;
      end
	else //if (ReqUpStr ) 
		begin 
			UpStrFull <=0; //send UpStrFull to Local Port
				case(STATE_Collector)
				WAIT_REQ:
					begin
						if(ReqUpStr) 
							begin
						    STATE_Collector <= RECEIVE_DATA;	
						    GntUpStr	<=1;
							PacketID 	<= PacketIn[24 : 15];
							SenderID	<= PacketIn[14 : 9];
							data        <= PacketIn[8 : 0 ];
							end			
					end//WAIT_REQ
				RECEIVE_DATA:
					begin
						GntUpStr		<=0;
						STATE_Collector <= WAIT_REQ;
					end // RECEIVE_DATA
				 endcase	
        end // else
  end // always 
endmodule