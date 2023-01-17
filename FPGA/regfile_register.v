module regfile_register (clk,out1,out2,d,in_en,out_en1,out_en2,clr);
	input[31:0] d;
	input in_en,out_en1,out_en2,clr,clk;
	
	output[31:0] out1,out2;

	genvar i;
	generate
		//try without loop1
		for(i=0;i<32;i=i+1) begin
			regfile_dffe_ref dff(.out1(out1[i]),.out2(out2[i]),.d(d[i]),.clk(clk),.in_en(in_en),.out_en1(out_en1),.out_en2(out_en2),.clr(clr));
		end
	endgenerate

endmodule