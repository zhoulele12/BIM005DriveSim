module pipeline_latch (clk,PC_in,A_in,B_in,IR_in,PC_out,A_out,B_out,IR_out,clr,in_en);
	input[31:0] PC_in,A_in,B_in,IR_in;
	input clk,clr,in_en;
	output[31:0] PC_out,A_out,B_out,IR_out;

	neg_register PC_latch(.clk(clk),.out(PC_out),.d(PC_in),.in_en(in_en),.out_en(1'b1),.clr(clr));
	neg_register A(.clk(clk),.out(A_out),.d(A_in),.in_en(in_en),.out_en(1'b1),.clr(clr));
	neg_register B(.clk(clk),.out(B_out),.d(B_in),.in_en(in_en),.out_en(1'b1),.clr(clr));
	neg_register IR(.clk(clk),.out(IR_out),.d(IR_in),.in_en(in_en),.out_en(1'b1),.clr(clr));

endmodule