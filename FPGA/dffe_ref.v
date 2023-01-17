module dffe_ref (out,d,clk,in_en,out_en,clr);
   
   //Inputs
   input d, clk, in_en, out_en, clr;
   
   //Output
   output out;
   //tri-state buffer. two outs, one for each read port;
   assign out = out_en ? q:1'bz;

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