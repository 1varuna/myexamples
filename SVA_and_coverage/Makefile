# Commands for ModelSim/Questa
all:	compile sim run quit


compile:
	vlog -sv fifo.sv fifo_intf.sv fifo_top.sv	
#vlog -sv fifo.sv fifo_intf.sv fifo_env.sv test.sv fifo_top.sv

sim:
	vsim -voptargs=+acc work.fifo_top -novopt

run:
	run -all

quit:
	quit -sim


