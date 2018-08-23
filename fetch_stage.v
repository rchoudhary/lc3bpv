//////////////////////////////////////////////////////////////////////////////////
//
// Author: Rutvik Choudhary
// Created: 7/4/18
// Filename: fetch_stage.v
// Modules: FetchStage
// Description: Encapsulates the fetch stage of the pipeline.
//
//////////////////////////////////////////////////////////////////////////////////

`ifndef FETCH_STAGE_V
`define FETCH_STAGE_V

module FetchStage(
    input clk,
    input [15:0] pc,
    input dep_stall,
    input mem_stall,
    input v_de_br_stall,
    input v_agex_br_stall,
    input v_mem_br_stall,
    input imem_r,
    input [1:0] mem_pcmux,
    input [15:0] target_pc,
    input [15:0] trap_pc,
    input [15:0] instr,
    output ld_pc,
    output [15:0] de_npc,
    output [15:0] de_ir,
    output de_v,
    output ld_de,
    output reg [15:0] new_pc
);

    wire [15:0] pc_plus_two = pc + 2;

    assign de_npc = pc_plus_two;
    assign de_ir = (imem_r == 1) ? instr : 16'b0;
    assign de_v = !(!imem_r || v_de_br_stall || v_agex_br_stall || v_mem_br_stall);
    assign ld_de = !(dep_stall || mem_stall);

    assign ld_pc = (mem_pcmux == 2'b0 && imem_r && !(dep_stall || mem_stall || v_de_br_stall || v_agex_br_stall || v_mem_br_stall)) || (mem_pcmux != 0);

    always @(*) begin
        case (mem_pcmux)
            0: new_pc <= pc_plus_two;
            1: new_pc <= target_pc;
            2: new_pc <= trap_pc;
            4: new_pc <= 16'b0;
        endcase
    end

endmodule

`endif // FETCH_STAGE_V
