//////////////////////////////////////////////////////////////////////////////////
//
// Author: Rutvik Choudhary
// Created: 6/10/18
// Filename: seven_segment.v
// Modules: HexTo7SegDecoder, MultiplexClockDivider, Hex4Display
// Description: Feed a 16-bit number to Hex4Display and then feed the seg and an
//              outputs to the 7-segment display on the board to display it.
//
//////////////////////////////////////////////////////////////////////////////////

`ifndef SEVEN_SEGMENT_V
`define SEVEN_SEGMENT_V

module HexTo7SegDecoder(
    input [3:0] digit,
    output reg [6:0] seg
);

    always @(*) begin
        case (digit)
            4'h0 : seg <= 7'b1000000;
            4'h1 : seg <= 7'b1111001;
            4'h2 : seg <= 7'b0100100;
            4'h3 : seg <= 7'b0110000;
            4'h4 : seg <= 7'b0011001;
            4'h5 : seg <= 7'b0010010;
            4'h6 : seg <= 7'b0000010;
            4'h7 : seg <= 7'b1111000;
            4'h8 : seg <= 7'b0000000;
            4'h9 : seg <= 7'b0010000;
            4'hA : seg <= 7'b0001000;
            4'hB : seg <= 7'b0000011;
            4'hC : seg <= 7'b1000110;
            4'hD : seg <= 7'b0100001;
            4'hE : seg <= 7'b0000110;
            4'hF : seg <= 7'b0001110;
            default : seg <= 7'b0111111;
        endcase
    end
endmodule


module MultiplexClockDivider(
    input clk_100mhz,
    output multiplex_clk
);

  reg[16:0] counter;
  assign multiplex_clk = counter[16];

  initial begin
    counter <= 0;
  end

  always @ (posedge clk_100mhz)
  begin
    counter <= counter + 1;
  end
endmodule


module Hex4Display(
    input clk,
    input [15:0] digits,
    input [1:0] ones_place,
    input dp_en,
    output [7:0] seg,
    output reg [3:0] an
);

    reg [3:0] active_digit;
    reg dp;

    wire [6:0] decoded_digit;
    HexTo7SegDecoder decoder(active_digit, decoded_digit);

    wire slow_clk;
    MultiplexClockDivider clockDiv(clk, slow_clk);

    assign seg = {dp, decoded_digit};

    reg [1:0] i;
    initial begin
        i = 3;
    end

    always @(posedge slow_clk) begin
        case(i)
            3: begin
                active_digit <= digits[15:12];
                an <= 4'b0111;
            end
            2: begin
                active_digit <= digits[11:8];
                an <= 4'b1011;
            end
            1: begin
                active_digit <= digits[7:4];
                an <= 4'b1101;
            end
            0: begin
                active_digit <= digits[3:0];
                an <= 4'b1110;
            end
            default: begin
                an <= 4'b1111;
            end
        endcase

        dp <= (i == ones_place && dp_en) ? 1 : 0;

        if (i == 0) i <= 3;
        else i <= i - 1;
    end
endmodule

`endif // SEVEN_SEGMENT_V
