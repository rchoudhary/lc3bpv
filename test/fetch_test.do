##########################################
# 
# Author: Rutvik Choudhary
# Created: 8/11/18
# Description: Tests the fetch stage
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
add wave -position end  sim:/LC3BFetchTest/mem_clk
add wave -position end  sim:/LC3BFetchTest/clk
add wave -divider "Stall Signals"
add wave -position end  sim:/LC3BFetchTest/dep_stall
add wave -position end  sim:/LC3BFetchTest/mem_stall
add wave -position end  sim:/LC3BFetchTest/v_de_br_stall
add wave -position end  sim:/LC3BFetchTest/v_agex_br_stall
add wave -position end  sim:/LC3BFetchTest/v_mem_br_stall
add wave -divider "PC Signals"
add wave -position end  sim:/LC3BFetchTest/PC
add wave -position end  sim:/LC3BFetchTest/new_pc
add wave -position end  sim:/LC3BFetchTest/ld_pc
add wave -position end  sim:/LC3BFetchTest/mem_pcmux
add wave -position end  sim:/LC3BFetchTest/target_pc
add wave -position end  sim:/LC3BFetchTest/trap_pc
add wave -divider "Memory Signals"
add wave -position end  sim:/LC3BFetchTest/imem_r
add wave -position end  sim:/LC3BFetchTest/instr_bus
add wave -divider "DE Latches"
add wave -position end  sim:/LC3BFetchTest/de_npc
add wave -position end  sim:/LC3BFetchTest/de_ir
add wave -position end  sim:/LC3BFetchTest/de_v
add wave -position end  sim:/LC3BFetchTest/ld_de

##########################################
# Initial values
##########################################

force dep_stall 0
force mem_stall 0
force v_de_br_stall 0
force v_agex_br_stall 0
force v_mem_br_stall 0
force mem_pcmux 0
force target_pc 16'hdead
force trap_pc 16'hbeef
force raw_clk 0 0
force raw_clk 0 50, 1 100 -repeat 100

##########################################
# Check that fetch behaves normally
##########################################

run 750

##########################################
# Check that all the stalls work
##########################################

force dep_stall 1
run 200
force dep_stall 0
force mem_stall 1
run 200
force mem_stall 0
force v_de_br_stall 1
run 200
force v_de_br_stall 0
force v_agex_br_stall 1
run 200
force v_agex_br_stall 0
force v_mem_br_stall 1
run 200
force v_mem_br_stall 0
run 200

##########################################
# Check that traps and jumps work
##########################################

force mem_pcmux 1
run 200
force mem_pcmux 2
run 200
force mem_pcmux 0
run 150

##########################################
# Again check that fetch behaves normally
##########################################

run 200