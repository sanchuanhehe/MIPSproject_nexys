vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/dist_mem_gen_v8_0_14
vlib questa_lib/msim/xil_defaultlib

vmap dist_mem_gen_v8_0_14 questa_lib/msim/dist_mem_gen_v8_0_14
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work dist_mem_gen_v8_0_14  -incr -mfcu  \
"../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib  -incr -mfcu  \
"../../../../MIPSproject.gen/sources_1/ip/InstrROM/sim/InstrROM.v" \


vlog -work xil_defaultlib \
"glbl.v"

