//////////////////////////////////////////////////////////////////////////////////
//
// Author: Rutvik Choudhary
// Created: 8/22/18
// Filename: lc3bp.v
// Modules: LC3BP
// Description: Contains the module that represents the entirety of the
//              LC3B Pipelined processor
//
//////////////////////////////////////////////////////////////////////////////////

`ifndef LC3BP_V
`define LC3BP_V

// This needs to be before any include statements!
`define TESTING

`include "fetch_stage.v"
`include "decode_stage.v"

module LC3BP(
    // Testing Outputs
    // Used to observe the pipeline latches and registers for testing purposes
    `ifdef TESTING
        output [127:0] reg_contents,

        // Decode stage latches
        output [15:0] DE_NPC_out,
        output [15:0] DE_IR_out,
        output DE_V_out,

        // AGEX stage latches
        output [15:0] AGEX_NPC_out,
        output [19:0] AGEX_CS_out,
        output [15:0] AGEX_IR_out,
        output [15:0] AGEX_SR1_out,
        output [15:0] AGEX_SR2_out,
        output [2:0] AGEX_CC_out,
        output [2:0] AGEX_DRID_out,
        output AGEX_V_out,
    `endif

    input clk,
    input mem_clk,
    input imem_r,
    input [15:0] instr,
    output pc,

    // Temporary Inputs
    // These are meant to come from other stages, but since we only have
    // a partial pipeline, they'll have to come from outside for now

    // AGEX stage
    input v_agex_br_stall,
    input v_agex_ld_reg,
    input v_agex_ld_cc,

    // Memory stage
    input mem_stall,
    input v_mem_br_stall,
    input [1:0] mem_pcmux,
    input v_mem_ld_reg,
    input [2:0] mem_drid,
    input v_mem_ld_cc,

    // SR stage
    input v_sr_ld_reg,
    input [2:0] sr_drid,
    input [15:0] sr_reg_data,
    input v_sr_ld_cc,
    input [2:0] sr_cc_data
);

    // Fetch stage latches
    reg [15:0] PC;

    // Decode stage latches
    reg [15:0] DE_NPC;
    reg [15:0] DE_IR;
    reg DE_V;

    // AGEX stage latches
    reg [15:0] AGEX_NPC;
    reg [19:0] AGEX_CS;
    reg [15:0] AGEX_IR;
    reg [15:0] AGEX_SR1;
    reg [15:0] AGEX_SR2;
    reg [2:0] AGEX_CC;
    reg [2:0] AGEX_DRID;
    reg AGEX_V;

    // Outputs from fetch stage
    wire ld_pc;
    wire [15:0] de_npc;
    wire [15:0] de_ir;
    wire de_v;
    wire ld_de;
    wire [15:0] new_pc;

    // Outputs from decode stage
    wire dep_stall;
    wire v_de_br_stall;
    wire ld_agex;
    wire [15:0] agex_sr1;
    wire [15:0] agex_sr2;
    wire [2:0] agex_drid_new;
    wire [19:0] agex_cs;
    wire [2:0] agex_cc;
    wire agex_v;

    initial begin
        PC = 16'h3000;
    end

    FetchStage fetchStage(
        // Inputs
        .clk            (clk),
        .pc             (PC),
        .dep_stall      (dep_stall),
        .mem_stall      (mem_stall),
        .v_de_br_stall  (v_de_br_stall),
        .v_agex_br_stall(v_agex_br_stall),
        .v_mem_br_stall (v_mem_br_stall),
        .imem_r         (imem_r),
        .mem_pcmux      (mem_pcmux),
        .target_pc      (16'hDEAD),
        .trap_pc        (16'hBEEF),
        .instr          (instr),
        // Outputs
        .ld_pc          (ld_pc),
        .de_npc         (de_npc),
        .de_ir          (de_ir),
        .de_v           (de_v),
        .ld_de          (ld_de),
        .new_pc         (new_pc)
    );

    DecodeStage DecodeStage (
        // If we're testing, then we'll want to observe the register contents
        `ifdef TESTING
            .reg_contents(reg_contents),
        `endif

        // Inputs
        .clk          (clk),
        .mem_clk      (mem_clk),
        .de_npc       (DE_NPC),
        .de_ir        (DE_IR),
        .de_v         (DE_V),
        .v_agex_ld_reg(v_agex_ld_reg),
        .v_mem_ld_reg (v_mem_ld_reg),
        .v_sr_ld_reg  (v_sr_ld_reg),
        .agex_drid_old(AGEX_DRID),
        .mem_drid     (mem_drid),
        .sr_drid      (sr_drid),
        .sr_reg_data  (sr_reg_data),
        .v_agex_ld_cc (v_agex_ld_cc),
        .v_mem_ld_cc  (v_mem_ld_cc),
        .v_sr_ld_cc   (v_sr_ld_cc),
        .sr_cc_data   (sr_cc_data),
        .mem_stall    (mem_stall),
        // Outputs
        .v_de_br_stall(v_de_br_stall),
        .dep_stall    (dep_stall),
        .ld_agex      (ld_agex),
        .agex_sr1     (agex_sr1),
        .agex_sr2     (agex_sr2),
        .agex_drid_new(agex_drid_new),
        .agex_cs      (agex_cs),
        .agex_cc      (agex_cc),
        .agex_v       (agex_v)
    );

    // Drive outputs of LC3BP module
    assign pc = PC;

    // Drive testing outputs of LC3BP module
    `ifdef TESTING
        assign DE_NPC_out = DE_NPC;
        assign DE_IR_out = DE_IR;
        assign DE_V_out = DE_V;

        assign AGEX_NPC_out = AGEX_NPC;
        assign AGEX_CS_out = AGEX_CS;
        assign AGEX_IR_out = AGEX_IR;
        assign AGEX_SR1_out = AGEX_SR1;
        assign AGEX_SR2_out = AGEX_SR2;
        assign AGEX_CC_out = AGEX_CC;
        assign AGEX_DRID_out = AGEX_DRID;
        assign AGEX_V_out = AGEX_V;
    `endif

    // Latch values
    always @(posedge clk) begin
        if (ld_pc == 1) begin
            PC <= new_pc;
        end

        if (ld_de == 1) begin
            DE_NPC <= de_npc;
            DE_IR <= de_ir;
            DE_V <= de_v;
        end

        if (ld_agex == 1) begin
            AGEX_NPC <= DE_NPC;
            AGEX_CS <= agex_cs;
            AGEX_IR <= DE_IR;
            AGEX_SR1 <= agex_sr1;
            AGEX_SR2 <= agex_sr2;
            AGEX_CC <= agex_cc;
            AGEX_DRID <= agex_drid_new;
            AGEX_V <= agex_v;
        end
    end

endmodule

`endif // LC3BP_V