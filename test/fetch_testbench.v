//////////////////////////////////////////////////////////////////////////////////
//
// Author: Rutvik Choudhary
// Created: 7/20/19
// Filename: fetch_testbench.v
// Modules: FetchTestbench
// Description: A testbench for the fetch stage module.
//
//////////////////////////////////////////////////////////////////////////////////

`ifndef FETCH_TESTBENCH
`define FETCH_TESTBENCH

`include "../fetch_stage.v"

module FetchTestbench;

reg         dep_stall;
reg         mem_stall;
reg         v_de_br_stall;
reg         v_agex_br_stall;
reg         v_mem_br_stall;
reg         imem_r;
reg   [1:0] mem_pcmux;
wire        ld_pc;
wire [15:0] de_npc;
wire [15:0] de_ir;
wire        de_v;
wire        ld_de;
wire [15:0] new_pc;

FetchStage fetch_module(
    // Inputs
    .pc(16'h3000),
    .dep_stall(dep_stall),
    .mem_stall(mem_stall),
    .v_de_br_stall(v_de_br_stall),
    .v_agex_br_stall(v_agex_br_stall),
    .v_mem_br_stall(v_mem_br_stall),
    .imem_r(imem_r),
    .mem_pcmux(mem_pcmux),
    .target_pc(16'hdead),
    .trap_pc(16'hbeef),
    .instr(16'habcd),
    // Outputs
    .ld_pc(ld_pc),
    .de_npc(de_npc),
    .de_ir(de_ir),
    .de_v(de_v),
    .ld_de(ld_de),
    .new_pc(new_pc)
);

task check_status;
begin
    $write("t=%0t\n", $time);
    $write("----------------\n");
    $write("dep_stall=%b\t\tmem_stall=%b\n", dep_stall, mem_stall);
    $write("v_de_br_stall=%b\t\tv_agex_br_stall=%b\tv_mem_br_stall=%b\n", v_de_br_stall, v_agex_br_stall, v_mem_br_stall);
    $write("imem_r=%b\t\tmem_pcmux=%2b\n", imem_r, mem_pcmux);
    $write("\tld_pc\t=\t%b\n\tde_npc\t=\t0x%h\n\tde_ir\t=\t0x%h\n\tde_v\t=\t%b\n\tld_de\t=\t%b\n\tnew_pc\t=\t0x%h\n", ld_pc, de_npc, de_ir, de_v, ld_de, new_pc);
    $write("\n");
end
endtask

initial begin
    dep_stall = 0;
    mem_stall = 0;
    v_de_br_stall = 0;
    v_agex_br_stall = 0;
    v_mem_br_stall = 0;
    imem_r = 1;
    mem_pcmux = 0;

    #10 check_status;

    mem_pcmux = 1;
    #10 check_status;

    mem_pcmux = 2;
    #10 check_status;

    dep_stall = 1;
    #10 check_status;
    dep_stall = 0;

    mem_stall = 1;
    #10 check_status;
    mem_stall = 0;

    v_de_br_stall = 1;
    #10 check_status;
    v_de_br_stall = 0;

    v_agex_br_stall = 1;
    #10 check_status;
    v_agex_br_stall = 0;

    v_mem_br_stall = 1;
    #10 check_status;
    v_mem_br_stall = 0;

    imem_r = 0;
    #10 check_status;

    #1 $finish;
end

endmodule

`endif // FETCH_TESTBENCH