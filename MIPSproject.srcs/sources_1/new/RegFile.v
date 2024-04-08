`timescale 1ns / 1ps

module RegFile (
    input         clk,
    input         reset,
    input         RegWr,//regWriteEn
    input  [4:0]  RsAddr,//rs地址
    input  [4:0]  RtAddr,//rt地址
    input  [4:0]  WrAddr,//regWriteAddr
    input  [31:0] DataIn,//regWriteData
    output [31:0] RsData,//rs数据
    output [31:0] RtData//rt数据
);
// 32 regs, for each one is 32
reg [31:0] regs[0:31];

assign RsData = (RsAddr == 5'b0) ? 32'b0 : regs[RsAddr]; 
assign RtData = (RtAddr == 5'b0) ? 32'b0 : regs[RtAddr]; 

integer i;
always @(posedge clk) begin
    if(!reset & RegWr) begin
        regs[WrAddr] = DataIn;
    end

    else if(reset) begin
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] = i;
        end
    end
end
endmodule
