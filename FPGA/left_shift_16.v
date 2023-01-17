module left_shift_16 (shift_flag,left_s_result,operand);
	input[31:0] operand;
	input shift_flag;
	output[31:0] left_s_result;

	wire[31:0] shifted;
	assign shifted[31:16] = operand[15:0];
	assign shifted[15:0] = 16'b0;

	assign left_s_result = shift_flag ? shifted:operand;	


endmodule