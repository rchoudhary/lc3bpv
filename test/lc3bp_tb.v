//////////////////////////////////////////////////////////////////////////////////
//
// Author: Rutvik Choudhary
// Created: 8/27/18
// Filename: lc3bp_tb.v
// Modules: LC3BPTestBench
// Description: Test bench for the LC3BP module. Used for testing the pipeline
//              end-to-end
//
//////////////////////////////////////////////////////////////////////////////////

`ifndef LC3BPTestBench_V
`define LC3BPTestBench_V

`timescale 1ns/1ns

// This needs to be before any include statements!
`define TESTING

`include "lc3bp.v"
`include "misc/clock_dividers.v"

module LC3BPTestBench();

    // Set up clocks

    wire clk;
    reg mem_clk;

    ClockDivider_2 ClockDivider_2 (.clk(mem_clk), .clk_div(clk));

    initial begin
        mem_clk = 0;
    end

    always begin
        #50; mem_clk = ~mem_clk;
    end

    // Register preview

    wire [127:0] reg_contents;
    wire [15:0] R0;
    wire [15:0] R1;
    wire [15:0] R2;
    wire [15:0] R3;
    wire [15:0] R4;
    wire [15:0] R5;
    wire [15:0] R6;
    wire [15:0] R7;
    assign {R0, R1, R2, R3, R4, R5, R6, R7} = reg_contents;

    // Fetch stage latches

    wire [15:0] PC;

    // Decode stage latches

    wire [15:0] DE_NPC;
    wire [15:0] DE_IR;
    wire DE_V;

    // AGEX stage latches

    wire [15:0] AGEX_NPC;
    wire [19:0] AGEX_CS;
    wire [15:0] AGEX_IR;
    wire [15:0] AGEX_SR1;
    wire [15:0] AGEX_SR2;
    wire [2:0] AGEX_CC;
    wire [2:0] AGEX_DRID;
    wire AGEX_V;

    // Temporry Inputs

    wire v_agex_br_stall;
    wire v_agex_ld_reg;
    wire v_agex_ld_cc;
    wire mem_stall;
    wire v_mem_br_stall;
    wire [1:0] mem_pcmux;
    wire v_mem_ld_reg;
    wire [2:0] mem_drid;
    wire v_mem_ld_cc;
    wire v_sr_ld_reg;
    wire [2:0] sr_drid;
    wire [15:0] sr_reg_data;
    wire v_sr_ld_cc;
    wire [2:0] sr_cc_data;

    // Instantiate LC3BP module

    LC3BP lc3bp(
        // Inputs
        .clk            (clk),
        .mem_clk        (mem_clk),
        .imem_r         (1'b1),
        .instr          (16'hF025),
        // Temporary Inputs
        .v_agex_br_stall(v_agex_br_stall),
        .v_agex_ld_reg  (v_agex_ld_reg),
        .v_agex_ld_cc   (v_agex_ld_cc),
        .mem_stall      (mem_stall),
        .v_mem_br_stall (v_mem_br_stall),
        .mem_pcmux      (mem_pcmux),
        .v_mem_ld_reg   (v_mem_ld_reg),
        .mem_drid       (mem_drid),
        .v_mem_ld_cc    (v_mem_ld_cc),
        .v_sr_ld_reg    (v_sr_ld_reg),
        .sr_drid        (sr_drid),
        .sr_reg_data    (sr_reg_data),
        .v_sr_ld_cc     (v_sr_ld_cc),
        .sr_cc_data     (sr_cc_data),
        // Outputs
        .reg_contents   (reg_contents),
        .PC_out         (PC),
        .DE_NPC_out     (DE_NPC),
        .DE_IR_out      (DE_IR),
        .DE_V_out       (DE_V),
        .AGEX_NPC_out   (AGEX_NPC),
        .AGEX_CS_out    (AGEX_CS),
        .AGEX_IR_out    (AGEX_IR),
        .AGEX_SR1_out   (AGEX_SR1),
        .AGEX_SR2_out   (AGEX_SR2),
        .AGEX_CC_out    (AGEX_CC),
        .AGEX_DRID_out  (AGEX_DRID),
        .AGEX_V_out     (AGEX_V)
    );


endmodule

`endif // LC3BPTestBench_V