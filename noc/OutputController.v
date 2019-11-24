`timescale 1ns / 1ps
module OutputController( clk, reset, reqDnStr, gntDnStr, full, 
PacketInPort_0, PacketInPort_1, PacketInPort_2 , PacketInPort_3,PacketInPort_4,PacketOut);
// ------------------------ Parameter Declarations --------------------------- //
parameter routerNo  = 8; // change depends on mesh size 
parameter packetwidth = 55;// number of bits for data bus
parameter datawidth=25;
parameter direction =3'b000;
parameter SEND_REQ=1'b0, 
				    WAIT_GRANT=1'b1;
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
input gntDnStr;// grant from down Stram router   
input full;// indicator from FIFO buffer of down stream router .. if full = 1 else = 0
input [packetwidth-1:0] PacketInPort_0, PacketInPort_1, PacketInPort_2, PacketInPort_3,PacketInPort_4;
// ------------------------ Outputs Declarations ----------------------------- //
output reqDnStr;// request to down Stram router   
output [packetwidth-1:0] PacketOut;// output data Packet form fifo
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
wire gntDnStr;// grant from down Stram router   
wire full;// indicator from FIFO buffer of down stream router .. if full = 1 else = 0
// input data Packet from fifo
wire [packetwidth-1:0] PacketInPort,PacketInPort_0, PacketInPort_1, PacketInPort_2, PacketInPort_3,PacketInPort_4;
reg  [packetwidth-1:0] PacketOut;// output data Packet to output Controller
// ------------------------ Registers Declarations --------------------------- //
reg reqDnStr;// request to down Stram router   
//register to hold Packet out until makeing arbitration and grant
wire [packetwidth-1:0] DataBuff;
reg [1:0] STATE;

assign PacketInPort=PacketInPort_0|PacketInPort_1 | PacketInPort_2 | PacketInPort_3 | PacketInPort_4;
initial 
   begin 
		reqDnStr  	<= 0;
		PacketOut  	<= 0;
		STATE			<= SEND_REQ;
   end
// ----------------------- Sequential  Logic  -------------------------------- //
always @(posedge clk or negedge reset)
  begin
    if( !reset)//reset all registers
      begin 
        reqDnStr  <= 0;
		  PacketOut  <= 0;
		  STATE		<= SEND_REQ;
      end
    else
	 begin
	 // handle request to down stream router 
      case(STATE)
			SEND_REQ:
				begin
					if ( (! full) &(PacketInPort[datawidth+2:datawidth]==direction))
						begin
						STATE 		 <= WAIT_GRANT;
						reqDnStr  <= 1;
						PacketOut<= {3'b000,(PacketInPort[packetwidth-1:datawidth+3]),PacketInPort[datawidth-1:0]};
						end
					else if(full)
						begin
						STATE 		<= SEND_REQ;
						end 
				end
		    WAIT_GRANT:
				begin
				if ( gntDnStr )
					begin
					STATE 		<= SEND_REQ;
					reqDnStr 	<= 0;
					end
				else
					begin
					STATE 		<= WAIT_GRANT;
					end
				end
			endcase
		end//else
  end // always 
endmodule
// ----------------------------- End of File --------------------------------- //