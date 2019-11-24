
module Collector_010_010
(
clk, 
reset, 
PacketIn, 
UpStrFull, 
ReqUpStr, 
GntUpStr,
done
);
 // ------------------------ Parameter Declarations --------------------------- //
parameter routerID = 6'b010_010; 
parameter ModuleID =6'b010_010;
parameter packetwidth = 56;
parameter 	WAIT_REQ=1'b0,RECEIVE_DATA=1'b1;
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
input ReqUpStr;
output UpStrFull; 
output GntUpStr;  
output reg done=0;

input [packetwidth-1:0] PacketIn;
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
wire ReqUpStr; 
wire [packetwidth-1:0] PacketIn;
// ------------------------ Registers Declarations --------------------------- //
reg UpStrFull;
reg GntUpStr;  
reg [packetwidth-1:0] dataBuf;
reg [8:0]     data;
reg [9:0]     PacketID;
reg [15:0]    CYCLE_COUNTER;  
reg  STATE_Collector; 
reg [5:0] SenderID;
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
    if( !reset)  
      begin 
		PacketID 	<= 0; UpStrFull <= 0; GntUpStr		<=0;
		CYCLE_COUNTER <= 0;	SenderID <= 0; STATE_Collector <= WAIT_REQ;
		done<=0;
      end
	else 
		begin 
			UpStrFull <=0; 
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
						if(data==9'b101100111)
						      done<=1;
					end // RECEIVE_DATA
				 endcase	
    end // else
  end // always 
endmodule
