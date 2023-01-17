module CLA(A,B,C0,S,C32,g,p);
	input[31:0] A,B;
	input C0;
	output[31:0] S,g,p;
	output C32;

	wire C8,C16,C24;
	wire G0,P0,G1,P1,G2,P2,G3,P3;

	eight_bit_cell zero2seven(.A(A[7:0]),.B(B[7:0]),.Cin(C0),.G(G0),.P(P0),.S(S[7:0]),.g(g[7:0]),.p(p[7:0]));
	eight_bit_cell eight2fifteen(.A(A[15:8]),.B(B[15:8]),.Cin(C8),.G(G1),.P(P1),.S(S[15:8]),.g(g[15:8]),.p(p[15:8]));
	eight_bit_cell sixteen2twentythree(.A(A[23:16]),.B(B[23:16]),.Cin(C16),.G(G2),.P(P2),.S(S[23:16]),.g(g[23:16]),.p(p[23:16]));
	eight_bit_cell twentyfour2thirtyone(.A(A[31:24]),.B(B[31:24]),.Cin(C24),.G(G3),.P(P3),.S(S[31:24]),.g(g[31:24]),.p(p[31:24]));

	//calculate carries
	//c8
	wire wc8and1;
	and C8and1(wc8and1,P0,C0);
	or C_8(C8,G0,wc8and1);

	//c16
	wire wc16and1,wc16and2;
	and C16and1(wc16and1,P1,G0);
	and C16and2(wc16and2,P1,P0,C0);
	or C_16(C16,G1,wc16and1,wc16and2);

	//c24
	wire wc24and1,wc24and2,wc24and3;
	and C24and1(wc24and1,P2,G1);
	and C24and2(wc24and2,P2,P1,G0);
	and C24and3(wc24and3,P2,P1,P0,C0);
	or C_24(C24,G2,wc24and1,wc24and2,wc24and3);

	//c32
	wire wc32and1,wc32and2,wc32and3,wc32and4;
	and C32and1(wc32and1,P3,G2);
	and C32and2(wc32and2,P3,P2,G1);
	and C32and3(wc32and3,P3,P2,P1,G0);
	and C32and4(wc32and4,P3,P2,P1,P0,C0);
	or C_32(C32,G3,wc32and1,wc32and2,wc32and3,wc32and4);

endmodule