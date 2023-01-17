

module mux4(in0,in1,in2,in3,select,out);
	input[1:0] select;
	input[31:0] in0,in1,in2,in3;
	output[31:0] out;

	wire[31:0] w0,w1;

	mux2 top(.in0(in0),.in1(in1),.select(select[0]),.out(w0));
	mux2 bottom(.in0(in2),.in1(in3),.select(select[0]),.out(w1));
	//position 1 is more significant
	mux2 final(.in0(w0),.in1(w1),.select(select[1]),.out(out));

endmodule