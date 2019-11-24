`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/11/05 21:27:30
// Design Name: 
// Module Name: smg_display
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


module smg_display(clk_smg,rst,in_data,display_en,sel_smg,data_in_smg);
    input clk_smg;
	input rst;
	input [31:0]in_data;//8位数码管在四位上显示
	input display_en;
	output [3:0]sel_smg;//4个smg
	output[7:0]data_in_smg;
	reg [3:0]sel_smg;
	reg [7:0]data_in_smg;
	
	reg clk_1s;//4999_9999计时0.5�?
	reg [8:0]cnt_500ms;//500* clk_1k,==0.5s.
	reg clk_1k;//20ms刷新数码�?
	reg [15:0]cnt;
//    reg[15:0]in_data=0;
	
	reg[3:0]data_in;//十进制数
	reg[31:0]data_buffer_four=0;
	
	
	//1ms时钟生成，只要小�?20ms人的肉眼就认为残影不�?
	always@(posedge clk_smg or  negedge rst)begin
		if(!rst)begin	
			cnt<=0;
			clk_1k<=1'b0;
			data_buffer_four<=0;
		end
		else if(cnt==16'd49999)begin//0.5us翻转�?�?1k的时�?
			clk_1k<=~clk_1k;
			cnt<=0;
			
		end
		else begin
		  if(display_en)//����
		     data_buffer_four<=in_data;
		    
			clk_1k<=clk_1k;
			cnt<=cnt+1'b1;
		end
	end
	
	reg[31:0]data_on_four;
	reg[4:0]i;
	always@(posedge clk_1s or  negedge rst)begin
        if(!rst)begin
            data_on_four<=0;
            i<=0;
        end
        else begin
            data_on_four<=data_buffer_four>>i;
            i<=i+4;
        end
    end
//	reg[3:0]select;
	always@(posedge clk_1k or  negedge rst)begin
		if(!rst)begin
//			select<=4'b1110;
			cnt_500ms<=0;
			clk_1s<=0;
		end
		else begin
//			select<=select>>1;//左右移动无所�?
			
			if(cnt_500ms==9'd500)begin
				cnt_500ms<=0;
				clk_1s<=~clk_1s;//500ms翻转�?次�??1s的clk
//				in_data<=in_data+1;
		    end
			else 
				cnt_500ms<=cnt_500ms+1;//
		end
	end
	
	reg[15:0]data_on_smg;
	reg[3:0]data_in1=0;
	reg[3:0]data_in2=0;
	reg[3:0]data_in3=0;
	reg[3:0]data_in4=0;
	always@(posedge clk_1s or negedge rst)begin
		if(!rst)begin
			data_on_smg<=0;
			data_in1<=0;
			data_in2<=0;
			data_in3<=0;
			data_in4<=0;
		end
		else begin
			data_on_smg<=data_on_four[15:0];//待更改，进来的数不一定就是路径，可能是非路径0
			data_in1<=data_on_smg[3:0];
			data_in2<=data_on_smg[7:4];
			data_in3<=data_on_smg[11:8];
			data_in4<=data_on_smg[15:12];
		end
	end
	
	reg[2:0] cnt_sel;
	always@(posedge clk_1k or negedge rst)begin
	   if(!rst)begin
	       cnt_sel<=0;
	   end
	   else begin
	       if(cnt_sel<3)
	           cnt_sel<=cnt_sel+1;
	       else cnt_sel<=0;
	   end
	end
	
	always@(cnt_sel,rst)begin
	   if(!rst)begin
	       sel_smg=4'b0111;
	       data_in=10;//-
	   end
	   else 
	       case(cnt_sel)
	           0:begin
	             data_in=data_in1;  
	             sel_smg=4'b0111;
	           end
	          1:begin
	              data_in=data_in2;  
                  sel_smg=4'b1011;
	          end
	          2:begin
	              data_in=data_in3;  
                  sel_smg=4'b1101;	          
	          end
	          3:begin
	              data_in=data_in4;  
                  sel_smg=4'b1110;	          
	          end
	          default:begin
	               sel_smg=4'b0111;
                   data_in=10;
              end
	       endcase    
	end
	
	
	always@(data_in)
		case(data_in)
			4'b0000:data_in_smg<=8'b1100_0000;
			4'b0001:data_in_smg<=8'b1111_1001;
			4'b0010:data_in_smg<=8'b1010_0100;
			4'b0011:data_in_smg<=8'b1011_0000;
			4'b0100:data_in_smg<=8'b1001_1001;
			4'b0101:data_in_smg<=8'b1001_0010;
			4'b0110:data_in_smg<=8'b1000_0010;
			4'b0111:data_in_smg<=8'b1111_1000;
			4'b1000:data_in_smg<=8'b1000_0000;
			4'b1001:data_in_smg<=8'b1001_0000;
//			4'b1010:data_in_smg<=8'b1000_1000;
//			4'b1011:data_in_smg<=8'b1000_0011;
//			4'b1100:data_in_smg<=8'b1010_0111;
//			4'b1101:data_in_smg<=8'b1010_0001;
//			4'b1110:data_in_smg<=8'b1000_0100;
//			4'b1111:data_in_smg<=8'b1000_1110;
			default:data_in_smg<=8'b1011_1111;
		endcase

	

	

		


endmodule