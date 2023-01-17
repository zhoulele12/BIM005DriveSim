module right_shift_2 (shift_flag,right_s_result,operand);
	input[31:0] operand;
	input shift_flag;
	output[31:0] right_s_result;

	wire[31:0] shifted;
	assign shifted[29:0] = operand[31:2];
	assign shifted[31:30] = operand[31] ? 2'b11 : 2'b00;

	assign right_s_result = shift_flag ? shifted:operand;	


endmodule