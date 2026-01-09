exec xvhdl -f alu_SRC_list.f -L uvm;
exec xvlog -sv -f alu_UVM_list.f -L uvm; 
exec xelab alu_uvm_top -relax -s top -timescale 1ns/1ps ;  
exec xsim top -testplusarg UVM_TESTNAME=alu_random_test -testplusarg UVM_VERBOSITY=UVM_LOW -runall