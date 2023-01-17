`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module iclk_gen(
input clk100mhz,
output clk_4mhz
    );
reg[4:0] counter = 5'b0;
reg clk_reg = 1'b1;

always @(posedge clk100mhz) begin
    if(counter == 12)
        clk_reg <= ~clk_reg;
       if (counter == 24) begin
            clk_reg <= ~clk_reg;
            counter <= 5'b0;
        end
       else
       counter<= counter+1;
     end
     assign clk_4mhz=clk_reg;


endmodule
