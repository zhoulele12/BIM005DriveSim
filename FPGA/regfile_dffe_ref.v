module regfile_dffe_ref (out1,out2,d,clk,in_en,out_en1,out_en2,clr);
   
   //Inputs
   input d, clk, in_en, out_en1, out_en2, clr;
   
   //Output
   output out1,out2;
   //tri-state buffer. two outs, one for each read port;
   assign out1 = out_en1 ? q:1'bz;
   assign out2 = out_en2 ? q:1'bz;

   //Register
   reg q;

   //Intialize q to 0
   initial
   begin
       q = 1'b0;
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           q <= 1'b0;
       //If enable is high, set q to the value of d
       end else if (in_en) begin
           q <= d;
       end
   end
endmodule