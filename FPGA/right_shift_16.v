module right_shift_16 (shift_flag,right_s_result,operand);
	input[31:0] operand;
	input shift_flag;
	output[31:0] right_s_result;

	wire[31:0] shifted;
	assign shifted[15:0] = operand[31:16];
	assign shifted[31:16] = operand[31] ? 16'b1111111111111111:16'b0000000000000000;

	assign right_s_result = shift_flag ? shifted:operand;	


endmodule