//////////////////////////////////////////////////////////////////////////////////
//
// Author: Rutvik Choudhary
// Created: 7/1/18
// Filename: control_store.v
// Modules: ControlStore
// Description: Simple ROM that holds control store bits. Synchronous reads.
//
//////////////////////////////////////////////////////////////////////////////////

`ifndef CONTROL_STORE
`define CONTROL_STORE

module ControlStore(
    input clk,
    input [5:0] addr,
    output reg [22:0] cs_bits
);

    reg [22:0] ROM [0:63];

    always @(posedge clk) begin
        cs_bits <= ROM[addr];
    end

    initial begin
        ROM[0]  <= 23'b00001011000010010000000;
        ROM[1]  <= 23'b00001011000010010000000;
        ROM[2]  <= 23'b00001011000010010000000;
        ROM[3]  <= 23'b00001011000010010000000;
        ROM[4]  <= 23'b11000000000100000001111;
        ROM[5]  <= 23'b10000000100100000001111;
        ROM[6]  <= 23'b11000000000100000001111;
        ROM[7]  <= 23'b10000000100100000001111;
        ROM[8]  <= 23'b10010101000000001000111;
        ROM[9]  <= 23'b10010101000000001000111;
        ROM[10] <= 23'b10010101000000001000111;
        ROM[11] <= 23'b10010101000000001000111;
        ROM[12] <= 23'b11010101011100001100000;
        ROM[13] <= 23'b11010101011100001100000;
        ROM[14] <= 23'b11010101011100001100000;
        ROM[15] <= 23'b11010101011100001100000;
        ROM[16] <= 23'b10110001000001010001010;
        ROM[17] <= 23'b10110001000001010001010;
        ROM[18] <= 23'b00101111000001010001010;
        ROM[19] <= 23'b00101111000001010001010;
        ROM[20] <= 23'b11000000001100000001111;
        ROM[21] <= 23'b10000000101100000001111;
        ROM[22] <= 23'b11000000001100000001111;
        ROM[23] <= 23'b10000000101100000001111;
        ROM[24] <= 23'b10010111000000001010111;
        ROM[25] <= 23'b10010111000000001010111;
        ROM[26] <= 23'b10010111000000001010111;
        ROM[27] <= 23'b10010111000000001010111;
        ROM[28] <= 23'b11010111011100001110000;
        ROM[29] <= 23'b11010111011100001110000;
        ROM[30] <= 23'b11010111011100001110000;
        ROM[31] <= 23'b11010111011100001110000;
        ROM[32] <= 23'b00000000000000000000000;
        ROM[33] <= 23'b00000000000000000000000;
        ROM[34] <= 23'b00000000000000000000000;
        ROM[35] <= 23'b00000000000000000000000;
        ROM[36] <= 23'b11000000010100000001111;
        ROM[37] <= 23'b10000000110100000001111;
        ROM[38] <= 23'b11000000010100000001111;
        ROM[39] <= 23'b10000000110100000001111;
        ROM[40] <= 23'b00000000000000000000000;
        ROM[41] <= 23'b00000000000000000000000;
        ROM[42] <= 23'b00000000000000000000000;
        ROM[43] <= 23'b00000000000000000000000;
        ROM[44] <= 23'b00000000000000000000000;
        ROM[45] <= 23'b00000000000000000000000;
        ROM[46] <= 23'b00000000000000000000000;
        ROM[47] <= 23'b00000000000000000000000;
        ROM[48] <= 23'b10010001000001010000000;
        ROM[49] <= 23'b10010001000001010000000;
        ROM[50] <= 23'b10010001000001010000000;
        ROM[51] <= 23'b10010001000001010000000;
        ROM[52] <= 23'b10000000000000000001111;
        ROM[53] <= 23'b10000000000000000001111;
        ROM[54] <= 23'b10000000000000000001111;
        ROM[55] <= 23'b10000000000000000001111;
        ROM[56] <= 23'b00001011000000000000010;
        ROM[57] <= 23'b00001011000000000000010;
        ROM[58] <= 23'b00001011000000000000010;
        ROM[59] <= 23'b00001011000000000000010;
        ROM[60] <= 23'b00100000000000111011010;
        ROM[61] <= 23'b00100000000000111011010;
        ROM[62] <= 23'b00100000000000111011010;
        ROM[63] <= 23'b00100000000000111011010;
    end

endmodule

`endif // CONTROL_STORE
