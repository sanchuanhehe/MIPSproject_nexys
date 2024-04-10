`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/08 14:11:26
// Design Name: 
// Module Name: top_sim
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


module top_sim;

  reg clk;
  reg reset;
  wire [7:0] LED;
  wire [7:0] HEX;
  reg select;
  reg CP_reset;

  top dut (
    .clk(clk),
    .reset(reset),
    .CP_reset(CP_reset),
    .select(select),
    .LED(LED),
    .HEX(HEX)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end 
  
  initial begin
    CP_reset = 1;
    #10 CP_reset = 0;
  
  end

  // Test stimulus
  initial begin
    select = 0;
    reset = 1;
    #1000 reset = 0;
    #100000;
    $finish;
  end

endmodule