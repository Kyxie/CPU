module cpu_top(clk,rst,en_in);

input clk,rst,en_in;
wire en_ram_in,en_ram_out;
wire [15:0]ins,addr;

cpu cpu1(
	.clk(clk),
	.en_ram_out(en_ram_out),
	.rst(rst),
	.ins(ins),
	.en_in(en_in),
	.en_ram_in(en_ram_in),
	.addr(addr)
);

ram ram1(
	.clk(clk),
	.rst(rst),
	.addr(addr),
	.en_ram_in(en_ram_in),
	.ins(ins),
	.en_ram_out(en_ram_out)
);

endmodule