/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB,                   // I: Data from port B of RegFile
    );

    // Control signals
    input clock, reset;
    
    // Imem
    //programming counter
    output [31:0] address_imem;
    //instruction to be decoded
    input [31:0] q_imem;

    // Dmem
    output [31:0] address_dmem, data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
    wire[31:0] PC,PCp1,PCin,PCjump,FD_PC_out,FD_IR_in,FD_IR_out,DX_PC_out,DX_IR_out,DX_A_out,DX_B_out,XM_IR_in,XM_A_in,XM_A_out,XM_B_out,XM_IR_out,MW_A_out,MW_B_out,MW_IR_out;
    wire stall;
    CLA PCadder(.A(PC),.B(32'b1),.C0(1'b0),.S(PCp1),.C32(),.g(),.p());
    //stall logic
    wire lw_stall;
    assign PCjump[31:27] = PC[31:27];
    assign PCjump[26:0] = FD_IR_out[26:0];
    assign PCin = jal_fd_flag?jalPC:(jr_dx_flag?ALU_B_in:(branchTaken?branchSum:(bex_jump_flag?bexPC:(jump_flag ? PCjump:PCp1))));
    //flush two stages of instructions

    register ProgramCounter(.clk(clock),.out(PC),.d(PCin),.in_en(~stall),.out_en(1'b1),.clr(reset));
    assign address_imem = PC;
    //clear datapath signals?
    //
    wire flush_FD;
    assign FD_IR_in = flush_FD?nop:q_imem;
    assign flush_FD = jump_flag|branchTaken|bex_jump_flag|jr_dx_flag|jal_fd_flag|jr_fd_flag;
    //PC goes in cuz PC +1 is actually PC+2
    pipeline_latch FD(.clk(clock),.PC_in(PC),.A_in(),.B_in(),.IR_in(FD_IR_in),.PC_out(FD_PC_out),.A_out(),.B_out(),.IR_out(FD_IR_out),.clr(reset),.in_en(~stall));
    wire[31:0] nop;
    assign nop = 32'b0;
    wire FD_multdiv_flag,DX_multdiv_flag;
    assign lw_stall = DX_IR_out[31:27] === 5'b01000 & (FD_IR_out[21:17] === DX_IR_out[26:22] | (FD_IR_out[16:12]===DX_IR_out[26:22] & FD_IR_out[31:27] === 5'b00111));
    
    // assign FD_multdiv_flag = FD_IR_out[31:27] === 5'b00000 & (FD_IR_out[6:2] === 5'b00110 | FD_IR_out[6:2] === 5'b00111);
    assign DX_multdiv_flag = DX_IR_out[31:27] === 5'b00000 & (DX_IR_out[6:2] === 5'b00110 | DX_IR_out[6:2] === 5'b00111);
    assign stall = lw_stall | multdiv_is_running | DX_multdiv_flag;
    wire R_flag,I_flag,sw_fd_flag,bne_fd_flag,blt_fd_flag,bex_fd_flag,jr_fd_flag,jal_fd_flag;
    //what sure reading from FD latch?
    assign sw_fd_flag = FD_IR_out[31:27] === 5'b00111;
    assign bne_fd_flag = FD_IR_out[31:27] === 5'b00010;
    assign blt_fd_flag = FD_IR_out[31:27] === 5'b00110;
    assign bex_fd_flag = FD_IR_out[31:27] === 5'b10110;
    assign jr_fd_flag = FD_IR_out[31:27] === 5'b00100;
    assign jal_fd_flag = FD_IR_out[31:27] === 5'b00011;

    assign ctrl_readRegA = bex_fd_flag?5'b11110:FD_IR_out[21:17];
    assign ctrl_readRegB = bex_fd_flag?5'b0:((sw_fd_flag|bne_fd_flag|blt_fd_flag|jr_fd_flag)?FD_IR_out[26:22]:FD_IR_out[16:12]);

    wire jump_flag;

    assign jump_flag = FD_IR_out[31:27] === 5'b00001 & ~(bex_dx_flag | blt_dx_flag | bne_dx_flag);

    wire[31:0] jalPC;
    assign jalPC[31:27] = FD_PC_out[31:27];
    assign jalPC[26:0] = FD_IR_out[26:0];

    wire[31:0] DX_IR_in;
    // stall on mult div?
    wire flush_DX;
    assign flush_DX = stall|jump_flag|branchTaken|bex_jump_flag|jr_dx_flag;
    assign DX_IR_in = flush_DX?nop:FD_IR_out;

    //careful with regfile write enable
    pipeline_latch DX(.clk(clock),.PC_in(FD_PC_out),.A_in(data_readRegA),.B_in(data_readRegB),.IR_in(DX_IR_in),.PC_out(DX_PC_out),.A_out(DX_A_out),.B_out(DX_B_out),.IR_out(DX_IR_out),.clr(reset),.in_en(1'b1));
    
    wire[31:0] ALU_A_in,ALU_B_in,ALU_im_in,ALU_out;

    assign R_flag = DX_IR_out[31:27]===5'b00000;
    assign I_flag = DX_IR_out[31:27]===5'b00101 | DX_IR_out[31:27]===5'b00111 | DX_IR_out[31:27]===5'b01000 | DX_IR_out[31:27]===5'b00010 | DX_IR_out[31:27]===5'b00110;
    

    //sign extend
    assign ALU_im_in[16:0] = DX_IR_out[16:0];
    assign ALU_im_in[31:17] = DX_IR_out[16]?15'b111111111111111:15'b0;
    // use R flag or I flag to choose?
    assign ALU_B_in = (R_flag | bne_dx_flag |blt_dx_flag|bex_dx_flag|jr_dx_flag) ? ALU_B_bypass:ALU_im_in;
    wire [4:0] ALU_opcode = R_flag ? DX_IR_out[6:2]:5'b00000;

    //bypass ALUinA
    wire[1:0] select_ALUinA;
    // rd register in sw is not written
    //is I/J flag necessary?
    assign select_ALUinA[1] = DX_IR_out[21:17] == MW_IR_out[26:22] & ~sw_mw_flag & MW_IR_out[26:22]!=5'b00000 & ~bex_dx_flag | (bex_dx_flag&setx_mw_flag);
    assign select_ALUinA[0] = (DX_IR_out[21:17] == XM_IR_out[26:22] & ~sw_xm_flag & XM_IR_out[26:22]!=5'b00000 & ~bex_dx_flag) | (bex_dx_flag&setx_xm_flag);

    mux4 ALUinA(.in0(DX_A_out),.in1(XM_A_out),.in2(data_writeReg),.in3(XM_A_out),.select(select_ALUinA),.out(ALU_A_in));

    //bypass ALUinB
    wire[1:0] select_ALUinB;
    assign select_ALUinB[1] = (DX_IR_out[16:12] == MW_IR_out[26:22] & R_flag & ~blt_mw_flag) | ((ctrl_writeReg == DX_IR_out[26:22]) & (jr_dx_flag|blt_dx_flag|bne_dx_flag));
    assign select_ALUinB[0] = (DX_IR_out[16:12] == XM_IR_out[26:22] & R_flag & ~blt_xm_flag) | ((XM_IR_out[26:22] == DX_IR_out[26:22]) & (jr_dx_flag|blt_dx_flag|bne_dx_flag));

    wire[31:0] ALU_B_bypass;
    mux4 ALUinB(.in0(DX_B_out),.in1(XM_A_out),.in2(data_writeReg),.in3(DX_B_out),.select(select_ALUinB),.out(ALU_B_bypass));

    //when overflow happens, dont write to that reg.
    //bypass for r_status.
    wire overflow_flag;
    //17 bit immediate for instruction writing
    wire[31:0] R_r_status,data_r_status;
    mux8 muxRstatus(.in0(1),.in1(3),.in2(),.in3(),.in4(),.in5(),.in6(4),.in7(5),.select(ALU_opcode[2:0]),.out(R_r_status));

    assign data_r_status = R_flag?R_r_status:2;

    wire[31:0] exception_instruction;
    assign exception_instruction[31:27] = 5'b00101;
    assign exception_instruction[26:22] = 5'b11110;
    assign exception_instruction[21:17] = 5'b00000;
    assign exception_instruction[16:0] = data_r_status[16:0];

    wire bne_dx_flag,blt_dx_flag,bex_dx_flag,jr_dx_flag;
    assign bne_dx_flag = DX_IR_out[31:27] === 5'b00010;
    assign blt_dx_flag = DX_IR_out[31:27] === 5'b00110;
    assign bex_dx_flag = DX_IR_out[31:27] === 5'b10110;
    assign jr_dx_flag = DX_IR_out[31:27] === 5'b00100;

    wire[31:0] branchSum;
    CLA branchAdder(.A(DX_PC_out),.B(ALU_im_in),.C0(1'b0),.S(branchSum),.C32(),.g(),.p());

    wire ALU_notEqual,ALU_lessThan,branchTaken,bex_jump_flag;
    alu main_ALU(.data_operandA(ALU_A_in), .data_operandB(ALU_B_in), .ctrl_ALUopcode(ALU_opcode), .ctrl_shiftamt(DX_IR_out[11:7]), .data_result(ALU_out), .isNotEqual(ALU_notEqual), .isLessThan(ALU_lessThan), .overflow(overflow_flag));
    // here A and B are flipped, so not less than and not equal means more than
    assign branchTaken = (ALU_notEqual&bne_dx_flag) | (ALU_notEqual&(~ALU_lessThan)&blt_dx_flag);
    assign bex_jump_flag = ALU_notEqual & bex_dx_flag;

    wire[31:0] bexPC;
    assign bexPC[31:27] = DX_PC_out[31:27];
    assign bexPC[26:0] = DX_IR_out[26:0];

    wire multdiv_start, multdiv_ready,multdiv_exception,multdiv_is_running;
    wire[31:0] multdiv_result;
    assign multdiv_start = DX_IR_out[31:27] === 5'b00000 & (ALU_opcode === 5'b00110 | ALU_opcode === 5'b00111);
    dffe_ref_multdiv multdivRunning(.out(multdiv_is_running),.d(1'b1),.clk(clock),.in_en(multdiv_start),.out_en(1'b1),.clr(multdiv_ready));
    // set to 1 on posedge, reset on posedge too (ready)
    wire choose_multdiv;
    neg_dffe_ref multdivWrite(.out(choose_multdiv),.d(multdiv_ready&multdiv_is_running),.clk(clock),.in_en(1'b1),.out_en(1'b1),.clr(1'b0));
    multdiv MultDiv(.data_operandA(ALU_A_in), .data_operandB(ALU_B_in), .ctrl_MULT(multdiv_start & ALU_opcode === 5'b00110), .ctrl_DIV(multdiv_start & ALU_opcode === 5'b00111), .clock(clock), .data_result(multdiv_result), .data_exception(multdiv_exception), .data_resultRDY(multdiv_ready));

    wire[31:0] PW_P_out,PW_IR_out,XM_PC_out;
    multdiv_latch PW(.clk(clock),.P_in(multdiv_result),.IR_in(DX_IR_out),.P_out(PW_P_out),.IR_out(PW_IR_out),.clr(reset),.in_en_P(multdiv_is_running&multdiv_ready),.in_en_IR((multdiv_is_running&multdiv_start)));
    //A_in is ALU_out
    assign XM_IR_in = overflow_flag?exception_instruction:DX_IR_out;
    assign XM_A_in = overflow_flag?data_r_status:ALU_out;
    pipeline_latch XM(.clk(clock),.PC_in(DX_PC_out),.A_in(XM_A_in),.B_in(DX_B_out),.IR_in(XM_IR_in),.PC_out(XM_PC_out),.A_out(XM_A_out),.B_out(XM_B_out),.IR_out(XM_IR_out),.clr(reset),.in_en(1'b1));

    assign address_dmem = XM_A_out;
    
    wire sw_xm_flag,lw_xm_flag,jal_xm_flag,blt_xm_flag,setx_xm_flag;
    //sw reads rd and rs
    assign lw_xm_flag = XM_IR_out[31:27] === 5'b01000;
    assign sw_xm_flag = XM_IR_out[31:27] === 5'b00111;
    assign jal_xm_flag = XM_IR_out[31:27] === 5'b00011;
    assign blt_xm_flag = XM_IR_out[31:27] === 5'b00110;
    assign setx_xm_flag = XM_IR_out[31:27] === 5'b10101;
    //only write to data mem for sw
    assign wren = sw_xm_flag;

    //B_in is datamem out
    wire[31:0] MW_PC_out;
    pipeline_latch MW(.clk(clock),.PC_in(XM_PC_out),.A_in(XM_A_out),.B_in(q_dmem),.IR_in(XM_IR_out),.PC_out(MW_PC_out),.A_out(MW_A_out),.B_out(MW_B_out),.IR_out(MW_IR_out),.clr(reset),.in_en(1'b1));

    wire sw_mw_flag,lw_mw_flag,setx_mw_flag, jal_mw_flag,blt_mw_flag;
    assign lw_mw_flag = MW_IR_out[31:27] === 5'b01000;
    assign sw_mw_flag = MW_IR_out[31:27] === 5'b00111;
    assign setx_mw_flag = MW_IR_out[31:27] === 5'b10101;
    assign jal_mw_flag = MW_IR_out[31:27] === 5'b00011;
    assign blt_mw_flag = MW_IR_out[31:27] === 5'b00110;

    assign ctrl_writeEnable = (((~sw_mw_flag & MW_IR_out[26:22]!=5'b00000) | choose_multdiv) & MW_IR_out[31:27]!=5'b00010 & MW_IR_out[31:27]!=5'b00110 & MW_IR_out[31:27]!=5'b10110 & MW_IR_out[31:27]!=5'b00100 & ~( (MW_IR_out[31:27]===5'b00000) & (MW_IR_out[6:2]===5'b00110 | MW_IR_out[6:2]===5'b00111) ) ) | setx_mw_flag | jal_mw_flag;
//     assign ctrl_writeEnable = (((~sw_mw_flag & MW_IR_out[26:22]!=5'b00000) | choose_multdiv) & MW_IR_out[31:27]!=5'b00010 & MW_IR_out[31:27]!=5'b00110 & MW_IR_out[31:27]!=5'b10110 & MW_IR_out[31:27]!=5'b00100) | setx_mw_flag | jal_mw_flag;
    //bypass dmem_in
    wire select_d_mem;
    assign select_d_mem = MW_IR_out[26:22] == XM_IR_out[26:22] & sw_xm_flag & ~sw_mw_flag;
    assign data = select_d_mem?data_writeReg:XM_B_out;

    //only lw chooses MW_B_out
    wire[31:0] setx_Rstatus;

    assign setx_Rstatus[26:0] = MW_IR_out[26:0];
    assign setx_Rstatus[31:27] = 5'b0;
    assign data_writeReg = jal_mw_flag?MW_PC_out:(setx_mw_flag?setx_Rstatus:(choose_multdiv?PW_P_out:(MW_IR_out[30]?MW_B_out:MW_A_out)));

    // or assign data_writeReg = lw_flag?MW_B_out:MW_A_out;
    assign ctrl_writeReg = jal_mw_flag?5'b11111:(setx_mw_flag?5'b11110:(choose_multdiv?PW_IR_out[26:22]:MW_IR_out[26:22]));
    /* END CODE */

endmodule
