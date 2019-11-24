`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/10/22 22:41:28
// Design Name: 
// Module Name: state_Map
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "define.v"
module state_Map(
        input clk,
        input rst,
          
        input [`map_matrix_state_bit:0]in_state_x,
        input [`map_matrix_state_bit:0]in_state_y,
        output [`Matrix_state_action_length:0]Convert_to_NoC_state,
//        output[`Matrix_state_action_length:0]Next_NoC_state,
        
        input [`Matrix_state_action_length:0]in_NoC_state,  
        output [`map_matrix_state_bit:0] Convert_to_state_x,
        output [`map_matrix_state_bit:0] Convert_to_state_y
     
        );
        

    
        assign Convert_to_NoC_state=(in_state_y-1)*`map_matrix_state_length+in_state_x;//输入2，1时，输出为4.随define自适应所有矩阵
        assign Convert_to_state_x=(in_NoC_state-1)%`map_matrix_state_length+1;//(5-1)%3+1=2. (6-1)%3+1=3,(4-1)%3+1=1
        assign Convert_to_state_y=(in_NoC_state+`map_matrix_state_length-1)/`map_matrix_state_length;//(5+2)/3=2很重要
        
        

endmodule
