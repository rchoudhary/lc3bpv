//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Rutvik Choudhary
// Created: 6/10/18
// Filename: reg_file.v
// Modules: RegFile
// Description: Register file. 8, 16-bit registers, R0-R7. Asynchronous reads,
//              synchronous writes.
//
//////////////////////////////////////////////////////////////////////////////////

module RegFile(
    input clk,
    input [2:0] sr1,
    input [2:0] sr2,
    input we,
    input [2:0] dr,
    input [15:0] dataIn,
    output [15:0] sr1Out,
    output [15:0] sr2Out
    );
    
    reg [15:0] storage [0:7];
    
    initial begin
        storage[0] = 1;
        storage[1] = 2;
        storage[2] = 3;
        storage[3] = 4;
        storage[4] = 5;
        storage[5] = 6;
        storage[6] = 7;
        storage[7] = 8;
    end
    
    assign sr1Out = storage[sr1];
    assign sr2Out = storage[sr2];
    
    always @(posedge clk) begin
        if (we == 1) begin
            storage[dr] <= dataIn;
        end
    end
    
endmodule
