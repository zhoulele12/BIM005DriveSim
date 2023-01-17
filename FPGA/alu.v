module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire [31:0] B_invert,add_result,sub_result,and_result,or_result,left_s_result,right_s_result;
    wire C32,C33;

    //invert B
    genvar i;
    generate
        for(i=0;i<32;i=i+1) begin
            not notGate(B_invert[i],data_operandB[i]);
        end
    endgenerate

    CLA adder(.A(data_operandA),.B(data_operandB),.C0(1'b0),.S(add_result),.C32(),.g(and_result),.p(or_result));
    CLA subtractor(.A(data_operandA),.B(B_invert),.C0(1'b1),.S(sub_result),.C32(),.g(),.p());
    
    //left logical shift
    left_shifter left_shift(.left_s_result(left_s_result),.shift_amt(ctrl_shiftamt),.operand(data_operandA));
    //right arithmetic shift
    right_shifter right_shift(.right_s_result(right_s_result),.shift_amt(ctrl_shiftamt),.operand(data_operandA));

    //3 output signals
    or notEq(isNotEqual,sub_result[0],sub_result[1],sub_result[2],sub_result[3],sub_result[4],sub_result[5],sub_result[6],sub_result[7],sub_result[8],sub_result[9],sub_result[10],sub_result[11],sub_result[12],sub_result[13],sub_result[14],sub_result[15],sub_result[16],sub_result[17],sub_result[18],sub_result[19],sub_result[20],sub_result[21],sub_result[22],sub_result[23],sub_result[24],sub_result[25],sub_result[26],sub_result[27],sub_result[28],sub_result[29],sub_result[30],sub_result[31]);

    assign isLessThan = sub_over ? data_operandA[31]:sub_result[31];

    wire addOpSign,addResSign,subOpSign,subResSign,add_over,sub_over;
    xnor checkAddOp(addOpSign,data_operandA[31],data_operandB[31]);
    xor checkAddResSign(addResSign,data_operandA[31],add_result[31]);
    and addOver(add_over,addOpSign,addResSign);
    xnor checkSubOp(subOpSign,data_operandA[31],B_invert[31]);
    xor checkSubResSign(subResSign,data_operandA[31],sub_result[31]);
    and subOver(sub_over,subOpSign,subResSign);

    assign overflow = ctrl_ALUopcode[0]?sub_over:add_over;

    mux8 chooseOutput(.in0(add_result),.in1(sub_result),.in2(and_result),.in3(or_result),.in4(left_s_result),.in5(right_s_result),.in6(add_result),.in7(add_result),.select(ctrl_ALUopcode[2:0]),.out(data_result));

endmodule