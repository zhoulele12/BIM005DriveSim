module counter(clock,count,clr);
	input clock,clr;
	output[5:0] count;

	wire q0,q1,q2,q3,q4,q5;

	tff tff0(.clock(clock),.T(1'b1),.Q(q0),.clr(clr));
	tff tff1(.clock(clock),.T(q0),.Q(q1),.clr(clr));
	wire w1,w2,w3,w4;
	and AND1(w1,q0,q1);
	tff tff2(.clock(clock),.T(w1),.Q(q2),.clr(clr));
	and AND2(w2,w1,q2);
	tff tff3(.clock(clock),.T(w2),.Q(q3),.clr(clr));
	and AND3(w3,w2,q3);
	tff tff4(.clock(clock),.T(w3),.Q(q4),.clr(clr));
	and AND4(w4,w3,q4);
	tff tff5(.clock(clock),.T(w4),.Q(q5),.clr(clr));

	assign count = {q5,q4,q3,q2,q1,q0};

endmodule