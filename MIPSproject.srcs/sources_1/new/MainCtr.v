`timescale 1ns / 1ps

module MainCtr (
    input [5:0] OpCode,// Instr[31:26]
    output RegDst,// R型指令的目标寄存器编号
    output Imm,// ALU的第二个数据来源
    output Mem2Reg,// 写入目标寄存器的数据来源
    output RegWr,// 是否写入目标寄存器
    output MemWr,// 是否写入数据存储器
    output B,// 是否是条件跳转控制指令
    output J, // 是否是无条件跳转指令
    output [1:0] ALUOp// ALU的运算类型
);
    reg [8:0] outputtemp;

    assign RegDst = outputtemp[8];
    assign Imm = outputtemp[7];  
    assign Mem2Reg = outputtemp[6];  
    assign RegWr = outputtemp[5];  
    assign MemWr = outputtemp[4];  
    assign B = outputtemp[3];  
    assign J = outputtemp[2];  
    assign ALUOp = outputtemp[1:0];

    always @(OpCode) begin
        case (OpCode)
            6'b000010: outputtemp = 9'bxxx0001xx;// j
            6'b000000: outputtemp = 9'b100100010;// R
            6'b100011: outputtemp = 9'b011100000;// lw
            6'b101011: outputtemp = 9'bx1x010000;// sw
            6'b000100: outputtemp = 9'bx0x001001;// beq
            6'b001100: outputtemp = 9'b010100011;// andi
            default:   outputtemp = 9'b000000000;// default
        endcase
    end
endmodule
