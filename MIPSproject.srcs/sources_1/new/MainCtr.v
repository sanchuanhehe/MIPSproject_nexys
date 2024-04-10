`timescale 1ns / 1ps

module MainCtr (
    input [5:0] OpCode,// Instr[31:26]
    //input [5:0] FunCode,// Instr[5:0]
    //output JrEn,// 是否是jr指令
    output JalEn,// 是否是无条件跳转指令
    output RegDst,// R型指令的目标寄存器编号
    output Imm,// ALU的第二个数据来源
    output Mem2Reg,// 写入目标寄存器的数据来源
    output RegWr,// 是否写入目标寄存器
    output MemWr,// 是否写入数据存储器
    output B,// 是否是条件跳转控制指令
    output J, // 是否是无条件跳转指令
    output [1:0] ALUOp// ALU的运算类型
);
    reg [9:0] outputtemp;

    //assign JrEn = outputtemp[10];
    assign JalEn = outputtemp[9];
    assign RegDst = outputtemp[8];
    assign Imm = outputtemp[7];  
    assign Mem2Reg = outputtemp[6];  
    assign RegWr = outputtemp[5];  
    assign MemWr = outputtemp[4];  
    assign B = outputtemp[3];  
    assign J = outputtemp[2];  
    assign ALUOp = outputtemp[1:0];

    always @(OpCode) begin
        casex (OpCode)
            12'b000010: outputtemp = 10'b0xxx0001xx;// j
            12'b000000: outputtemp = 10'b0100100010;// R
            12'b100011: outputtemp = 10'b0011100000;// lw
            12'b101011: outputtemp = 10'b0x1x010000;// sw
            12'b000100: outputtemp = 10'b0x0x001001;// beq
            12'b001100: outputtemp = 10'b0010100011;// andi
            12'b000011: outputtemp = 10'b1xxx1001xx;// jal
            default:   outputtemp = 10'b0000000000;// default
        endcase
    end
endmodule
