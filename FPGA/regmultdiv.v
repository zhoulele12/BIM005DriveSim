module regmultdiv (clock,out,d,in_en,out_en,clr,init);
	//65 bits
	input[64:0] d,init;
	input in_en,out_en,clr,clock;
	
	output[64:0] out;

	genvar i;
	generate
		for(i=0;i<65;i=i+1) begin
			multDFF dff(.out(out[i]),.d(d[i]),.clock(clock),.in_en(in_en),.out_en(out_en),.clr(clr),.init(init[i]));
		end
	endgenerate

endmodule