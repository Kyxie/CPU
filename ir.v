module ir(clk,rst,ins,en_in,en_out,ir_out);
input clk,rst;
input [15:0] ins;
input en_in;
output reg en_out;
output reg [15:0] ir_out;

always @ (posedge clk or negedge rst) begin
	if(!rst) begin	//rst为低有效
	// rst有效时，ir_out=0，en_out=1；
		ir_out <= 16'b000000000000;
		en_out <= 1'b1;
	end
	else begin
		if(en_in) begin
		// en_in有效时，en_out=1,输出指令
			en_out <= 1'b1;
			ir_out <= ins;
		end
		// 输出en_out无效
		else en_out <= 1'b0;
	end
end
endmodule