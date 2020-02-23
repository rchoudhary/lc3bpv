##########################################
#
# Author: Rutvik Choudhary
# Created: 8/27/18
# Description: Tests the LC3BP pipeline
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
add wave -position end  sim:/LC3BPTestBench/mem_clk
add wave -position end  sim:/LC3BPTestBench/clk
add wave -divider "Registers"
add wave -position end  sim:/LC3BPTestBench/R0
add wave -position end  sim:/LC3BPTestBench/R1
add wave -position end  sim:/LC3BPTestBench/R2
add wave -position end  sim:/LC3BPTestBench/R3
add wave -position end  sim:/LC3BPTestBench/R4
add wave -position end  sim:/LC3BPTestBench/R5
add wave -position end  sim:/LC3BPTestBench/R6
add wave -position end  sim:/LC3BPTestBench/R7
add wave -divider "Fetch Stage Latches"
add wave -position end  sim:/LC3BPTestBench/PC
add wave -divider "Decode Stage Latches"
add wave -position end  sim:/LC3BPTestBench/DE_NPC
add wave -position end  sim:/LC3BPTestBench/DE_IR
add wave -position end  sim:/LC3BPTestBench/DE_V
add wave -divider "AGEX Stage Latches"
add wave -position end  sim:/LC3BPTestBench/AGEX_NPC
add wave -position end  sim:/LC3BPTestBench/AGEX_CS
add wave -position end  sim:/LC3BPTestBench/AGEX_IR
add wave -position end  sim:/LC3BPTestBench/AGEX_SR1
add wave -position end  sim:/LC3BPTestBench/AGEX_SR2
add wave -position end  sim:/LC3BPTestBench/AGEX_CC
add wave -position end  sim:/LC3BPTestBench/AGEX_DRID
add wave -position end  sim:/LC3BPTestBench/AGEX_V
add wave -divider "Inputs from AGEX Stage"
add wave -position end  sim:/LC3BPTestBench/v_agex_br_stall
add wave -position end  sim:/LC3BPTestBench/v_agex_ld_reg
add wave -position end  sim:/LC3BPTestBench/v_agex_ld_cc
add wave -divider "Inputs from Memory Stage"
add wave -position end  sim:/LC3BPTestBench/mem_stall
add wave -position end  sim:/LC3BPTestBench/v_mem_br_stall
add wave -position end  sim:/LC3BPTestBench/mem_pcmux
add wave -position end  sim:/LC3BPTestBench/v_mem_ld_reg
add wave -position end  sim:/LC3BPTestBench/mem_drid
add wave -divider "Inputs from SR Stage"
add wave -position end  sim:/LC3BPTestBench/v_sr_ld_cc
add wave -position end  sim:/LC3BPTestBench/v_sr_ld_reg
add wave -position end  sim:/LC3BPTestBench/sr_drid
add wave -position end  sim:/LC3BPTestBench/sr_reg_data
add wave -position end  sim:/LC3BPTestBench/v_sr_ld_cc
add wave -position end  sim:/LC3BPTestBench/sr_cc_data

##########################################
# Initial values
##########################################

force v_agex_br_stall 0
force v_agex_ld_reg 0
force v_agex_ld_cc 0

force mem_stall 0
force v_mem_br_stall 0
force mem_pcmux 0
force v_mem_ld_reg 0
force mem_drid 0

force v_sr_ld_cc 0
force v_sr_ld_reg 0
force sr_drid 0
force sr_reg_data 0
force v_sr_ld_cc 0
force sr_cc_data 0

# TODO: Implement actual tests!

run 500