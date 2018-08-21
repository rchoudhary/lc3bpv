##########################################
# 
# Author: Rutvik Choudhary
# Created: 8/20/18
# Description: Tests the decode stage
#
##########################################


##########################################
# Clear the simulator
##########################################

restart -f -nowave

##########################################
# Add the waves we want to observe
##########################################

add wave -divider "Clocks"
add wave -position end  sim:/DecodeStage/mem_clk
add wave -position end  sim:/DecodeStage/clk
add wave -divider "DE Latches"
add wave -position end  sim:/DecodeStage/de_npc
add wave -position end  sim:/DecodeStage/de_ir
add wave -position end  sim:/DecodeStage/de_v
add wave -divider "AGEX Signals"
add wave -position end  sim:/DecodeStage/v_agex_ld_reg
add wave -position end  sim:/DecodeStage/agex_drid_old
add wave -position end  sim:/DecodeStage/v_agex_ld_cc
add wave -divider "MEM Signals"
add wave -position end  sim:/DecodeStage/v_mem_ld_reg
add wave -position end  sim:/DecodeStage/mem_drid
add wave -position end  sim:/DecodeStage/v_mem_ld_cc
add wave -position end  sim:/DecodeStage/mem_stall
add wave -divider "SR Signals"
add wave -position end  sim:/DecodeStage/v_sr_ld_reg
add wave -position end  sim:/DecodeStage/sr_drid
add wave -position end  sim:/DecodeStage/sr_reg_data
add wave -position end  sim:/DecodeStage/v_sr_ld_cc
add wave -divider "DE CS"
add wave -position end  sim:/DecodeStage/de_cs
add wave -divider "Reg File Signals"
add wave -position end  sim:/DecodeStage/sr2_id_mux
add wave -position end  sim:/DecodeStage/dr_mux
add wave -position end  sim:/DecodeStage/sr1
add wave -position end  sim:/DecodeStage/sr2
add wave -position end  sim:/DecodeStage/dr
add wave -position end  sim:/DecodeStage/sr1_data
add wave -position end  sim:/DecodeStage/sr2_data
add wave -divider "Stall Signals"
add wave -position end  sim:/DecodeStage/sr1_needed
add wave -position end  sim:/DecodeStage/sr2_needed
add wave -position end  sim:/DecodeStage/br_op
add wave -position end  sim:/DecodeStage/sr1_dep_stall
add wave -position end  sim:/DecodeStage/sr2_dep_stall
add wave -position end  sim:/DecodeStage/br_dep_stall
add wave -divider "AGEX Latch Output"
add wave -position end  sim:/DecodeStage/ld_agex
add wave -position end  sim:/DecodeStage/agex_sr1
add wave -position end  sim:/DecodeStage/agex_sr2
add wave -position end  sim:/DecodeStage/agex_drid_new
add wave -position end  sim:/DecodeStage/agex_cs
add wave -position end  sim:/DecodeStage/agex_v

##########################################
# Initialize the clocks
##########################################

force mem_clk 0 0
force mem_clk 0 50, 1 100 -repeat 100
force clk 0 0, 0 50
force clk 1 100, 0 200 -repeat 200

##########################################
# Initial run
##########################################

force de_npc 16'h3000

# ADD R2, R3, R4
force de_ir 16'h14C4

force de_v 1
force v_agex_ld_reg 0
force v_mem_ld_reg 0
force v_sr_ld_reg 0
force agex_drid_old 0
force mem_drid 0
force sr_drid 0
force sr_reg_data 16'hFFFF
force v_agex_ld_cc 0
force v_mem_ld_cc 0
force v_sr_ld_cc 0
force mem_stall 0

run 250

##########################################
# Testing dep stall caused by AGEX stage
##########################################

force de_npc 16'h3000

# ADD R2, R3, R4
force de_ir 16'h11C2

force de_v 1
force v_agex_ld_reg 1
force v_mem_ld_reg 0
force v_sr_ld_reg 0
force agex_drid_old 3
force mem_drid 0
force sr_drid 0
force sr_reg_data 16'hFFFF
force v_agex_ld_cc 0
force v_mem_ld_cc 0
force v_sr_ld_cc 0
force mem_stall 0

run 200

##########################################
# Testing dep stall caused by MEM stage
##########################################

force de_npc 16'h3000

# ADD R2, R3, R4
force de_ir 16'h1DA5

force de_v 1
force v_agex_ld_reg 0
force v_mem_ld_reg 1
force v_sr_ld_reg 0
force agex_drid_old 0
force mem_drid 4
force sr_drid 0
force sr_reg_data 16'hFFFF
force v_agex_ld_cc 0
force v_mem_ld_cc 0
force v_sr_ld_cc 0
force mem_stall 0

run 200

##########################################
# Testing dep stall caused by SR stage
##########################################

force de_npc 16'h3000

# ADD R2, R3, R4
force de_ir 16'h13C4

force de_v 1
force v_agex_ld_reg 0
force v_mem_ld_reg 0
force v_sr_ld_reg 1
force agex_drid_old 0
force mem_drid 0
force sr_drid 4
force sr_reg_data 16'hFFFF
force v_agex_ld_cc 0
force v_mem_ld_cc 0
force v_sr_ld_cc 0
force mem_stall 0

run 200


##########################################
# Testing NO br stall from mem stage
##########################################

force de_npc 16'h3000

# ADD R2, R3, R4
force de_ir 16'h1C84

force de_v 1
force v_agex_ld_reg 0
force v_mem_ld_reg 0
force v_sr_ld_reg 0
force agex_drid_old 0
force mem_drid 0
force sr_drid 0
force sr_reg_data 16'hFFFF
force v_agex_ld_cc 0
force v_mem_ld_cc 1
force v_sr_ld_cc 0
force mem_stall 0

run 200

##########################################
# Testing br stall from mem stage
##########################################

force de_npc 16'h3000

# BR
force de_ir 16'h0000

force de_v 1
force v_agex_ld_reg 0
force v_mem_ld_reg 0
force v_sr_ld_reg 0
force agex_drid_old 0
force mem_drid 0
force sr_drid 0
force sr_reg_data 16'hFFFF
force v_agex_ld_cc 0
force v_mem_ld_cc 1
force v_sr_ld_cc 0
force mem_stall 0

run 200


##########################################
# Testing mem stall
##########################################

force de_npc 16'h3000

# BR
force de_ir 16'h0000

force de_v 1
force v_agex_ld_reg 0
force v_mem_ld_reg 0
force v_sr_ld_reg 0
force agex_drid_old 0
force mem_drid 0
force sr_drid 0
force sr_reg_data 16'hFFFF
force v_agex_ld_cc 0
force v_mem_ld_cc 0
force v_sr_ld_cc 0
force mem_stall 1

run 200