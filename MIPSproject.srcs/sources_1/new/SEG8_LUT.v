`timescale 1ns / 1ps

module SEG8_LUT(OutSEG,InDIG);
    input [3:0] InDIG;
    output reg [7:0] OutSEG;
always@(InDIG)
begin
    case(InDIG)
        4'h1:OutSEG = 8'b1111_1001;
        4'h2:OutSEG = 8'b1010_0100;
        4'h3:OutSEG = 8'b1011_0000;
        4'h4:OutSEG = 8'b1001_1001;
        4'h5:OutSEG = 8'b1001_0010;
        4'h6:OutSEG = 8'b1000_0010;
        4'h7:OutSEG = 8'b1111_1000;
        4'h8:OutSEG = 8'b1000_0000;
        4'h9:OutSEG = 8'b1001_1000;
        4'ha:OutSEG = 8'b1000_1000;
        4'hb:OutSEG = 8'b1000_0011;
        4'hc:OutSEG = 8'b1100_0110;
        4'hd:OutSEG = 8'b1010_0001;
        4'he:OutSEG = 8'b1000_0110;
        4'hf:OutSEG = 8'b1000_1110;
        4'h0:OutSEG = 8'b1100_0000;
    endcase             
end
endmodule
