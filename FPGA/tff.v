module tff(clock,Q,T,clr);
	input clock,T,clr;
	output Q;
	wire w1,w2,w3,d;
	and AND1(w1,~T,Q);
	and AND2(w2,T,~Q);
	or OR1(d,w1,w2);
	dffe_ref dff(.clk(clock),.d(d),.out(Q),.in_en(1'b1),.out_en(1'b1),.clr(clr));
endmodule