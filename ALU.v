`timescale 1 ns /1 ns
// 对各种操作指令的定义
`define B15to0H 4'b0000
`define AandBH  4'b0011
`define AorBH   4'b0100
`define AaddBH  4'b0001
`define AsubBH  4'b0010
`define AshflH  4'b0101
`define AshfrH  4'b0110
`define AmulBH  4'b0111
`define AcmpBH  4'b1000
`define ArgsfH	 4'b1001
`define AxorBH  4'b1010

module ALU (
	clk, rst, en_in,
	alu_a, alu_b, alu_func,
	en_out, alu_out
);
	// 输入的两个操作数
	input [15:0] alu_a, alu_b;
	// 时钟，重置和使能信号
	input clk, rst, en_in;
	// 输入的操作指令
	input [3:0] alu_func;
	// 输出
	output [15:0] alu_out;
	// 输出有效指令
	output en_out;
	// 中间过程寄存器
	reg [15:0] alu_out;
	reg  en_out;

	always @(negedge rst or posedge clk ) 
	begin
	   if(rst == 1'b0)
		// 当rst有效时，rst为有效，将alu_out和en_out置为0
		begin
			alu_out <= 0;
			en_out <= 0;
		end			
		else if(en_in == 1'b1)
		// en_in有效时，进行运算操作
		begin
			en_out <= 1;	// 先把en_out设为有效
			case (alu_func)
			// 对不同的输入指令执行相应的操作
				`B15to0H: alu_out <= alu_b;
				`AandBH: alu_out <= alu_a & alu_b;
				`AorBH: alu_out <= alu_a | alu_b;
				`AaddBH: alu_out <= alu_a + alu_b;
				`AsubBH: alu_out <= alu_a - alu_b;
				`AshflH: alu_out <= alu_a << 1;
				`AshfrH: alu_out <= alu_a >> 1;
				`AmulBH: alu_out <= alu_a * alu_b;
				`AcmpBH:
				begin
					if(alu_a > alu_b)
						alu_out <= alu_a;
					else
						alu_out <= alu_b;
				end
				`ArgsfH:
				begin
					if(alu_a & 16'b1 == 0)
						alu_out <= alu_a >> 1;
					else 
						alu_out <= {1'b1,alu_a[15:1]};
				end
				`AxorBH: alu_out <= alu_a ^ alu_b;
				default:  alu_out <= 0;	// 默认alu_out的输出为0
			endcase
		end
		else
		// 如果输入使能无效则置输出使能无效
			en_out <= 1'b0;	// 如果输入使能无效则置输出使能无效
    end
endmodule