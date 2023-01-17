module right_shift_1 (shift_flag,right_s_result,operand);
	input[31:0] operand;
	input shift_flag;
	output[31:0] right_s_result;

	wire[31:0] shifted;
	assign shifted[30:0] = operand[31:1];
	assign shifted[31] = operand[31];

	assign right_s_result = shift_flag ? shifted:operand;


endmodule