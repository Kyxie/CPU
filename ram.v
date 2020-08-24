module ram(clk,rst,addr,en_ram_in,ins,en_ram_out);
input clk,rst;
input [15:0] addr;	//从PC得到的地址
input en_ram_in;
output reg [15:0] ins;	//地址中的指令
output reg en_ram_out;
reg[15:0] ram[16:0];	//创建16个16位寄存器

initial
begin
	//Accumulation:
	//ram[0] = 16'b0000_0000_0000_0001;	//mov r0 #1
	//ram[1] = 16'b0011_0100_0000_0000;	//add r1 r0
	//ram[2] = 16'b0011_1001_0000_0000;	//add r2 r1
	//ram[3] = 16'b0111_0000_0000_0000;	//jump #0

	//Fibonacci:
	ram[0] = 16'b0000_1000_0000_0001;	//mov r2 #1
	ram[1] = 16'b0001_0001_0000_0000;	//mov r0 r1
	ram[2] = 16'b0001_0110_0000_0100;	//add r1 r2
	ram[3] = 16'b0011_1000_0000_0000;	//add r2 r0
	ram[4] = 16'b0111_0000_0000_0001;	//jump #1
	
	//lab 5:
	//ram[0] = 16'b0000_0000_0000_0101;	//mov r0 #5
	//ram[1] = 16'b0000_0100_0000_1010;	//mov r1 #10
	//ram[2] = 16'b1100_0001_0000_0000;	//r0 = XOR(r0,r1)
	//ram[3] = 16'b1101_0100_0000_1111;	//r1 = XOR(r1,1111)
end

always @ (posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	// 初始化ram存储的指令
	begin
		en_ram_out <= 1'b0;
		ins <= 16'b0;
	end
	else
	begin
		if(en_ram_in == 1)
		begin
			en_ram_out <= 1'b1;
			if(addr <= 10)
				ins <= ram[addr];
		   else 
				ins=0;
      end
	   else 
			en_ram_out<=1'b0;
	end
end

endmodule