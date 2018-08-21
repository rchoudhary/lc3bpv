//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Rutvik Choudhary
// Created: 6/10/18
// Filename: alu.v
// Modules: ALU
// Description: 4-function ALU
//
//////////////////////////////////////////////////////////////////////////////////

module ALU(
    input [15:0] a,
    input [15:0] b,
    input [1:0] op,
    output reg [15:0] res
    );
    
    `define ADD   2'b00
    `define AND   2'b01
    `define XOR   2'b10
    `define PASSA 2'b11
    
    always @(*) begin
        if (op == `ADD) begin
            res <= a + b;
        end
        else if (op == `AND) begin
            res <= a & b;
        end
        else if (op == `XOR) begin
            res <= a ^ b;
        end
        else if (op == `PASSA) begin
            res <= a;
        end
    end
    
endmodule
