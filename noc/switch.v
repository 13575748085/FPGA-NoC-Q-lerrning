`timescale 1ns / 1ps



module switch(
    input[6:0]switch16,
    input clk_sw,
    input rst,
    output reg [8:0]Noc_to_R_matrix_where=0,//��ʼ��
    output reg [17:0]Noc_to_R_matrix_action=0,
    output reg [89:0]Noc_to_R_matrix_value=0,
    output reg R_change_flag,
    output reg R_martix_rst
    );
    reg state;
    reg[2:0]cnt_R_change;
    always@(posedge clk_sw,negedge rst)begin
        if(!rst)
            cnt_R_change<=0;
        else begin
            if(R_change_flag==1)//��state��һ��clk
                if(cnt_R_change<3)
                    cnt_R_change<=cnt_R_change+1;
                else//ע�ͱ�������
                    cnt_R_change<=cnt_R_change;
            else if(R_change_flag==0)    
                cnt_R_change<=0;
        end
    end

    
    always@(posedge clk_sw,negedge rst)begin
        if(!rst)begin
            state<=0;
            R_change_flag<=0;
        end
        else begin
            case(state)
                0:begin
                    R_change_flag<=0;
                    if(switch16[0]==1) state<=1;
                
                end
                1:begin
                    if(switch16[6:1]!=5'b00000)R_change_flag<=1;
                    if(switch16[0]==0) state<=0;
                end
            endcase         
        end
    end
    
    reg nouse;
    reg no=0;
    reg[3:0]state_no;
    always@(posedge clk_sw,negedge rst)begin
        if(!rst)
            nouse=crowd_state_0(switch16);//��λ 
        else begin
            if(state==0)
                nouse=0;
            else begin//״̬Ϊ1ʱ�����ܼ�������
                case(cnt_R_change)
                0:
                    if(switch16[1])nouse=crowd_state_0(cnt_R_change);
                    else if(switch16[6])nouse=crowd_state_5(cnt_R_change);
                    else if(switch16[5])nouse=crowd_state_4(cnt_R_change);
                    else if(switch16[4])nouse=crowd_state_3(cnt_R_change);         
                    else if(switch16[3])nouse=crowd_state_2(cnt_R_change);
                    else if(switch16[2])nouse=crowd_state_1(cnt_R_change);
                1:
                   if(switch16[1])nouse=crowd_state_0(cnt_R_change);
                   else if(switch16[6])nouse=crowd_state_5(cnt_R_change);
                   else if(switch16[5])nouse=crowd_state_4(cnt_R_change);
                   else if(switch16[4])nouse=crowd_state_3(cnt_R_change);         
                   else if(switch16[3])nouse=crowd_state_2(cnt_R_change);
                   else if(switch16[2])nouse=crowd_state_1(cnt_R_change);
                2:
                    if(switch16[1])nouse=crowd_state_0(cnt_R_change);
                    else if(switch16[6])nouse=crowd_state_5(cnt_R_change);
                    else if(switch16[5])nouse=crowd_state_4(cnt_R_change);
                    else if(switch16[4])nouse=crowd_state_3(cnt_R_change);         
                    else if(switch16[3])nouse=crowd_state_2(cnt_R_change);
                    else if(switch16[2])nouse=crowd_state_1(cnt_R_change);                
                3:    
                    if(switch16[1])nouse=crowd_state_0(cnt_R_change);
                    else if(switch16[6])nouse=crowd_state_5(cnt_R_change);
                    else if(switch16[5])nouse=crowd_state_4(cnt_R_change);
                    else if(switch16[4])nouse=crowd_state_3(cnt_R_change);         
                    else if(switch16[3])nouse=crowd_state_2(cnt_R_change);
                    else if(switch16[2])nouse=crowd_state_1(cnt_R_change);  
                default:nouse=0;                  
                endcase  
           end
        end
    end
    
    function crowd_state_0;
            input cnt_R_change;
            
            begin
                R_martix_rst=1;
                crowd_state_0=0;
                state_no=0;
            end
         endfunction
    
     function crowd_state_1;
        input cnt_R_change;
         begin
            Noc_to_R_matrix_action[5:4]=2'b01;
            if(cnt_R_change==Noc_to_R_matrix_action[5:4])begin
               R_martix_rst=0;
               Noc_to_R_matrix_where[2]=1;
               
               Noc_to_R_matrix_value[29:20]=10'b0;
               crowd_state_1=1;
               state_no=1;
            end
        end
     endfunction
     
     function crowd_state_2;
        input cnt_R_change;
        begin
            no=crowd_state_1(cnt_R_change);//�ݹ�
             Noc_to_R_matrix_action[9:8]=2'b01;
            if(cnt_R_change==Noc_to_R_matrix_action[9:8])begin
 
               R_martix_rst=0;
               Noc_to_R_matrix_where[4]=1;
              
               Noc_to_R_matrix_value[49:40]=10'b0;
               crowd_state_2=2;
               state_no=2;
           end
        end
     endfunction
 
      function crowd_state_3;
        input cnt_R_change;
        begin
             no=crowd_state_2(cnt_R_change);//�ݹ�
             Noc_to_R_matrix_action[1:0]=2'b01;
            if(cnt_R_change==Noc_to_R_matrix_action[1:0])begin
              
               R_martix_rst=0;
               Noc_to_R_matrix_where[0]=1;
               
               Noc_to_R_matrix_value[9:0]=10'b0;
               crowd_state_3=3;//��ֹ���صı�־ֵ��ˢ�������Է����?
               state_no=3;
           end
        end
     endfunction   
 
      function crowd_state_4;
       input cnt_R_change;
       begin
          no=crowd_state_3(cnt_R_change);//�ݹ�
           Noc_to_R_matrix_action[9:8]=2'b00;
         if(cnt_R_change==Noc_to_R_matrix_action[9:8])begin
             
              R_martix_rst=0;
              Noc_to_R_matrix_where[4]=1;
             
              Noc_to_R_matrix_value[49:40]=10'b0;
              crowd_state_4=4;//��ֹ���صı�־ֵ��ˢ�������Է����?
              state_no=4;
          end
       end
    endfunction   
    
     function crowd_state_5;
     input cnt_R_change;
//     input[1:0] action;
     begin
        no=crowd_state_4(cnt_R_change);//�ݹ�
         Noc_to_R_matrix_action[1:0]=2'b00;
        if(cnt_R_change==Noc_to_R_matrix_action[1:0])begin 
            R_martix_rst=0;
            Noc_to_R_matrix_where[0]=1;
           
            Noc_to_R_matrix_value[9:0]=10'd16;
            crowd_state_5=5;//��ֹ���صı�־ֵ��ˢ�������Է����?
            state_no=5;
        end
     end
     endfunction  
endmodule
