`timescale 1ns / 1ps

module PC(
	clk, rst, en_in,
	pc_ctrl, offset_addr, 		 			 
	pc_out  		
   );
	input clk,rst,en_in;	 // 时钟，重置和使能信号
	input wire[1:0] pc_ctrl;	 // 控制指令
	input wire[7:0] offset_addr;	 // 地址偏移
	output reg[15:0] pc_out;    // 输出
   
	always@(posedge clk or negedge rst)
	 begin
		 // 如果rst（低有效）有效，则将pc_out置为0
		 if(rst==0)
		 begin
			pc_out <= 0;
		 end
		 else
		 begin
			if(en_in==1)
			// 如果输入使能有效，则按控制信号pc_ctrl的值做不同的操作
			begin
				case (pc_ctrl)
					// 按pc_out的值做出相应的操作，提示 verilog 的拼接操作为{}，如{1'b1,2'b01}=3'b101;
					2'b00: pc_out <= pc_out;
					2'b01: pc_out <= pc_out + 1;	//每次时钟周期内都+1
					2'b10: pc_out <= {8'b0,offset_addr};
					// 默认时pc_out保持不变
					default: pc_out <= pc_out;
				endcase
			end
		 end   	 
	 end
endmodule