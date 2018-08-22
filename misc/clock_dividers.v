//////////////////////////////////////////////////////////////////////////////////
//
// Author: Rutvik Choudhary
// Created: 8/19/18
// Filename: clock_dividers.v
// Modules: ClockDivider_2
// Description: Modules for clock division
//
//////////////////////////////////////////////////////////////////////////////////

`ifndef CLOCK_DIVIDERS
`define CLOCK_DIVIDERS

// Divides clock signal by 2
module ClockDivider_2(
    input clk, 
    output reg clk_div
);

    initial begin
        clk_div <= 0;
    end

    always @(posedge clk) begin
        clk_div <= ~clk_div;
    end
endmodule

`endif // CLOCK_DIVIDERS
