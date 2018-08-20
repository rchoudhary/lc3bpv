//////////////////////////////////////////////////////////////////////////////////
// 
// Author: Rutvik Choudhary
// Created: 8/20/18
// Filename: decode_stage.v
// Modules: DecodeStage
// Description: Encapsulates the decode stage of the pipeline.
//
//////////////////////////////////////////////////////////////////////////////////

module DecodeStage(
    input clk,
    input mem_clk,
    input [15:0] de_npc,
    input [15:0] de_ir,
    input de_v,
    input v_agex_ld_reg,
    input v_mem_ld_reg,
    input v_sr_ld_reg,
    input [2:0] agex_drid,
    input [2:0] mem_drid,
    input [2:0] sr_drid,
    input [15:0] sr_reg_data,
    input v_agex_ld_cc,
    input v_mem_ld_cc,
    input v_sr_ld_cc,
    input mem_stall,
    output v_de_br_stall,
    output dep_stall,
    output ld_agex,
    output agex_v,
    output [19:0] agex_cc
    );

    wire cs_addr = {de_ir[15:11], de_ir[5]};
    wire [22:0] de_cc;

    ControlStore CS(
        //Inputs
        .clk(mem_clk),
        .addr(cs_addr),
        // Outputs
        .csBits(de_cc)
    );

    wire sr2_id_mux = de_ir[13];
    wire [2:0] sr1 = de_ir[8:6];
    wire [2:0] sr2 = (sr2_id_mux == 0) ? de_ir[2:0] : de_ir[11:9];
    wire [15:0] sr1_data, sr2_data;

    RegFile regFile(
        // Inputs
        .clk(mem_clk),
        .sr1(sr1),
        .sr2(sr2),
        .dr(sr_drid),
        .dataIn(sr_reg_data),
        // Outputs
        .sr1Out(sr1_data),
        .sr2Out(sr2_data)
    );

    wire de_br_stall = de_cc[7];
    assign v_de_br_stall = de_br_stall & de_v;

    wire dr_mux = de_cc[20];
    wire [2:0] dr = (dr_mux == 0) ? de_ir[11:9] : 3'd7; 

    wire sr1_needed = de_cc[22];
    wire sr2_needed = de_cc[21];
    wire br_op = de_cc[10];
    wire sr1_dep_stall = sr1_needed & ((v_agex_ld_reg & agex_drid == sr1) | (v_mem_ld_reg & mem_drid == sr1) | (v_sr_ld_reg & sr_drid == sr1));
    wire sr2_dep_stall = sr2_needed & ((v_agex_ld_reg & agex_drid == sr2) | (v_mem_ld_reg & mem_drid == sr2) | (v_sr_ld_reg & sr_drid == sr2));
    wire br_dep_stall = br_op & (v_agex_ld_cc | v_mem_ld_cc | v_sr_ld_cc);
    assign dep_stall = de_v & (sr1_dep_stall | sr2_dep_stall | br_dep_stall);

    assign ld_agex = ~mem_stall;
    assign agex_v = de_v & ~dep_stall;

    assign agex_cc = de_cc[19:0];

endmodule