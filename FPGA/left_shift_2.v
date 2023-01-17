module left_shift_2 (shift_flag,left_s_result,operand);
	input[31:0] operand;
	input shift_flag;
	output[31:0] left_s_result;

	wire[31:0] shifted;
	assign shifted[31:2] = operand[29:0];
	assign shifted[1:0] = 2'b0;

	assign left_s_result = shift_flag ? shifted:operand;	


endmodule