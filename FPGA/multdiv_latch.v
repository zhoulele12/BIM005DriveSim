module multdiv_latch (clk,P_in,IR_in,P_out,IR_out,clr,in_en_P,in_en_IR);
	input[31:0] P_in,IR_in;
	input clk,clr,in_en_P,in_en_IR;
	output[31:0] P_out,IR_out;

	neg_register A(.clk(clk),.out(P_out),.d(P_in),.in_en(in_en_P),.out_en(1'b1),.clr(clr));
	neg_register IR(.clk(clk),.out(IR_out),.d(IR_in),.in_en(in_en_IR),.out_en(1'b1),.clr(clr));

endmodule