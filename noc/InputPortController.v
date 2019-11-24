`timescale 1ns / 1ps

module InputPortController ( clk, reset, req , gnt , empty , PacketIn,
                           PacketOut );
// --------------------------------------------------------------------------- //
// ------------------------ Parameter Declarations --------------------------- //
parameter routerNo  = 8; // change depends on mesh size
parameter packetwidth = 55;// number of bits for data bus
// dimension of x,y fields in source and destination  
// names of states of FSM 
parameter Idle = 2'b00,
          Read = 2'b01,
          Route = 2'b10,
          Grant = 2'b11; 		 
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
input gnt;// grant from FIFO Buffer  
input empty;// indicator from FIFO buffer .. if empty = 1 else = 0
input [packetwidth-1:0] PacketIn;// input data Packet to fifo
// grant bus from output controller which grant communication with other routers 
// ------------------------ Outputs Declarations ----------------------------- //
output req;// request to FIFO Buffer   
output [packetwidth-1:0] PacketOut;// output data Packet form fifo
/*            North (1)
               |
               |
 East(0)---- Local(4) ---- West (2)
               |
               |
             South (3)
 */ 
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;  
wire gnt;// grant from fifo buffer 
// grant bus from output controller which grant communication with other routers 
wire [packetwidth-1:0] PacketIn;// input data Packet from fifo
wire [packetwidth-1:0] PacketOut;// output data Packet to output Controller
wire empty;// indicator from FIFO buffer .. if empty = 1 else = 0
// ------------------------ Registers Declarations --------------------------- //
reg req, EnableRoute;// request to FIFO Buffer  
reg [packetwidth-1:0] dataBuf,Temp;// data buffer register 
reg [1:0] State;

initial 
	begin
		req <= 0; EnableRoute <= 0;
		req <= 0;
		dataBuf <= 0;
		Temp <= 0;
		State <= Idle;
	end

always @(posedge clk or negedge reset)
  begin
    if( !reset)
      begin 
		  req 			<= 0;
        dataBuf 		<= 0;
		  Temp 			<= 0;
        State 			<= Idle;
      end
    else
      begin
        case (State)// FSM 
          Idle :
			 begin
				 if ( !empty )
					begin
					  State 	<= Read;
					  req 	<= 1;
					end
				else
					begin
						req 	<= 0;
						State <= Idle;
					end
					
			 end//Idle
          Read : 
			 begin     
				if ( gnt )
					begin
						req <= 0;
						State <= Route;
					end 
				else
					begin
						req <= 0;
						State <= Read;
					end
			 end//Read
          Route : 
		   begin
            State <= Idle;
				dataBuf <= PacketIn;
           end
       endcase
      end // reset
  end // always 
// ----------------------- Combinational Logic  ------------------------------ //
assign PacketOut = dataBuf;
// --------------------------------------------------------------------------- //
endmodule
// ----------------------------- End of File --------------------------------- //
