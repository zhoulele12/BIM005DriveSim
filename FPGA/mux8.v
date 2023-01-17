
module mux8(in0,in1,in2,in3,in4,in5,in6,in7,select,out);
	input[2:0] select;
	input[31:0] in0,in1,in2,in3,in4,in5,in6,in7;
	output[31:0] out;

	wire[31:0] w0,w1;

	mux4 top(.in0(in0),.in1(in1),.in2(in2),.in3(in3),.select(select[1:0]),.out(w0));
	mux4 bottom(.in0(in4),.in1(in5),.in2(in6),.in3(in7),.select(select[1:0]),.out(w1));
	mux2 final(.in0(w0),.in1(w1),.select(select[2]),.out(out));

endmodule