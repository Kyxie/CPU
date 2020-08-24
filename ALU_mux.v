module ALU_mux (
	clk, rst, en_in, offset,
	rd_q, rs_q, alu_in_sel, 
	alu_a, alu_b, en_out
);
	// 输入操作数
	input [15:0] rd_q, rs_q;
	// 时钟信号，重置信号，使能信号，选择信号
	input clk, rst, en_in, alu_in_sel;
	// 偏移数据
	input [7:0] offset;
	// 输出
	output [15:0] alu_a,alu_b;
	// 输出使能
	output en_out;
	// 中间寄存器
	reg [15:0] alu_a,alu_b;
	reg  en_out;

	always @( negedge rst or posedge clk ) 
	begin
	   if(rst ==1'b0)
		// 如果rst（低有效）有效，置alu_a,alu_b为0，且输出使能en_out（高有效）无效
		begin
			alu_a <= 15'b0;
			alu_b <= 15'b0;
			en_out <= 1'b0;
	   end		
		else	
		begin
			if(en_in == 1'b1)
			// 如果使能有效则进行操作
			begin
				// 置输出使能en_out（高有效）有效
				en_out <= 1'b1;
				// 设置alu_a的值
				alu_a <= rd_q;
				// 根据alu_in_sel的值设置alu_b的值
				if(alu_in_sel == 1'b0)
				begin
					alu_a <= rd_q;
					alu_b <= offset;
				end
				else
				begin
					alu_a <= rd_q;
					alu_b <= rs_q;
				end
			end
			else
			// 使能无效时置输出使能无效
				en_out <= 1'b0;
		end
	end

endmodule