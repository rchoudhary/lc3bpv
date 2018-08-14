//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Rutvik Choudhary
// Created: 6/12/18
// Filename: memory.v
// Modules: Memory
// Description: 2-port memory. Port 1 is read only, Port 2 is read/write. Read
//              and write are synchronous and utilize Block RAM.
//
//////////////////////////////////////////////////////////////////////////////////

module Memory(
    input clk,
    input [15:0] addr1,
    input [15:0] addr2,
    input en,
    input weLow,
    input weHi,
    input [15:0] dataIn,
    output reg [15:0] dataOut1,
    output reg [15:0] dataOut2,
    output reg mem1_r
    );
    
    reg [7:0] hiBytes [0:32767];
    reg [7:0] lowBytes [0:32767];
    
    wire [14:0] waddr1 = addr1[15:1];
    wire [14:0] waddr2 = addr2[15:1];
    
    reg [15:0] i;
    initial begin
        mem1_r <= 1'b0;
        for (i = 0; i < 32768; i = i + 1) begin
            hiBytes[i] <= i[15:8];
            lowBytes[i] <= i[7:0];
        end
    end

    // Read both ports
    always @(posedge clk) begin
        if (en == 1) begin
            mem1_r <= 1'b1;
            dataOut1 <= {hiBytes[waddr1], lowBytes[waddr1]};
            dataOut2 <= {hiBytes[waddr2], lowBytes[waddr2]};
            if (weLow == 1) begin
                lowBytes[waddr2] <= dataIn[7:0];
            end
            if (weHi == 1) begin
                hiBytes[waddr2] <= dataIn[15:8];
            end  
        end
        else begin
            mem1_r <= 1'b0;
            dataOut1 <= 16'b0;
            dataOut2 <= 16'b0;
        end
    end
    
endmodule
