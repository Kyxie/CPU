module Register(
	clk, rst, en_in,		
	reg_en, d_in,		
	rd, rs, en_out,		
   rd_q, rs_q	
   );
	input clk,rst,en_in;
	input wire[3:0] reg_en;	// 寄存器使能信号
	input wire[15:0] d_in;	// 寄存器输入(alu_out)
	input wire[1:0] rd,rs;	// 输入选择信号
	output reg en_out;	// 输出有效信号
	output reg[15:0] rd_q,rs_q;	// 输出值
	reg[15:0] r[3:0];	// 寄存器组 意思是创建4个16位的寄存器
	
	// 初始化寄存器组的值为0
	initial
	begin
		r[0]=16'b0;
		r[1]=16'b0;
		r[2]=16'b0;
		r[3]=16'b0;
	end
	
	always @(posedge clk)
	begin
	// 根据reg_en的值将d_in存入寄存器
		case(reg_en)
			4'b0001: r[0] <= d_in;
			4'b0010: r[1] <= d_in;
			4'b0100: r[2] <= d_in;
			4'b1000: r[3] <= d_in;
		endcase
	end
	
	always@(posedge clk or negedge rst)
	begin
		// 如果rst有效则置rd_q，rs_q为0，en_out无效
		if(rst == 1'b0)
		begin
			rd_q <= 16'b0;
			rs_q <= 16'b0;    
			en_out <= 1'b0; 
		end
		// 如果使能en_in（低有效）有效，则读取数据，并将输出使能en_out(高有效)置为有效
		else if(en_in == 1'b1)
		begin
			rd_q <= r[rd];
			rs_q <= r[rs];
			en_out <= 1'b1;
		end
		// 如果使能en_in（低有效）无效，将输出使能en_out(高有效)置为无效
		else
			en_out <= 1'b0;
	end
endmodule  