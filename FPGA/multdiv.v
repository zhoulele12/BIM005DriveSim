module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock,
	data_result, data_exception, data_resultRDY
    );

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;
    wire[31:0] operandA_in,operandB_in,operandA_out,operandB_out;
    wire latch_operands;
    assign latch_operands = ctrl_MULT|ctrl_DIV;
    //remember to latch multdiv operands!
    register aReg(.clk(clock),.out(operandA_out),.d(data_operandA),.in_en(latch_operands),.out_en(1'b1),.clr(1'b0));
    register bReg(.clk(clock),.out(operandB_out),.d(data_operandB),.in_en(latch_operands),.out_en(1'b1),.clr(1'b0));


    wire[31:0] neg_operandA,neg_operandB;
    CLA adder_A(.A(~operandA_out),.B(32'b1),.C0(1'b0),.S(neg_operandA));
    CLA adder_B(.A(~operandB_out),.B(32'b1),.C0(1'b0),.S(neg_operandB));

    wire[64:0] regIn,regOut,regInit,regInShifted;
    assign regInit[64:33] = zeros;
    assign regInit[32:1] = data_operandB;
    assign regInit[0] = 1'b0;

    wire[31:0] muxOut,adderOut,candShifted,candShiftedNeg,candNeg,zeros;
    assign candNeg = ~operandA_out;
    assign candShifted = operandA_out<<1;
    assign candShiftedNeg = ~candShifted;
    assign zeros = 32'b0;
    wire clr;
    or clear(clr,ctrl_MULT,ctrl_DIV);

    regmultdiv product(.clock(clock),.out(regOut),.d(regInShifted),.in_en(1'b1),.out_en(1'b1),.clr(clr),.init(regInit));
    wire w_status;
    //0 for mult 1 for div
    dff_multdiv status(.out(w_status),.mult(ctrl_MULT),.div(ctrl_DIV));

    mux8 chooseOperand(.select(regOut[2:0]),.out(muxOut),.in0(zeros),.in1(operandA_out),.in2(operandA_out),.in3(candShifted),.in4(candShiftedNeg),.in5(candNeg),.in6(candNeg),.in7(~zeros));
    CLA adder(.A(muxOut),.B(regOut[64:33]),.C0(regOut[2]),.S(adderOut));
    assign regIn[64:33] = adderOut;
    assign regIn[32:0] = regOut[32:0];
    //shift regIn by 2, do this 16 times
    assign regInShifted[64] = regIn[64];
    assign regInShifted[63] = regIn[64];
    assign regInShifted[62:31] = regIn[64:33];
    assign regInShifted[30:0] = regIn[32:2];

    wire[5:0] count;

    counter COUNTER(.clock(clock),.count(count),.clr(clr));

    wire w_mult_finish,w_div_finish,w_divzero,w_assert_mult,w_assert_div;
    //mult finishes when counter reaches 16
    and mult_finish(w_mult_finish,~count[5],count[4],~count[3],~count[2],~count[1],~count[0]);
    and assert_mult(w_assert_mult,w_mult_finish,~w_status);
    and div_finish(w_div_finish,count[5],~count[4],~count[3],~count[2],~count[1],~count[0]);
    and assert_div(w_assert_div,w_div_finish,w_status);
    or ready(data_resultRDY,w_assert_mult,w_assert_div);

    //mult overflow
    wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w_all_one,w_all_zero,w_sig;
    and AND1(w1,~data_result[31],~operandA_out[31],operandB_out[31]);
    and AND2(w2,~data_result[31],operandA_out[31],~operandB_out[31]);
    and AND3(w3,data_result[31],~operandA_out[31],~operandB_out[31]);
    and AND4(w4,data_result[31],operandA_out[31],operandB_out[31]);
    and AND5(w10,w5,w6,~w9);
    //significant bit in first 32 bit of regOut
    and allOne(w_all_one,regOut[32],regOut[33],regOut[34],regOut[35],regOut[36],regOut[37],regOut[38],regOut[39],regOut[40],regOut[41],regOut[42],regOut[43],regOut[44],regOut[45],regOut[46],regOut[47],regOut[48],regOut[49],regOut[50],regOut[51],regOut[52],regOut[53],regOut[54],regOut[55],regOut[56],regOut[57],regOut[58],regOut[59],regOut[60],regOut[61],regOut[62],regOut[63],regOut[64]);
    nor allZero(w_all_zero,regOut[32],regOut[33],regOut[34],regOut[35],regOut[36],regOut[37],regOut[38],regOut[39],regOut[40],regOut[41],regOut[42],regOut[43],regOut[44],regOut[45],regOut[46],regOut[47],regOut[48],regOut[49],regOut[50],regOut[51],regOut[52],regOut[53],regOut[54],regOut[55],regOut[56],regOut[57],regOut[58],regOut[59],regOut[60],regOut[61],regOut[62],regOut[63],regOut[64]);
    nor sig(w_sig,w_all_one,w_all_zero);

    or CANDN0(w5,operandA_out[0],operandA_out[1],operandA_out[2],operandA_out[3],operandA_out[4],operandA_out[5],operandA_out[6],operandA_out[7],operandA_out[8],operandA_out[9],operandA_out[10],operandA_out[11],operandA_out[12],operandA_out[13],operandA_out[14],operandA_out[15],operandA_out[16],operandA_out[17],operandA_out[18],operandA_out[19],operandA_out[20],operandA_out[21],operandA_out[22],operandA_out[23],operandA_out[24],operandA_out[25],operandA_out[26],operandA_out[27],operandA_out[28],operandA_out[29],operandA_out[30],operandA_out[31]);
    or ERN0(w6,operandB_out[0],operandB_out[1],operandB_out[2],operandB_out[3],operandB_out[4],operandB_out[5],operandB_out[6],operandB_out[7],operandB_out[8],operandB_out[9],operandB_out[10],operandB_out[11],operandB_out[12],operandB_out[13],operandB_out[14],operandB_out[15],operandB_out[16],operandB_out[17],operandB_out[18],operandB_out[19],operandB_out[20],operandB_out[21],operandB_out[22],operandB_out[23],operandB_out[24],operandB_out[25],operandB_out[26],operandB_out[27],operandB_out[28],operandB_out[29],operandB_out[30],operandB_out[31]);
    or resultN0(w9,data_result[0],data_result[1],data_result[2],data_result[3],data_result[4],data_result[5],data_result[6],data_result[7],data_result[8],data_result[9],data_result[10],data_result[11],data_result[12],data_result[13],data_result[14],data_result[15],data_result[16],data_result[17],data_result[18],data_result[19],data_result[20],data_result[21],data_result[22],data_result[23],data_result[24],data_result[25],data_result[26],data_result[27],data_result[28],data_result[29],data_result[30],data_result[31]);
    or multOver(w7,w1,w2,w3,w4,w10,w_sig);
    wire w_overflow,w_mult_except,w_div_except;
    and OVERFLOW(w_overflow,w7,w5,w6);
    //division by zero
    and DIVZERO(w_divzero,~w6,w_status);
    and multExcept(w_mult_except,~w_status,w_overflow);
    and divExcept(w_div_except,w_status,w_divzero);
    or EXCEPTION(data_exception,w_mult_except,w_div_except);

    //div
    //division with neg dividend or divisor -> need to flip
    wire[31:0] dividend,divisor;
    assign dividend = operandA_out[31]?neg_operandA:operandA_out;
    assign divisor = operandB_out[31]?neg_operandB:operandB_out;
    
    wire[31:0] neg_operandA_init,A_init;
    CLA adderAinit(.A(~data_operandA),.B(32'b1),.C0(1'b0),.S(neg_operandA_init));
    assign A_init = data_operandA[31]?neg_operandA_init:data_operandA;
    wire[64:0] div_regIn,div_regOut,div_regInit,div_regOutShifted;
    assign div_regInit[64:33] = zeros;
    assign div_regInit[32:1] = A_init;
    assign div_regInit[0] = 1'b0;

    regmultdiv quotient(.clock(clock),.out(div_regOut),.d(div_regIn),.in_en(1'b1),.out_en(1'b1),.clr(clr),.init(div_regInit));
    assign div_regOutShifted = div_regOut<<1;
    
    wire[31:0] div_muxOut,div_adderOut,div_out_flipped,div_result;
    assign div_muxOut = div_regOut[64]?divisor:~divisor;
    CLA div_adder(.A(div_muxOut),.B(div_regOutShifted[64:33]),.C0(~div_regOut[64]),.S(div_adderOut));
    assign div_regIn[64:33] = div_adderOut;
    assign div_regIn[1] = ~div_adderOut[31];
    assign div_regIn[32:2] = div_regOutShifted[32:2];
    assign div_regIn[0] = 1'b0;
    wire flip;
    xor flipOrNot(flip,operandA_out[31],operandB_out[31]);
    CLA adder_result(.A(~div_regOut[32:1]),.B(32'b1),.C0(1'b0),.S(div_out_flipped));
    
    assign div_result = flip?div_out_flipped:div_regOut[32:1];
    assign data_result = w_status?div_result:regOut[32:1];

endmodule