//////////////////////////////////////////////////////////////////////////////////
//
// Author: Rutvik Choudhary
// Created: 7/23/19
// Filename: decode_testbench.v
// Modules: DecodeTestbench
// Description: A testbench for the decode stage module. Prints data in CSV format.
//
//////////////////////////////////////////////////////////////////////////////////

`ifndef DECODE_TESTBENCH
`define DECODE_TESTBENCH

`include "../component/control_store.v"
`include "../component/reg_file.v"
`include "../decode_stage.v"

module DecodeTestbench;

reg         clk;
reg [15:0]  de_ir;
reg         de_v;
reg         v_agex_ld_reg;
reg         v_mem_ld_reg;
reg         v_sr_ld_reg;
reg  [2:0]  agex_drid_old;
reg  [2:0]  mem_drid;
reg  [2:0]  sr_drid;
reg [15:0]  sr_reg_data;
reg         v_agex_ld_cc;
reg         v_mem_ld_cc;
reg         v_sr_ld_cc;
reg         mem_stall;
wire        v_de_br_stall;
wire        dep_stall;
wire        ld_agex;
wire [15:0] agex_sr1;
wire [15:0] agex_sr2;
wire  [2:0] agex_drid_new;
wire [19:0] agex_cs;
wire        agex_v;


DecodeStage decode_module(
    // Inputs
    .clk(clk),
    .de_npc(16'h3002),
    .de_ir(de_ir),
    .de_v(de_v),
    .v_agex_ld_reg(v_agex_ld_reg),
    .v_mem_ld_reg(v_mem_ld_reg),
    .v_sr_ld_reg(v_sr_ld_reg),
    .agex_drid_old(agex_drid_old),
    .mem_drid(mem_drid),
    .sr_drid(sr_drid),
    .sr_reg_data(sr_reg_data),
    .v_agex_ld_cc(v_agex_ld_cc),
    .v_mem_ld_cc(v_mem_ld_cc),
    .v_sr_ld_cc(v_sr_ld_cc),
    .mem_stall(mem_stall),
    // Outputs
    .v_de_br_stall(v_de_br_stall),
    .dep_stall(dep_stall),
    .ld_agex(ld_agex),
    .agex_sr1(agex_sr1),
    .agex_sr2(agex_sr2),
    .agex_drid_new(agex_drid_new),
    .agex_cs(agex_cs),
    .agex_v(agex_v)
);

task check_status;
integer i;
begin
    $write("t=%0t\n", $time);
    $write("----------------\n");
    $write("de_ir=0x%4h\tde_v=%b\t\tv_agex_ld_reg=%b\tv_mem_ld_reg=%b\tv_sr_ld_reg=%b\n", de_ir, de_v, v_agex_ld_reg, v_mem_ld_reg, v_sr_ld_reg);
    $write("agex_drid_old=%1d\tmem_drid=%1d\tsr_drid=%1d\tsr_reg_data=0x%4h\n", agex_drid_old, mem_drid, sr_drid, sr_reg_data);
    $write("v_agex_ld_cc=%b\tv_mem_ld_cc=%b\tv_sr_ld_cc=%b\tmem_stall=%b\t\n", v_agex_ld_cc, v_mem_ld_cc, v_sr_ld_cc, mem_stall);
    $write("sr1=%1d\t\tsr2=%1d\n", decode_module.sr1, decode_module.sr2);
    $write("sr2_id_mux=%b\tde_ir[2:0]=%3b\tde_ir[11:9]=%3b\n", decode_module.sr2_id_mux, de_ir[2:0], de_ir[11:9]);
    $write("\n");
    for (i = 0; i < 8; i = i + 1) begin
        $write("\tR%1d = 0x%H = %-d\n", i, decode_module.reg_file.storage[i], decode_module.reg_file.storage[i]);
    end
    $write("\n");
    $write("\tv_de_br_stall\t=\t%b\n", v_de_br_stall);
    $write("\tdep_stall\t=\t%b\n", dep_stall);
    $write("\tld_agex\t\t=\t%b\n", ld_agex);
    $write("\tagex_sr1\t=\t0x%4h\n", agex_sr1);
    $write("\tagex_sr2\t=\t0x%4h\n", agex_sr2);
    $write("\tagex_drid_new\t=\t%1d\n", agex_drid_new);
    $write("\tagex_cs\t\t=\t0x%5h\n", agex_cs);
    $write("\tagex_v\t\t=\t%b\n", agex_v);
    $write("\n");
    $write("\n");

end
endtask

initial begin
    clk = 0;
    de_ir = 16'h1b0f;
    de_v = 1;
    v_agex_ld_reg = 0;
    v_mem_ld_reg = 0;
    v_sr_ld_reg = 0;
    agex_drid_old = 0;
    mem_drid = 0;
    sr_drid = 0;
    sr_reg_data = 16'h2319;
    v_agex_ld_cc = 0;
    v_mem_ld_cc = 0;
    v_sr_ld_cc = 0;
    mem_stall = 0;

    $write("\ninitial state\n\n");

    #1 check_status;

    $write("check normal register store\n\n");

    v_sr_ld_reg = 1;
    sr_drid = 3;
    #20 check_status;
    v_sr_ld_reg = 0;

    #1 $finish;
end

always begin
    #20 clk = !clk;
end

endmodule

`endif // DECODE_TESTBENCH
