module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg, data_writeRegAccel,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB, data_readRegAccelA, data_readRegAccelB, data_writeRegGas, data_readRegGas,dataBrakeIn, data_readRegDirection, data_readRegDegree,
	PCprobe,PCregister
);
	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg, data_writeRegAccel, PCprobe, data_writeRegGas, dataBrakeIn;
 
	output [31:0] data_readRegA, data_readRegB, data_readRegAccelA, data_readRegAccelB,PCregister, data_readRegGas, data_readRegDirection, data_readRegDegree;
	
	wire[31:0] out_en1,out_en2;
	assign out_en1 = 1<<ctrl_readRegA;
	assign out_en2 = 1<<ctrl_readRegB;
	wire[31:0] in_en;
	assign in_en = ctrl_writeEnable << ctrl_writeReg;

	regfile_register reg0(.clk(clock),.out1(data_readRegA),.out2(data_readRegB),.d(32'b0),.in_en(in_en[0]),.out_en1(out_en1[0]),.out_en2(out_en2[0]),.clr(ctrl_reset));
	// add your code here
	genvar i;
	generate
		for(i=1;i<23;i=i+1) begin
			regfile_register reg1(.clk(clock),.out1(data_readRegA),.out2(data_readRegB),.d(data_writeReg),.in_en(in_en[i]),.out_en1(out_en1[i]),.out_en2(out_en2[i]),.clr(ctrl_reset));
		end
	endgenerate
	regfile_register r23(.clk(clock), .out1(data_readRegDegree), .out2(data_readRegB), .d(data_writeReg), .in_en(in_en[23]), .out_en1(1'b1), .out_en2(out_en2[23]), .clr(ctrl_reset));
	regfile_register r24(.clk(clock), .out1(data_readRegDirection), .out2(data_readRegB), .d(data_writeReg), .in_en(in_en[24]), .out_en1(1'b1), .out_en2(out_en2[24]), .clr(ctrl_reset));
	regfile_register r25(.clk(clock), .out1(data_readRegA), .out2(data_readRegB), .d(dataBrakeIn), .in_en(1'b1), .out_en1(out_en1[25]), .out_en2(out_en2[25]), .clr(ctrl_reset));
	regfile_register r26(.clk(clock), .out1(data_readRegGas), .out2(data_readRegB), .d(data_writeReg), .in_en(in_en[26]), .out_en1(1'b1), .out_en2(out_en2[26]), .clr(ctrl_reset));
	regfile_register r27(.clk(clock), .out1(data_readRegA), .out2(data_readRegB), .d(data_writeRegGas), .in_en(1'b1), .out_en1(out_en1[27]), .out_en2(out_en2[27]), .clr(ctrl_reset));
	regfile_register r28(.clk(clock), .out1(data_readRegAccelA), .out2(data_readRegB), .d(data_writeReg), .in_en(in_en[28]), .out_en1(1'b1), .out_en2(out_en2[28]), .clr(ctrl_reset));

	regfile_register r_accel(.clk(clock), .out1(data_readRegA), .out2(data_readRegB), .d(data_writeRegAccel), .in_en(1'b1), .out_en1(out_en1[29]), .out_en2(out_en2[29]), .clr(ctrl_reset));
	regfile_register r_status(.clk(clock),.out1(data_readRegA),.out2(data_readRegB),.d(data_writeReg),.in_en(in_en[30]),.out_en1(out_en1[30]),.out_en2(out_en2[30]),.clr(ctrl_reset));
	regfile_register ra(.clk(clock),.out1(data_readRegA),.out2(data_readRegB),.d(data_writeReg),.in_en(in_en[31]),.out_en1(out_en1[31]),.out_en2(out_en2[31]),.clr(ctrl_reset));	


endmodule
