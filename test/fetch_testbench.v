`ifndef FETCH_TESTBENCH
`define FETCH_TESTBENCH

`include "../fetch_stage.v"

module FetchTestbench;

reg  [15:0] pc;
reg         dep_stall;
reg         mem_stall;
reg         v_de_br_stall;
reg         v_agex_br_stall;
reg         v_mem_br_stall;
reg         imem_r;
reg   [1:0] mem_pcmux;
reg  [15:0] target_pc;
reg  [15:0] trap_pc;
reg  [15:0] instr;
wire        ld_pc;
wire [15:0] de_npc;
wire [15:0] de_ir;
wire        de_v;
wire        ld_de;
wire [15:0] new_pc;

FetchStage fetch_module(
    .pc(pc),
    .dep_stall(dep_stall),
    .mem_stall(mem_stall),
    .v_de_br_stall(v_de_br_stall),
    .v_agex_br_stall(v_agex_br_stall),
    .v_mem_br_stall(v_mem_br_stall),
    .imem_r(imem_r),
    .mem_pcmux(mem_pcmux),
    .target_pc(target_pc),
    .trap_pc(trap_pc),
    .instr(instr),
    .ld_pc(ld_pc),
    .de_npc(de_npc),
    .de_ir(de_ir),
    .de_v(de_v),
    .ld_de(ld_de),
    .new_pc(new_pc)
);

task check_status;
begin
    $write("%d,%b,%b,%b,%b,%b,%b,%2b,,", $time, dep_stall, mem_stall, v_de_br_stall, v_agex_br_stall, v_mem_br_stall, imem_r, mem_pcmux);
    $write("%b,%h,%h,%b,%b,%h\n", ld_pc, de_npc, de_ir, de_v, ld_de, new_pc);
end
endtask

initial begin
    pc = 16'h3000;
    dep_stall = 0;
    mem_stall = 0;
    v_de_br_stall = 0;
    v_agex_br_stall = 0;
    v_mem_br_stall = 0;
    imem_r = 1;
    mem_pcmux = 0;
    target_pc = 16'hdead;
    trap_pc = 16'hbeef;
    instr = 16'habcd;

    $write("%s,%s,%s,%s,%s,%s,%s,%s,,", "time", "dep_stall", "mem_stall", "v_de_br_stall", "v_agex_br_stall", "v_mem_br_stall", "imem_r","mem_pcmux");
    $write("%s,%s,%s,%s,%s,%s\n", "ld_pc", "de_npc", "de_ir", "de_v", "ld_de", "new_pc");
end

always begin
    #10 check_status();

    mem_pcmux = 1;
    #10 check_status();

    mem_pcmux = 2;
    #10 check_status();

    dep_stall = 1;
    #10 check_status();

    dep_stall = 0;
    mem_stall = 1;
    #10 check_status();

    mem_stall = 0;
    v_de_br_stall = 1;
    #10 check_status();

    v_de_br_stall = 0;
    v_agex_br_stall = 1;
    #10 check_status();

    v_agex_br_stall = 0;
    v_mem_br_stall = 1;
    #10 check_status();

    v_mem_br_stall = 0;
    imem_r = 0;
    #10 check_status();

    #100 $finish;
end

endmodule

`endif // FETCH_TESTBENCH