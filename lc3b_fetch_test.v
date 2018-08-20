//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Rutvik Choudhary
// Created: 8/11/18
// Filename: lc3b_fetch_test.v
// Modules: LC3BFetchTest
// Description: Top level module for testing the fetch stage.
//
//////////////////////////////////////////////////////////////////////////////////

module LC3BFetchTest(
    input raw_clk,
    input dep_stall,
    input mem_stall,
    input v_de_br_stall,
    input v_agex_br_stall,
    input v_mem_br_stall,
    input [1:0] mem_pcmux,
    input [15:0] target_pc,
    input [15:0] trap_pc,
    input [15:0] instr,
    output [15:0] new_pc,
    output reg [15:0] de_npc,
    output reg [15:0] de_ir,
    output reg [15:0] de_v
    );

    wire clk, mem_clk;
    assign mem_clk = raw_clk;
    ClockDivider_2 clkDiv_2(
        .clk(raw_clk), // Input
        .clk_div(clk)  // Output
    );

    reg [15:0] PC;

    initial begin
        PC <= 16'h3000;
    end

    wire [15:0] instr_bus;
    wire imem_r;

    Memory RAW_MEM(
        // Inputs
        .clk(mem_clk),
        .addr1(PC),
        .addr2(16'b0),
        .en(1'b1),
        .weLow(1'b0),
        .weHi(1'b0),
        .dataIn(16'b0),
        // Outputs
        .dataOut1(instr_bus),
        .mem1_r(imem_r)
    );

    wire [15:0] de_npc_in;
    wire [15:0] de_ir_in;
    wire de_v_in;
    wire ld_pc;
    wire ld_de;
    
    FetchStage FETCH(
        // Inputs
        .clk(clk),
        .pc(PC),
        .dep_stall(dep_stall),
        .mem_stall(mem_stall),
        .v_de_br_stall(v_de_br_stall),
        .v_agex_br_stall(v_agex_br_stall),
        .v_mem_br_stall(v_mem_br_stall),
        .imem_r(imem_r),
        .mem_pcmux(mem_pcmux),
        .target_pc(target_pc),
        .trap_pc(trap_pc),
        .instr(instr_bus),
        // Outputs
        .ld_pc(ld_pc),
        .de_npc(de_npc_in),
        .de_ir(de_ir_in),
        .de_v(de_v_in),
        .ld_de(ld_de),
        .new_pc(new_pc)
    );

    // Latch values for all stages
    always @(posedge clk) begin
        // Fetch stage feedback
        if (ld_pc == 1) begin
            PC <= new_pc;
        end

        // Fetch stage output
        if (ld_de == 1) begin
            de_npc <= de_npc_in;
            de_ir <= de_ir_in;
            de_v <= de_v_in;
        end
    end

endmodule