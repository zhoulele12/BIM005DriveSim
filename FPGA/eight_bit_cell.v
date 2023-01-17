module eight_bit_cell(A,B,Cin,G,P,S,g,p);
	input[7:0] A,B;
	input Cin;
	output G,P;
	output[7:0] S;
	
	wire[7:0] c;
	output[7:0] g,p;

	//try for loop
	and AND0(g[0],A[0],B[0]);
	and AND1(g[1],A[1],B[1]);
	and AND2(g[2],A[2],B[2]);
	and AND3(g[3],A[3],B[3]);
	and AND4(g[4],A[4],B[4]);
	and AND5(g[5],A[5],B[5]);
	and AND6(g[6],A[6],B[6]);
	and AND7(g[7],A[7],B[7]);


	or or0(p[0],A[0],B[0]);
	or or1(p[1],A[1],B[1]);
	or or2(p[2],A[2],B[2]);
	or or3(p[3],A[3],B[3]);
	or or4(p[4],A[4],B[4]);
	or or5(p[5],A[5],B[5]);
	or or6(p[6],A[6],B[6]);
	or or7(p[7],A[7],B[7]);

	//seems that verilog allows using output as inside var
	and Pout(P,p[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7]);
	
	wire wg0,wg1,wg2,wg3,wg4,wg5,wg6;
	and Gand0(wg0,g[0],p[1],p[2],p[3],p[4],p[5],p[6],p[7]);
	and Gand1(wg1,g[1],p[2],p[3],p[4],p[5],p[6],p[7]);
	and Gand2(wg2,g[2],p[3],p[4],p[5],p[6],p[7]);
	and Gand3(wg3,g[3],p[4],p[5],p[6],p[7]);
	and Gand4(wg4,g[4],p[5],p[6],p[7]);
	and Gand5(wg5,g[5],p[6],p[7]);
	and Gand6(wg6,g[6],p[7]);

	or Gout(G,wg0,wg1,wg2,wg3,wg4,wg5,wg6,g[7]);

	//calculate carries
	//c1
	wire wc1and1;
	and C1and1(wc1and1,p[0],Cin);
	or C1(c[1],g[0],wc1and1);

	//c2
	wire wc2and1,wc2and2;
	and C2and1(wc2and1,p[1],g[0]);
	and C2and2(wc2and2,p[1],p[0],Cin);
	or C2(c[2],g[1],wc2and1,wc2and2);

	//c3
	wire wc3and1,wc3and2,wc3and3;
	and C3and1(wc3and1,p[2],g[1]);
	and C3and2(wc3and2,p[2],p[1],g[0]);
	and C3and3(wc3and3,p[2],p[1],p[0],Cin);
	or C3(c[3],g[2],wc3and1,wc3and2,wc3and3);

	//c4
	wire wc4and1,wc4and2,wc4and3,wc4and4;
	and C4and1(wc4and1,p[3],g[2]);
	and C4and2(wc4and2,p[3],p[2],g[1]);
	and C4and3(wc4and3,p[3],p[2],p[1],g[0]);
	and C4and4(wc4and4,p[3],p[2],p[1],p[0],Cin);
	or C4(c[4],g[3],wc4and1,wc4and2,wc4and3,wc4and4);

	//c5
	wire wc5and1,wc5and2,wc5and3,wc5and4,wc5and5;
	and C5and1(wc5and1,p[4],g[3]);
	and C5and2(wc5and2,p[4],p[3],g[2]);
	and C5and3(wc5and3,p[4],p[3],p[2],g[1]);
	and C5and4(wc5and4,p[4],p[3],p[2],p[1],g[0]);
	and C5and5(wc5and5,p[4],p[3],p[2],p[1],p[0],Cin);
	or C5(c[5],g[4],wc5and1,wc5and2,wc5and3,wc5and4,wc5and5);

	//c6
	wire wc6and1,wc6and2,wc6and3,wc6and4,wc6and5,wc6and6;
	and C6and1(wc6and1,p[5],g[4]);
	and C6and2(wc6and2,p[5],p[4],g[3]);
	and C6and3(wc6and3,p[5],p[4],p[3],g[2]);
	and C6and4(wc6and4,p[5],p[4],p[3],p[2],g[1]);
	and C6and5(wc6and5,p[5],p[4],p[3],p[2],p[1],g[0]);
	and C6and6(wc6and6,p[5],p[4],p[3],p[2],p[1],p[0],Cin);
	or C6(c[6],g[5],wc6and1,wc6and2,wc6and3,wc6and4,wc6and5,wc6and6);

	//c7
	wire wc7and1,wc7and2,wc7and3,wc7and4,wc7and5,wc7and6,wc7and7;
	and C7and1(wc7and1,p[6],g[5]);
	and C7and2(wc7and2,p[6],p[5],g[4]);
	and C7and3(wc7and3,p[6],p[5],p[4],g[3]);
	and C7and4(wc7and4,p[6],p[5],p[4],p[3],g[2]);
	and C7and5(wc7and5,p[6],p[5],p[4],p[3],p[2],g[1]);
	and C7and6(wc7and6,p[6],p[5],p[4],p[3],p[2],p[1],g[0]);
	and C7and7(wc7and7,p[6],p[5],p[4],p[3],p[2],p[1],p[0],Cin);
	or C7(c[7],g[6],wc7and1,wc7and2,wc7and3,wc7and4,wc7and5,wc7and6,wc7and7); //8-input gate

	//sum
	xor S0(S[0],A[0],B[0],Cin);
	xor S1(S[1],A[1],B[1],c[1]);
	xor S2(S[2],A[2],B[2],c[2]);
	xor S3(S[3],A[3],B[3],c[3]);
	xor S4(S[4],A[4],B[4],c[4]);
	xor S5(S[5],A[5],B[5],c[5]);
	xor S6(S[6],A[6],B[6],c[6]);
	xor S7(S[7],A[7],B[7],c[7]);

endmodule