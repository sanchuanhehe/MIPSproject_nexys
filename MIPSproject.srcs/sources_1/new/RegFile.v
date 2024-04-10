`timescale 1ns / 1ps

module RegFile (
    input         clk,
    input         reset,
    input         RegWr,//regWriteEn
    input         JrEn,//jrEn,覆写reg16-23,28-31
    input         JalEn,//jalEn,save reg16-23,28-31
    input  [4:0]  RsAddr,//rs地址
    input  [4:0]  RtAddr,//rt地址
    input  [4:0]  WrAddr,//regWriteAddr
    input  [31:0] DataIn,//regWriteData
    output [31:0] RsData,//rs数据
    output [31:0] RtData//rt数据
);
// 32 regs, for each one is 32
reg [31:0] regs[0:31];
reg [11:0] fun_regs[0:31];

assign RsData = (RsAddr == 5'b0) ? 32'b0 : regs[RsAddr]; 
assign RtData = (RtAddr == 5'b0) ? 32'b0 : regs[RtAddr]; 

parameter zero = 0;

always @(clk) begin
    regs[0] = zero;
end

integer i;
always @(posedge clk) begin
    if(reset) begin
        for (i = 1; i < 32; i = i + 1) begin
            regs[i] = 0;
            fun_regs[i] = 0;
        end
    end
    else if(RegWr) begin
        regs[WrAddr] = DataIn;
    end
    else if(JrEn) begin
        for (i = 16; i <23; i = i + 1 ) begin
            regs[i] = fun_regs[i - 16];
        end
        for (i = 28; i < 32; i = i + 1) begin
            regs[i] = fun_regs[i - 20];
        end
    end

    else if(JalEn) begin
        for (i = 16; i < 23; i = i + 1) begin
            fun_regs[i - 16] = regs[i];
        end
        for (i = 28; i < 32; i = i + 1) begin
            fun_regs[i - 20] = regs[i];
        end
    end
end
endmodule
