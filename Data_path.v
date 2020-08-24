module Data_path (
	clk, rst, offset_addr,
	en_pc_pulse, pc_ctrl, offset,
	en_in_rf,reg_en, alu_in_sel, alu_func,
	en_out, pc_out, rd, rs,
	);

input clk,rst,en_pc_pulse,en_in_rf,alu_in_sel;
input [7:0] offset_addr,offset;
input [1:0] pc_ctrl,rd,rs;
input [3:0] reg_en;
input [3:0] alu_func;
output [15:0] pc_out;
output en_out;

wire [15:0] rd_q, rs_q, alu_a, alu_b, alu_out;	
wire en_out_rf, en_out_alu_mux;  

PC pc1(
	.clk(clk),
	.rst(rst),       
	.en_in(en_pc_pulse),
	.pc_ctrl(pc_ctrl),
	.offset_addr(offset_addr), 		 			 
	.pc_out(pc_out)	
    );
	 
	// 仿照pc1和alu1，将其他两个模块调用过来形成data_path

Register rf(
	.clk(clk),
	.rst(rst),
	.rd(rd),
	.rs(rs),
	.rd_q(rd_q),
	.rs_q(rs_q),
	.en_in(en_in_rf),
	.reg_en(reg_en),
	.en_out(en_out_rf),
	.d_in(alu_out)
	);
			
ALU_mux alu_mux1(                                        
	.clk(clk),
	.rst(rst),
	.en_in(en_out_rf),
	.rd_q(rd_q),
	.rs_q(rs_q),
	.alu_a(alu_a),
	.alu_b(alu_b),
	.offset(offset),
	.alu_in_sel(alu_in_sel),
	.en_out(en_out_alu_mux)
	);
	
ALU alu1(
	.clk(clk),
	.rst(rst),
	.en_in(en_out_alu_mux),					
	.alu_a(alu_a),
	.alu_b(alu_b),
	.alu_func(alu_func),
	.en_out(en_out),
	.alu_out(alu_out ) 
	);				
				
endmodule