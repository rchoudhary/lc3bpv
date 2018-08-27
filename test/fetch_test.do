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
add wave -position end  sim:/FetchTestBench/mem_clk
add wave -position end  sim:/FetchTestBench/clk
add wave -divider "Stall Signals"
add wave -position end  sim:/FetchTestBench/dep_stall
add wave -position end  sim:/FetchTestBench/mem_stall
add wave -position end  sim:/FetchTestBench/v_de_br_stall
add wave -position end  sim:/FetchTestBench/v_agex_br_stall
add wave -position end  sim:/FetchTestBench/v_mem_br_stall
add wave -divider "PC Signals"
add wave -position end  sim:/FetchTestBench/PC
add wave -position end  sim:/FetchTestBench/new_pc
add wave -position end  sim:/FetchTestBench/ld_pc
add wave -position end  sim:/FetchTestBench/mem_pcmux
add wave -position end  sim:/FetchTestBench/target_pc
add wave -position end  sim:/FetchTestBench/trap_pc
add wave -divider "Memory Signals"
add wave -position end  sim:/FetchTestBench/imem_r
add wave -position end  sim:/FetchTestBench/instr_bus
add wave -divider "DE Latches"
add wave -position end  sim:/FetchTestBench/de_npc
add wave -position end  sim:/FetchTestBench/de_ir
add wave -position end  sim:/FetchTestBench/de_v
add wave -position end  sim:/FetchTestBench/ld_de

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