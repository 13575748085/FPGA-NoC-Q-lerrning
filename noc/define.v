`timescale 1ns / 1ps

//�����ģ��
`define rand_clk_T_define 9 //rand_clk_T_define*2��ʾÿ���ٸ�clk����һ���������Ӧ�ú�Q_learn��������ƥ�� 
                                //rand_clk_T_define*2=R_change_cnt_limit_define-2
//state_mapģ��                                
`define map_matrix_state_bit 2//2��ʾx=8,y=8��״̬��81��noc                               
`define map_matrix_state_length 3//��NOC_state�ĳ��ȣ�Ϊ3*3=9��״̬

//����������
`define Update_R_matrix_cnt_define 1000//֮ǰ20��clk����R��20-1020��clK�ȴ���֮ǰ20��clk����R
`define Q_reward_BRAM_Width 10 //11bit 0-2048����
//`define Q_reward_BRAM_Depth 9 //10bit 0-1024��Ԫ��ַ��
//`define BRAM_Matrix_Q_Width 9 //���󳤿�Ϊ9 
`define Matrix_state_action_length 3 //�����Ϊ4ʱ����ʾ2^5=32����ľ��� reg[4:0]state
//`define BRAM_Mix_value 0//��ʼ�����������ֵQ��10��

//`define R_reward_BRAM_Width 9 //10bit 0-1024����
//`define R_reward_BRAM_Depth 7//8bit  256��Ԫ



//Q_learn.v��
`define Q_learn_end_time_define 50//50���������ڣ�����֮ǰ��Ҫ��ȫ������·����
//`define epsisode_define 10'd50
//`define Update_R_cnt_define 4'd5 //R����ͣ��5��ʱ�ӽ���д�����(0-15�ɸ�)
//`define Update_Q_cnt_define 4'd10
//`define READ_Q_cnt_define 4'd10
//`define R_CHANGE_cnt_define 15'd20  //�ڼ�������ڸ�ֵ��ʱ����ɨ�裬��change_flag=1ʱ����Ȼ����һ��R����
//`define R_change_cnt_limit_define 25 //���ֵȡ����������·���ڣ�R�иı�Ļ�·Ϊ���ޣ�����ͨ��·���ڣ�R���ı��·Ϊ���ޣ�
//`define Q_target_state 5'd9  //���ڴ洢�ĵ�1��Ϊ0�����Եھ�Ϊ8

`define Q_gamma 7//Q_learningѧϰϵ����Խ�ߣ�ѧ��Խ�죿��Խ���׽ӽ�����Ŀ���R��ֵ
`define THE_WHOLE_BLOCK_define 1//С�ڸ�ֵʱ��ʾȫ����

module define(

    );
endmodule
