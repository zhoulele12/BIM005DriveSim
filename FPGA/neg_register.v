module neg_register (clk,out,d,in_en,out_en,clr);
	input[31:0] d;
	input in_en,out_en,clr,clk;
	
	output[31:0] out;

	genvar i;
	generate
		//try without loop1
		for(i=0;i<32;i=i+1) begin
			neg_dffe_ref dff(.out(out[i]),.d(d[i]),.clk(clk),.in_en(in_en),.out_en(out_en),.clr(clr));
		end
	endgenerate

endmodule