module control_unit (
	clk,rst,en,en_alu,en_ram_out,ins,
	offset_addr,en_ram_in,	
	en_rf_pulse,en_pc_pulse,reg_en,
	alu_in_sel,alu_func,pc_ctrl  		
);
input clk,rst,en,en_alu	,en_ram_out;	
input [15:0] ins;
output en_ram_in,en_rf_pulse,en_pc_pulse,alu_in_sel;	
output [7:0]	offset_addr;
output [3:0]	reg_en,alu_func;
output [1:0]	pc_ctrl;

wire [15:0] ir_out ;
wire	en_out ;
reg [7:0] offset_addr;
// control_unit实际要做的事情是翻译机器码，将机器码通过状态转移模块翻译成cpu内部信号，以执行不同的动作
// 指令寄存器
ir ir1 (
	.clk(clk),
	.rst(rst),
	.ins(ins),
	.en_in(en_ram_out),
	.en_out(en_out),
	.ir_out(ir_out)
);
// 状态转移模块
state_transition state_transition1(
	.clk(clk),
	.rst(rst),
	.en_in(en),
	// en1输入的是指令寄存器的输出使能
	.en1(en_out),
	// en2实际上接的是alu的输出使能
	.en2(en_alu),
	// 对应机器指令的rd
	.rd(ir_out[11:10]),
	// 对于机器指令的opcode
	.opcode(ir_out[15:12]),
	// 输出内存使能信号
	.en_fetch_pulse(en_ram_in),
	// 输出的寄存器组使能信号
	.en_rf_pulse(en_rf_pulse),
	// 输出的程序计数器使能信号
	.en_pc_pulse(en_pc_pulse),
	// 这几个输出是状态转移模块根据不同的opcode和rd产生的输出
	.pc_ctrl(pc_ctrl) ,
	.reg_en(reg_en) ,
	.alu_in_sel(alu_in_sel)	,
	.alu_func(alu_func)			
);
// offset_addr对应机器指令的立即数		
always @ (en_out,ir_out) 
begin
	offset_addr = ir_out[7:0];
end


endmodule