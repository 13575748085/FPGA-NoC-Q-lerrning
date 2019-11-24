`include "define.v"
module B_Router_Mesh3x3_tb(
//     input wire clk,
     input wire CLK,
     input wire reset,
     input wire switch0,
     input wire [6:0]switch16,

     output wire [`Matrix_state_action_length:0] sel_smg,
     output wire  done,
     output wire [7:0] data_in_smg,
     input VGA_rst,
     output  [3:0]   VGA_R,
     output  [3:0]   VGA_G,
     output  [3:0]   VGA_B,
     output          VGA_HS,
     output          VGA_VS
        

);
	// Inputs
    wire enroute;
    wire [29:0] RouteInfoIn;
    wire ReqRoute;
    wire [9:0] Sor_DesInfo;
    wire Q_learn_ready;
    	
    wire[8:0]Noc_to_R_matrix_where;
    wire[17:0]Noc_to_R_matrix_action;
    wire[89:0]Noc_to_R_matrix_value;
    wire R_change_flag;
    wire R_martix_rst;
    wire [`Matrix_state_action_length:0] packet_state_now;
    reg clk=0;
    reg [2:0] counter=0;
    always @( posedge CLK ) 
    begin
        counter=counter+1;
        if(counter==5)
        begin
            clk=~clk;
            counter=0;
        end
    end
	B_Router_Mesh3x3 uut (
		.clk(clk), 
		.reset(reset),
		.enroute(enroute),
		.RouteInfoIn(RouteInfoIn),
		.ReqRoute(ReqRoute),
		.Sor_DesInfo(Sor_DesInfo),
		.Q_learn_ready(Q_learn_ready),
		.switch(switch0),
		.done(done)
	);
	/////////////////////////////////////////////
	Q_learn_v2 q (
	    .clk(clk),
        .rst(reset),
        .Noc_to_R_matrix_where(Noc_to_R_matrix_where),
        .Noc_to_R_matrix_action(Noc_to_R_matrix_action),
        .Noc_to_R_matrix_value(Noc_to_R_matrix_value),
        .NoC_request_route(Sor_DesInfo),
        .Noc_request_en(ReqRoute),
        .Q_learn_packet_to_NoC_end_flag(enroute),
        .action_route(RouteInfoIn),
        .Q_learn_ready(Q_learn_ready),
        .packet_state_now(packet_state_now)
	);
	/////////////////////////////////////////////////////
        QtoSmg_buffer  UU_buffer_smg(
        .clk(clk),
        .rst(reset),
        .Q_update_route_en(ReqRoute),
        .Q_next_state(packet_state_now),
        .sel_smg(sel_smg),
        .data_in_smg(data_in_smg)
        );
//////////////////////////////////////////////////////////    
        switch UU_sw(
        .switch16(switch16),
        .clk_sw(clk),
        .rst(reset),
        .Noc_to_R_matrix_where(Noc_to_R_matrix_where),
        .Noc_to_R_matrix_action(Noc_to_R_matrix_action),
        .Noc_to_R_matrix_value(Noc_to_R_matrix_value),
        .R_change_flag(R_change_flag),
        .R_martix_rst(R_martix_rst)
        );
        
        
        VGA UU_VGA(
        .CLK(CLK),
        .RST(VGA_rst),
        .WAIT(reset),
        .switch16(switch16),
        .VGA_R(VGA_R),
        .VGA_G(VGA_G),
        .VGA_B(VGA_B),
        .VGA_HS(VGA_HS),
        .VGA_VS(VGA_VS)
        );
            
endmodule
