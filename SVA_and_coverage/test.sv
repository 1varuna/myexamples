`include "fifo_env.sv"
program test(fifo_intf intf);
	// declare an env object
	fifo_env env;

	// Instantiate the environment object
	initial begin
		env = new(intf);
		env.run();
	end

endprogram

