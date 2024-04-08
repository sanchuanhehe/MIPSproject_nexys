vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/dist_mem_gen_v8_0_14
vlib modelsim_lib/msim/xil_defaultlib

vmap dist_mem_gen_v8_0_14 modelsim_lib/msim/dist_mem_gen_v8_0_14
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work dist_mem_gen_v8_0_14  -incr -mfcu  \
"../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib  -incr -mfcu  \
"../../../../MIPSproject.gen/sources_1/ip/InstrROM/sim/InstrROM.v" \


vlog -work xil_defaultlib \
"glbl.v"

