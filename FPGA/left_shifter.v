module left_shifter (shift_amt,left_s_result,operand);
	input[31:0] operand;
	input[4:0] shift_amt;
	output[31:0] left_s_result;
	wire[31:0] w1,w2,w3,w4;
	left_shift_16 shift16(.left_s_result(w1),.shift_flag(shift_amt[4]),.operand(operand));
	left_shift_8 shift8(.left_s_result(w2),.shift_flag(shift_amt[3]),.operand(w1));
	left_shift_4 shift4(.left_s_result(w3),.shift_flag(shift_amt[2]),.operand(w2));
	left_shift_2 shift2(.left_s_result(w4),.shift_flag(shift_amt[1]),.operand(w3));
	left_shift_1 shift1(.left_s_result(left_s_result),.shift_flag(shift_amt[0]),.operand(w4));
	
endmodule