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

`ifndef MEMORY
`define MEMORY

module Memory(
    input clk,
    input [15:0] addr1,
    input [15:0] addr2,
    input en,
    input we_low,
    input we_high,
    input [15:0] data_in,
    output reg [15:0] data1_out,
    output reg [15:0] data2_out,
    output reg mem1_r
);
    
    reg [7:0] high_bytes [0:32767];
    reg [7:0] low_bytes [0:32767];
    
    wire [14:0] waddr1 = addr1[15:1];
    wire [14:0] waddr2 = addr2[15:1];
    
    reg [15:0] i;
    initial begin
        mem1_r <= 1'b0;
        for (i = 0; i < 32768; i = i + 1) begin
            high_bytes[i] <= i[14:7];
            low_bytes[i] <= {i[6:0], 1'b0};
        end
    end

    // Read both ports
    always @(posedge clk) begin
        if (en == 1) begin
            mem1_r <= 1'b1;
            data1_out <= {high_bytes[waddr1], low_bytes[waddr1]};
            data2_out <= {high_bytes[waddr2], low_bytes[waddr2]};
            if (we_low == 1) begin
                low_bytes[waddr2] <= data_in[7:0];
            end
            if (we_high == 1) begin
                high_bytes[waddr2] <= data_in[15:8];
            end  
        end
        else begin
            mem1_r <= 1'b0;
            data1_out <= 16'b0;
            data2_out <= 16'b0;
        end
    end
    
endmodule

`endif // MEMORY