# Commands for ModelSim/Questa
all:	compile sim run quit


compile:
	vlog -sv fifo.sv fifo_env.sv test.sv fifo_top.sv

sim:
	vsim work.fifo_top

run:
	run -all

quit:
	quit -sim


