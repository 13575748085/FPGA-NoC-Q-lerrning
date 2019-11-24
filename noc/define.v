`timescale 1ns / 1ps

//随机数模块
`define rand_clk_T_define 9 //rand_clk_T_define*2表示每多少个clk产生一次随机数，应该和Q_learn计算周期匹配 
                                //rand_clk_T_define*2=R_change_cnt_limit_define-2
//state_map模块                                
`define map_matrix_state_bit 2//2表示x=8,y=8的状态，81的noc                               
`define map_matrix_state_length 3//表NOC_state的长度，为3*3=9个状态

//两个矩阵中
`define Update_R_matrix_cnt_define 1000//之前20个clk更新R，20-1020个clK等待，之前20个clk更新R
`define Q_reward_BRAM_Width 10 //11bit 0-2048数据
//`define Q_reward_BRAM_Depth 9 //10bit 0-1024单元地址数
//`define BRAM_Matrix_Q_Width 9 //矩阵长宽为9 
`define Matrix_state_action_length 3 //这个数为4时，表示2^5=32长宽的矩阵 reg[4:0]state
//`define BRAM_Mix_value 0//初始化给矩阵最大值Q【10】

//`define R_reward_BRAM_Width 9 //10bit 0-1024数据
//`define R_reward_BRAM_Depth 7//8bit  256单元



//Q_learn.v中
`define Q_learn_end_time_define 50//50个计算周期，在这之前需要完全收敛出路径。
//`define epsisode_define 10'd50
//`define Update_R_cnt_define 4'd5 //R矩阵停留5个时钟进行写入更新(0-15可改)
//`define Update_Q_cnt_define 4'd10
//`define READ_Q_cnt_define 4'd10
//`define R_CHANGE_cnt_define 15'd20  //在间隔两倍于该值的时间内扫描，（change_flag=1时）必然更新一次R矩阵
//`define R_change_cnt_limit_define 25 //这个值取决于整个回路周期（R有改变的回路为上限），普通回路周期（R不改变回路为下限）
//`define Q_target_state 5'd9  //由于存储的第1个为0，所以第九为8

`define Q_gamma 7//Q_learning学习系数，越高，学得越快？，越容易接近最终目标的R分值
`define THE_WHOLE_BLOCK_define 1//小于该值时表示全阻塞

module define(

    );
endmodule
