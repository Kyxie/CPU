module cpu(
	clk,rst,en_in,
	en_ram_out,addr,
	ins,en_ram_in 		
	);

input clk,rst,en_in,en_ram_out;
input [15:0] ins;
output [15:0]	addr;
output en_ram_in;

wire en_alu,alu_in_sel,en_pc_pulse,en_rf_pulse;
wire [1:0]pc_ctrl;
wire [3:0]alu_func;
wire [3:0]reg_en;
wire [7:0]offset_addr;
// 将data_path和control_unit连接起来

control_unit control_unit1(
	.clk(clk),
	.en_alu(en_alu),
	.en_ram_out(en_ram_out),
	.en(en_in),
	.ins(ins),
	.rst(rst),
	.alu_func(alu_func),
	.alu_in_sel(alu_in_sel),
	.en_pc_pulse(en_pc_pulse),
	.en_ram_in(en_ram_in),
	.en_rf_pulse(en_rf_pulse),
	.offset_addr(offset_addr),
	.pc_ctrl(pc_ctrl),
	.reg_en(reg_en)
);

Data_path Data_path1(
	.alu_func(alu_func),
	.alu_in_sel(alu_in_sel),
	.clk(clk),
	.en_in_rf(en_rf_pulse),
	.en_pc_pulse(en_pc_pulse),
	.offset(ins[7:0]),
	.offset_addr(offset_addr),
	.pc_ctrl(pc_ctrl),
	.rd(ins[11:10]),
	.reg_en(reg_en),
	.rs(ins[9:8]),
	.rst(rst),
	.en_out(en_alu),
	.pc_out(addr)
);

endmodule