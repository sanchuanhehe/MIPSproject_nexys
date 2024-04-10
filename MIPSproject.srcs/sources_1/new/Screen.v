`timescale 1ns / 1ps
module Screen(
    input [2:0] flag,
    input [31:0] data,
    output reg [7:0] LED,
    output [7:0] outHEX 
    );

    reg [3:0] HEX;


    always @(flag)
        begin
            case(flag)
                3'd0:  begin LED <= 8'b1111_1110; HEX <= data[3:0]; end
                3'd1: begin LED <= 8'b1111_1101; HEX <= data[7:4]; end
                3'd2: begin LED <= 8'b1111_1011; HEX <= data[11:8]; end
                3'd3: begin LED <= 8'b1111_0111; HEX <= data[15:12]; end
                3'd4: begin LED <= 8'b1110_1111; HEX <= data[19:16]; end
                3'd5: begin LED <= 8'b1101_1111; HEX <= data[23:20]; end
                3'd6: begin LED <= 8'b1011_1111; HEX <= data[27:24]; end
                3'd7: begin LED <= 8'b0111_1111; HEX <= data[31:28]; end
                default: begin LED <= 8'b1111_1111; HEX <= 4'b1111; end

            endcase
        end

    SEG8_LUT SEG8_LUT1(//数码管显示
        .OutSEG(outHEX),
        .InDIG(HEX)
    );

endmodule