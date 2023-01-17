`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (clock, reset, ACL_MISO, ACL_MOSI, ACL_SCLK, ACL_CSN, LED,SEG,DP,AN, JA, JA1, JB, SW);
	input clock, reset, ACL_MISO;
	input [15:0] SW;
	
	output ACL_MOSI, ACL_SCLK, ACL_CSN, DP;
	output[14:0] LED;
	output [4:1] JA;
	output [7:10] JA1;
	input[4:1] JB;
	output[6:0] SEG;
	output[7:0] AN;
   
    wire [31:0] accelData, readAccelDataA, readAccelDataB, fullAccelData, dataGas, outGas, dataBrake, degree;
    wire rwe, mwe, w_4MHz, not_rst;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,direction,
		memAddr, memDataIn, memDataOut;
    wire[14:0] acl_data;
    reg[31:0] counter;
    reg slow_clock = 0;
    assign not_rst = ~reset;
    wire[1:0] gearData;
//    always @(posedge clock) begin
//		if(counter< 4)
//			counter = counter + 1;
//		else begin
//			counter = 0;
//			slow_clock = ~slow_clock;
//		end
//	end
    always @(posedge clock) begin
        slow_clock <= ~slow_clock;
    end
	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "C:/Users/cz169/Downloads/driving-simulator-main/driving-simulator-main/extra_lines";
//	localparam INSTR_FILE = "C:/Users/cz169/Desktop/accel";
	// Main Processing Unit
	processor CPU(.clock(slow_clock), .reset(not_rst), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB), 
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(slow_clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	wire [31:0] PCregister,PCprobe;
	// Register File
	regfile RegisterFile(.clock(slow_clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(not_rst), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), .data_writeRegAccel(fullAccelData), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB), .data_readRegAccelA(readAccelDataA), .data_readRegAccelB(readAccelDataB), .data_readRegDirection(direction),
		.data_readRegGas(outGas), .data_writeRegGas(dataGas), .dataBrakeIn(dataBrake), .data_readRegDegree(degree),
		.PCprobe(PCprobe),.PCregister(PCregister));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(slow_clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));
		
	 iclk_gen clock_generation(
    .clk100mhz(clock),
    .clk_4mhz(w_4MHz)
    );
    
    spi_master master(
    .iclk(w_4MHz),
    .miso(ACL_MISO),
    .sclk(ACL_SCLK),
    .mosi(ACL_MOSI),
    .cs(ACL_CSN),
    .Y(accelData),
    .outData(fullAccelData),
    .acl_data(acl_data)
    );
    
    seg7_control display_control(
    .displayDataA(fullAccelData),
    .displayDataB(outGas),
    .displayDataC(PCregister),
    .clk100mhz(clock),
    .degreeData(degree),
    .directionData(direction),
    .gear(gearData),
    .acl_data(acl_data),
    .seg(SEG),
    .dp(DP),
    .an(AN)
    );
    assign dataBrake[0] = JB[1];
    assign dataGas[0] = gearData[0]? 0 :JB[2];
    assign dataGas[1] = gearData[0] ? 0 : JB[3];
    
    assign JA[1] = readAccelDataA[0];
    assign JA[2] = readAccelDataA[1];
    assign JA[3] = readAccelDataA[2];
    assign JA[4]= readAccelDataA[3];
    assign JA1[7] = readAccelDataA[4];
    assign JA1[8] = readAccelDataA[5];
    
    assign JA1[9] = SW[0];
    assign JA1[10]= SW[1];
    assign gearData[0] = SW[0];
    assign gearData[1] = SW[1];
    
    assign LED[0] = degree[0];
    assign LED[1] = degree[1];
    assign LED[2] = degree[2];
    assign LED[3] = degree[3];
//   ila_1 debug(.clk(w_4MHz), .probe0(regB), .probe1(rData), .probe2(regA), .probe3(PCregister));

endmodule
