module multDFF(out,d,clock,in_en,out_en,clr,init);
   
   //Inputs
   input d, clock, in_en, out_en, clr,init;
   
   //Output
   output out;
   //tri-state buffer. two outs, one for each read port;
   assign out = out_en ? q:1'bz;

   //Register
   reg q;

   //Intialize q to 0
   initial
   begin
       q = init;
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge clock or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           q <= init;
       //If enable is high, set q to the value of d
       end else if (in_en) begin
           q <= d;
       end
   end
endmodule