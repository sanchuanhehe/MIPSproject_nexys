`timescale 1ns / 1ps
module mips_sim;
    reg clk;
    reg reset;
    mips U0(clk, reset);

    parameter halfPERIOD = 10;

    always begin
        clk = 0;
        forever #halfPERIOD clk = ~clk;
    end

    initial begin
    reset = 1;//reset
    #20
    reset = 0;//start
    #2000
    reset = 1;//reset
    end

endmodule
