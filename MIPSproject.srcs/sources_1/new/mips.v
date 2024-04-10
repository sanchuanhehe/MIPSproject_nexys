`timescale 1ns / 1ps

module mips (
    input clk, //时钟信号
    input reset ,//重置信号
    output reg [31:0] PC,
    output [31:0] Instr
);

    wire [31:0] TempPC, //保存更新得到的PC值
                JumpPC, //无条件跳转的PC值
                NotJMPPC, //存储PC运算的中间结果
                NewPC, //PC值加4的结果(顺序执行)
                BranchPC, //存储PC运算的中间结果
                Imm32, //存储低16位的立即数有符号扩展为32位的结果，用于条件跳转控制指令
                ImmL2, //存储条件跳转控制指令的跳转步数（以Byte为单位）
                regWriteData, //存储写入目标寄存器的数据
                regWriteData_1, //存储写入目标寄存器的数据中间结果
                RsData, //存储寄存器1的数据——[25:21]
                RtData, //存储寄存器2的数据——[20:16]
                ALUin2, //存储ALU进行运算的第二个数据，可能来自低16位的扩展，也可能来自寄存器2的数据。（第一个数据来自寄存器1的数据）
                ALUres, //存储ALU的运算结果
                memReadData_1; //存储从数据存储器取出的数据

    reg [31:0]  memReadData; //存储从数据存储器取出的数据

                
    wire [4:0] regWriteAddr_1;//存储要写入的寄存器编号，存储结果和指令是R型还是I型有关
    wire [4:0] regWriteAddr;//存储要写入的寄存器编号，存储结果和指令是R型还是I型有关
    
    wire [27:0] PsudeoPC;//用于保存JUMP指令执行过程中的中间结果
    
    wire [1:0] ALUop;
    
    wire [3:0] ALUctr;
    
    wire BranchZ, //条件跳转控制标志
         regDst, //判断R型和I型指令的标志位
         Imm, //判断ALU的数据来源的标志位
         M2R, //判断写入目标寄存器的数据的来源的标志位
         RegWr, //判断是否写入目标寄存器的标志位
         zero, //ALU的结果是否为零的标志位
         memWriteEn, //判断是否写入数据存储器的标志位
         B, //条件跳转控制标志
         J,//无无条件伪直接寻址判断标志
         JrEn, //判断是否是jr指令
         JalEn; //判断是否是jal指令

    assign PsudeoPC = {Instr[25:0], 2'b00};
    //将32位机器码的低26位左移两位，低位补零，用于JUMP指令
    
    assign JumpPC = {NewPC[31:28], PsudeoPC};
    //将PsudeoPC和NewPC的高四位拼接得到JumpPC
    
    assign TempPC = J ? JumpPC : NotJMPPC;//MUX1
    //判断指令是否是无条件伪直接寻址：若J=1，则为无无条件伪直接寻址；若J=0，则需进一步判断指令是否是条件跳转控制

    assign NotJMPPC = BranchZ ? BranchPC : NewPC;
    //判断指令是否是条件跳转控制;若BranchZ=1，则是条件跳转控制；BranchZ=0，则不是条件跳转控制
    
    assign BranchPC = ImmL2 + NewPC;
    //更新条件跳转控制的PC值
    
    assign ImmL2 = {Imm32[29:0], 2'b00};
    //将低16位的立即数有符号扩展为32位的结果右移两位，低位补零，相当于乘4，所得结果为条件跳转控制指令的跳转步数（以Byte为单位）
    
    assign Imm32 = {Instr[15] ? 16'hffff : 16'h0000, Instr[15:0]};
    //低16位的立即数有符号扩展为32位，用于条件跳转控制指令
    
    assign BranchZ = B & zero;
    //判断是否进行条件跳转控制
    
    assign regWriteAddr_1 = regDst ? Instr[15:11] : Instr[20:16];//MUX5
    //判断指令是R型还是I型，若regDst为1，则是R型，目标寄存器regWriteAddr指向Instr[15:11]；否则指向Instr[20:16]

    assign regWriteAddr = JalEn ? 31 : regWriteAddr_1;
    //判断是否是jal指令，若JalEn为1，则目标寄存器regWriteAddr指向31；否则指向regWriteAddr_1
    
    assign ALUin2 = Imm ? Imm32 : RtData;//MUX2
    //判断ALU进行运算的数据来源：若Imm为1，则数据来自机器码低16位有符号扩展；否则数据来自寄存器2
    
    assign regWriteData_1 = M2R ? memReadData : ALUres;//MUX3
    //判断写入目标寄存器的数据的来源：若M2R为1，则写入数据来自数据存储器；否则来自ALU运算结果。
    
    assign regWriteData = JalEn ? PC : regWriteData_1;

    assign NewPC = PC + 4;
    //不为条件跳转控制指令，也不为无无条件伪直接寻址指令，顺序执行,PC自动加4
    
    assign JrEn = Instr[5:0] == 6'b001000 & Instr[31:26] == 6'b000000;

    always @(negedge clk) begin//在时钟下降沿时刻进行判断
        if(reset)//重置，PC置零
            PC <= 32'h0;
        else if (JrEn)//jr指令，PC更新至RsData
            PC <= RsData;
        else
            PC <= TempPC;//没有重置，正常运行，将总的运算结果TempPC更新至PC

    end
    
    //lb,lh,lbu,lhu
    always @(memReadData_1) begin
        case (Instr[5:0])
            //lb
            6'b100000: begin
                if(memReadData_1[7] == 1)
                    memReadData = {24'hff, memReadData_1[7:0]};
                else
                    memReadData = {24'h00, memReadData_1[7:0]};
            end
            //lh
            6'b100001: begin
                if(memReadData_1[15] == 1)
                    memReadData = {16'hffff, memReadData_1[15:0]};
                else
                    memReadData = {16'h0000, memReadData_1[15:0]};
            end
            //lbu
            6'b100100: begin
                memReadData = {24'h00, memReadData_1[7:0]};
            end
            //lhu
            6'b100101: begin
                memReadData = {16'h0000, memReadData_1[15:0]};
            end
            default: 
                memReadData = memReadData_1;
        endcase
    end



    ALU U0(.In1(RsData),.In2(ALUin2),.ALUCtr(ALUctr),.Res(ALUres),.Zero(zero));//ALU模块


    RegFile U3(.clk(clk),.reset(reset),
        .JrEn(JrEn),.JalEn(JalEn),//jalEn,save reg16-23,28-31,jrEn,覆写reg16-23,28-31
        .RegWr(RegWr),.RsAddr(Instr[25:21]),.RtAddr(Instr[20:16]),//寄存器文件模块
        .WrAddr(regWriteAddr),.DataIn(regWriteData),.RsData(RsData),.RtData(RtData));

    MainCtr U4(.OpCode(Instr[31:26]),
        //.FunCode(Instr[5:0]),
        // .JrEn(JrEn),
        .JalEn(JalEn),//是否是jr指令,是否jal指令
        .RegDst(regDst),.Imm(Imm),.Mem2Reg(M2R),.RegWr(RegWr),.MemWr(memWriteEn),//主控制模块
        .B(B),.J(J),.ALUOp(ALUop));

    ALUCtr U5(.ALUOp(ALUop),
    .Funct(Instr[5:0]),.ALUCtr(ALUctr));//ALU控制模块
    DataRAM U6(.clk(clk),.we(memWriteEn),.a(ALUres[7:2]),.d(RtData),.spo(memReadData_1));//数据存储器模块

    InstrROM U7(.clk(clk),.a(PC[8:2]),.qspo(Instr));//程序存储器模块

endmodule

