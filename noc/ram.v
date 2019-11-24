// --------------------------------------------------------------------------- //
module ram (clk,reset, writeEn,readEn,writeAddr,readAddr,dataIn,dataOut);
// -------------------------- Parameters declarations ------------------------ //
// data bits number
parameter packetwidth = 55;
// address bits number   
parameter addressWidth = 4;
// ------------------- Clock and Reset signal declarations ------------------- //
// clock input
input clk;
// reset input
input reset;
// --------------------------- Input Ports ----------------------------------- //
// write enable;
input writeEn;
// read enable
input readEn;
// writting address ..
input [addressWidth-1:0] writeAddr;
// reading address
input [addressWidth-1:0] readAddr;
// Input data to be written
input [packetwidth-1:0] dataIn;
// ------------------------------ Output Ports ------------------------------- //
// output data to be read
output [packetwidth-1:0] dataOut;
// ------------------------ Register Declarations ---------------------------- //
reg [packetwidth-1:0] ram[(1<<addressWidth)-1:0];
reg [packetwidth-1:0] dataOut;
// ------------------ Wire Declarations--------------------------------------- //
wire [packetwidth-1:0] dataIn;
always @(posedge clk or negedge reset)
  begin
    // ---------------------------- reset all registers ---------------------- //        
    if( !reset)
		begin
      dataOut 		<= 0;
		end
    else
      begin 
      //  ---------------------------- write process ------------------------- // 
        if (writeEn)
            ram[writeAddr] <= dataIn;
      // ----------------------------- read process -------------------------- //
        if (readEn)
            dataOut <= ram[readAddr];
      end
       end
endmodule
