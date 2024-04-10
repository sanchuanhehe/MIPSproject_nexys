`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/08 13:39:13
// Design Name: 
// Module Name: top
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


module top(
    input clk, //时钟信号
    input reset ,//重置信号
    input CP_reset,//用于更新PC
    input select,//选择器
    output [7:0] LED,//片名
    output [7:0] HEX//数码管
    );
    wire [31:0] PC;
    wire CP;
    wire [31:0] Instr;
    wire [31:0] data;

    assign data = select ? Instr : PC;

    Divide_to_1Hz Divide_to_1Hz1(//1Hz,用于更新PC
        .CLK_100M(clk),
        .nCLR(!CP_reset),
        .CLK_1HzOut(CP)
    );

    mips mips1(
        .clk(CP),
        .reset(reset),
        .PC(PC),
        .Instr(Instr)
    );


    wire CP_2000;

    DV2_2000 DV2_20001(//2000Hz,用于更新flag
        .CLK_100M(clk),
        .nCLR(!CP_reset),
        .CLK_1HzOut(CP_2000)
    );

    wire [2:0] flag;//用于更新数码管显示

    flag_exchange flag_exchange1(
        .clk_2000(CP_2000),
        .flag(flag)
    );

    //子模块:将32位PC译码为8位数码管并显示
    Screen Screen1(//数码管显示
        .flag(flag),
        .data(data),
        .LED(LED),
        .outHEX(HEX)
    );


endmodule



module flag_exchange(clk_2000, flag);
    input clk_2000;
    output reg [2:0]flag;
    
    initial flag <= 0;
    always @(posedge clk_2000)
        flag <= (flag+1'b1)%8;
    
endmodule