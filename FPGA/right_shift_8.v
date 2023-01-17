module right_shift_8 (shift_flag,right_s_result,operand);
	input[31:0] operand;
	input shift_flag;
	output[31:0] right_s_result;

	wire[31:0] shifted;
	assign shifted[23:0] = operand[31:8];
	assign shifted[31:24] = operand[31] ? 8'b11111111 : 8'b00000000;

	assign right_s_result = shift_flag ? shifted:operand;	


endmodule