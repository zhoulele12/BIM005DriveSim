module dff_multdiv(out,mult,div);
   
   //Inputs
   input mult, div;
   
   //Output
   output out;
   //tri-state buffer. two outs, one for each read port;
   assign out = q;

   //Register
   reg q;

   //Intialize q to 0
   initial
   begin
       q = 1'b0;
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge mult or posedge div) begin
       //If clear is high, set q to 0
       if (mult) begin
           q <= 1'b0;
       //If enable is high, set q to the value of d
       end else if (div) begin
           q <= 1'b1;
       end
   end
endmodule