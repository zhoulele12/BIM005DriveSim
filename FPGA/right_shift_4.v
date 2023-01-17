module right_shift_4 (shift_flag,right_s_result,operand);
	input[31:0] operand;
	input shift_flag;
	output[31:0] right_s_result;

	wire[31:0] shifted;
	assign shifted[27:0] = operand[31:4];
	assign shifted[31:28] = operand[31] ? 4'b1111 : 4'b0000;

	assign right_s_result = shift_flag ? shifted : operand;	


endmodule