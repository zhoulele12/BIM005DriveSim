module dffe_ref_multdiv (out,d,clk,in_en,out_en,clr);
   
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
   always @(posedge clk) begin
        if (in_en) begin
           q <= d;
       end
   end
   always @(negedge clk) begin
        if (clr) begin
            q <= 1'b0;
        end
    end
endmodule