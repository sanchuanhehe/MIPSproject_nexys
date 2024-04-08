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

  top dut (
    .clk(clk),
    .reset(reset),
    .LED(LED),
    .HEX(HEX)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end 
  
  // Reset generation
  initial begin
    reset = 1;
    #10 reset = 0;
  end

  // Test stimulus
  initial begin
    // Wait for a few clock cycles
    #20;

    // Perform test case 1
    // Set inputs
    reset = 1;
    // Wait for a few clock cycles
    #10;
    reset = 0;
    // Wait for a few clock cycles
    #100;
    // Check outputs
    // TODO: Add your assertions here

    // Perform test case 2
    // Set inputs
    reset = 1;
    // Wait for a few clock cycles
    #10;
    reset = 0;
    // Wait for a few clock cycles
    #200;
    // Check outputs
    // TODO: Add your assertions here

    // Perform test case 3
    // Set inputs
    reset = 1;
    // Wait for a few clock cycles
    #10;
    reset = 0;
    // Wait for a few clock cycles
    #300;
    // Check outputs
    // TODO: Add your assertions here

    // End simulation
    $finish;
  end

endmodule