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

module HexTo7SegDecoder(digit, seg);
    input [3:0] digit;
    output reg [6:0] seg;

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

module MultiplexClockDivider(clk100Mhz, multiplexClk);
  input clk100Mhz;
  output multiplexClk;

  reg[16:0] counter;
  assign multiplexClk = counter[16];

  initial begin
    counter <= 0;
  end

  always @ (posedge clk100Mhz)
  begin
    counter <= counter + 1;
  end
endmodule

module Hex4Display(clk, digits, onesPlace, enableDp, seg, an);
    input clk, enableDp;
    input [15:0] digits;
    input [1:0] onesPlace;
    
    output [7:0] seg;
    output reg [3:0] an;
    
    reg [3:0] activeDigit;
    reg dp;

    wire [6:0] decodedDigit;
    HexTo7SegDecoder decoder(activeDigit, decodedDigit);
    
    wire slowClk;
    MultiplexClockDivider clockDiv(clk, slowClk);

    assign seg = {dp, decodedDigit};
        
    reg [1:0] i;
    initial begin
        i = 3;
    end
            
    always @(posedge slowClk) begin
        case(i)
            3: begin
                activeDigit <= digits[15:12];
                an <= 4'b0111;
            end
            2: begin
                activeDigit <= digits[11:8];
                an <= 4'b1011;
            end
            1: begin
                activeDigit <= digits[7:4];
                an <= 4'b1101;
            end
            0: begin
                activeDigit <= digits[3:0];
                an <= 4'b1110;
            end
            default: begin
                an <= 4'b1111;
            end
        endcase

        dp <= (i == onesPlace && enableDp) ? 1 : 0;
        
        if (i == 0) i <= 3;
        else i <= i - 1;
    end
endmodule
