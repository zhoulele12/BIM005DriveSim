module right_shifter (shift_amt,right_s_result,operand);
	input[31:0] operand;
	input[4:0] shift_amt;
	output[31:0] right_s_result;
	wire[31:0] w1,w2,w3,w4;
	right_shift_16 shift16(.right_s_result(w1),.shift_flag(shift_amt[4]),.operand(operand));
	right_shift_8 shift8(.right_s_result(w2),.shift_flag(shift_amt[3]),.operand(w1));
	right_shift_4 shift4(.right_s_result(w3),.shift_flag(shift_amt[2]),.operand(w2));
	right_shift_2 shift2(.right_s_result(w4),.shift_flag(shift_amt[1]),.operand(w3));
	right_shift_1 shift1(.right_s_result(right_s_result),.shift_flag(shift_amt[0]),.operand(w4));
	
endmodule