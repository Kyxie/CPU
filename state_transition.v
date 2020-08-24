module state_transition(clk,rst,en_in,en1,en2,rd,opcode,en_fetch_pulse,en_rf_pulse,en_pc_pulse,pc_ctrl,reg_en,alu_in_sel,alu_func);

input clk,rst;
input en_in;
// 接ir输出使能
input en1;
// 接alu输出使能
input en2;
input [1:0] rd;
input [3:0] opcode;
output reg en_fetch_pulse;
output reg en_rf_pulse;
output reg en_pc_pulse;
output reg [1:0] pc_ctrl;	//接PC控制
output reg [3:0] reg_en;	//接reg使能输入
output reg alu_in_sel;	//接alu_mux
output reg [3:0] alu_func;	//接alu

reg en_fetch_reg,en_fetch;
reg en_rf_reg,en_rf;
reg en_pc_reg,en_pc;
reg [5:0] current_state,next_state;

// 定义指令对应的编码
parameter Initial = 5'b00000;
parameter Fetch = 5'b00001;
parameter Decode = 5'b00010;
parameter Execute_Movel = 5'b00011;
parameter Execute_Move2 = 5'b00100;
parameter Execute_Add1 = 5'b00101;
parameter Execute_Add2 = 5'b00110;
parameter Execute_Sub = 5'b00111;
parameter Execute_And = 5'b01000;
parameter Execute_Or = 5'b01001;
parameter Execute_Jump = 5'b01010;
parameter Execute_Leftshift = 5'b01011;
parameter Execute_Rightshift = 5'b01100;
parameter Write_back = 5'b01101;
parameter Execute_Ringshift = 5'b01110;
parameter Execute_MUL = 5'b01111;
parameter Execute_CMP1 = 5'b10000;
parameter Execute_CMP2 = 5'b10001;
parameter Execute_XOR1 = 5'b10010;
parameter Execute_XOR2 = 5'b10011;

// 状态转移
always @ (posedge clk or negedge rst) 
begin
// 如果rst就置当前状态为Initial，否则当前状态转到下一个状态
	if(!rst)
		current_state <= Initial;
	else 
		current_state <= next_state;
end

// 控制下一状态
always @ (current_state or en_in or en1 or en2 or opcode) 
begin
	case (current_state)
		Initial: 
		// 初始化状态，如果使能有效则取指令，否则保持状态
		begin
			if(en_in)
				next_state = Fetch;
			else
				next_state = current_state;
		end
		Fetch: 
		// 取指令，如果ir输出使能有效则下一个状态为译码，否则保持当前状态
		begin
			if(en1) 
				next_state = Decode;
			else
				next_state = current_state;
		end
		Decode: 
		// 译码，根据opcode设置下一状态
		begin
			case(opcode) 
				4'b0000: next_state = Execute_Movel;
				4'b0001: next_state = Execute_Move2;
				4'b0010: next_state = Execute_Add1;
				4'b0011: next_state = Execute_Add2;
				4'b0100: next_state = Execute_Sub;
				4'b0101: next_state = Execute_And;
				4'b0110: next_state = Execute_Or;
				4'b0111: next_state = Execute_Jump;
				4'b1000: next_state = Execute_Leftshift;
				4'b1001: next_state = Execute_Rightshift;
				4'b1010: next_state = Execute_Ringshift;
				4'b1011: next_state = Execute_MUL;
				
				4'b1100: next_state = Execute_XOR1;
				4'b1101: next_state = Execute_XOR2;

				4'b1110: next_state = Execute_CMP1;
				4'b1111: next_state = Execute_CMP2;
				default: next_state = current_state;
			endcase
		end
		// 其他操作，在alu输出使能有效时，下一状态为回写，否则保持当前状态
		Execute_Movel: 
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_Move2: 
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_Add1: 
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_Add2: 
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_Sub: 
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_And: 
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_Or: 
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_Leftshift: 
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_Rightshift:
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_Ringshift:
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_MUL:
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_CMP1:
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_CMP2:
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_XOR1:
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		Execute_XOR2:
		begin
			if(en2)
				next_state = Write_back;
			else
				next_state = current_state;
		end
		// 思考:为什么jump和Write_back的下一状态都为取指令
		//jump回到初始指令
		//Write_back取下一条指令
		Execute_Jump: next_state = Fetch;
		Write_back: next_state = Fetch;
		default: next_state = Initial;
	endcase
end
//根据不同状态设置
//		en_fetch
//		en_rf
//		en_pc
//		pc_ctrl
//		reg_en
//		alu_in_sel
//		alu_func
// 参数的值，使得其他状态进行相应操作
// 思考：
// 1.什么指令要置alu_in_sel为1，不同指令的pc_ctrl的值
//Rd和Rs运算的时候要将alu_in_sel为1，和立即数运算的时候设为0
//fetch的时候pc_ctrl要一直+1，回写的时候要设置为offset，执行的时候不变

// 2.Execute_Movel，Execute_Move2的区别在哪儿，该怎么操作
//Execute_Movel是令Rd储存立即数
//Execute_Move2是令Rd储存Rs中的数

// 3.en_pc_pulse,en_rf_pulse,en_fetch_pulse应该在什么情况产生

// 4.在什么时候让程序计数器加一
//fetch
// 5.为什么是next_state
always @ (clk or rst or next_state) 
begin
	if(!rst) 
	begin
		en_fetch = 1'b0;
		en_rf = 1'b0;
		en_pc = 1'b0;
		pc_ctrl = 2'b00;
		reg_en = 4'b0000;
		alu_in_sel = 1'b0;
		alu_func = 4'b0000;
	end
	else 
	begin
		case (next_state)
			Initial: 
			// 初始化时，将参数全置0
			begin
				en_fetch = 1'b0;
				en_rf = 1'b0;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 4'b0000;
			end
			Fetch: 
			begin
				en_fetch = 1'b1;	//是否需要从RAM中读取指令
				en_rf = 1'b0;	//是否需要从寄存器阵列中读取数据
				en_pc = 1'b1;	//pc使能
				pc_ctrl = 2'b01;	//pc_out += 1，pc用来控制从RAM读取的指令
				reg_en = 4'b0000;	//选择寄存器存储数据
				alu_in_sel = 1'b0;
				alu_func = 4'b0000;
			end
			Decode: 
			// 译码时什么操作都不做
			begin
				en_fetch = 1'b0;
				en_rf = 1'b0;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 4'b0000;
			end
			Execute_Movel:	//将立即数赋值给Rd指向的寄存器
		   //执行move时并没有读取寄存器中的数据，思考为什么要置en_rf为1？
			//
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1; 
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;	//输出offset
				alu_func = 4'b0000;	//直接输出
			end
			Execute_Move2:	//将Rs指向的寄存器存入Rd
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;	//输出Rs
				alu_func = 4'b0000;
			end
			Execute_Add1:	//立即数与Rd相加
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;	//输出offset
				alu_func = 4'b0001;	//加法运算
			end
			Execute_Add2:	//Rs中的值与Rd相加
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;	//输出Rs
				alu_func = 4'b0001;	//加法运算
			end
			Execute_Sub:	//Rd-Rs存入Rd
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;	//输出Rs
				alu_func = 4'b0010;	//减法
			end
			Execute_And:	//Rd & Rs存入Rd
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;	//输出Rs
				alu_func = 4'b0011;	//&
			end
			Execute_Or:	//Rd | Rs存入Rd
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;	//输出Rs
				alu_func = 4'b0100;	//|
			end
			Execute_Jump: 
			// 为什么jump指令的en_rf和en_pc的状态跟别的相反
			//jump不需要调用寄存器了
			begin
				en_fetch = 1'b0;
				en_rf = 1'b0;
				en_pc = 1'b1;
				pc_ctrl = 2'b10;	//取offset_addr
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;	//输出offset
				alu_func = 4'b0000;
			end
			Execute_Leftshift: 
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;	//输出Rs
				alu_func = 4'b0101;	//左移
			end
			Execute_Rightshift:
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;	//输出Rs
				alu_func = 4'b0110;	//右移
			end
			Execute_Ringshift:
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;	//输出Rs
				alu_func = 4'b1001;	//Ring shift
			end
			Execute_MUL:
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;	//输出Rs
				alu_func = 4'b0111;	//乘法
			end
			Execute_CMP1:
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;	//输出Rs
				alu_func = 4'b1000;	//比较
			end
			Execute_CMP2:
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;	//输出offset
				alu_func = 4'b1000;	//比较
			end
			Execute_XOR1:
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b1;	//输出Rs
				alu_func = 4'b1010;	//异或
			end
			Execute_XOR2:
			begin
				en_fetch = 1'b0;
				en_rf = 1'b1;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;	//输出offset
				alu_func = 4'b1010;	//比较
			end
			Write_back:
		   // 回写是将运算结果存入寄存器，该状态需要设置的参数只有reg_en	
			begin
				case(rd)
					2'b00: reg_en = 4'b0001;
					2'b01: reg_en = 4'b0010;
					2'b10: reg_en = 4'b0100;
					2'b11: reg_en = 4'b1000;
					default: reg_en = 4'b0000;
				endcase
			end
			default: 
			begin
				en_fetch = 1'b0;
				en_rf = 1'b0;
				en_pc = 1'b0;
				pc_ctrl = 2'b00;
				reg_en = 4'b0000;
				alu_in_sel = 1'b0;
				alu_func = 4'b0000;
			end
		endcase
	end
end

// 下面时通过上升沿检测器来产生en_fetch_pulse，en_pc_pulse和en_rf_pulse，这些信号时各模块的输入使能
always @ (posedge clk or negedge rst) 
begin
	if(!rst) 
	begin
		en_fetch_reg <= 1'b0;
		en_pc_reg <= 1'b0;
		en_rf_reg <= 1'b0;
	end
	else 
	begin
		en_fetch_reg <= en_fetch;
		en_pc_reg <= en_pc;
		en_rf_reg <= en_rf;
	end
end
// 虽然en_fetch_pulse等信号是在这里产生的，但是在什么时候产生完全是在执行next_state是产生的
always @ (en_fetch or en_fetch_reg)
	en_fetch_pulse = en_fetch & (~en_fetch_reg);
	
always @ (en_pc_reg or en_pc)
	en_pc_pulse = en_pc & (~en_pc_reg);
	
always @ (en_rf_reg or en_rf)
	en_rf_pulse = en_rf & (~en_rf_reg);

endmodule