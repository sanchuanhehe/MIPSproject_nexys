`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/20 16:45:46
// Design Name: 
// Module Name: Divide_to_1Hz
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Divide_to_1Hz(CLK_100M,nCLR,CLK_1HzOut);
    parameter N = 25;//位宽
    parameter CLK_Freq = 100_000000;//100MHz时钟输入
    parameter OUT_Freq = 2000_000;//1Hz时钟输出
    input nCLR,CLK_100M;
    output reg CLK_1HzOut;
    reg [N-1:0] Count_DIV;
    
always@(posedge CLK_100M or negedge nCLR)
begin
    if(!nCLR)
        begin
        CLK_1HzOut<=0;//异步清零
        Count_DIV<=0;
        end
    else
        begin
            if(Count_DIV<(CLK_Freq/(2*OUT_Freq)-1))
                Count_DIV<=Count_DIV+1'b1;
            else
                begin
                    Count_DIV<=0;
                    CLK_1HzOut<=~CLK_1HzOut;
                end
        end
end
endmodule
