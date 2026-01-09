exec xvhdl -f alu/alu_SRC_list.f -L uvm;
exec xvlog -sv -f alu/alu_UVM_list.f -L uvm; 
exec xelab alu_uvm_top -relax -s top -timescale 1ns/1ps ;  
exec xsim top  -testplusarg UVM_VERBOSITY=UVM_LOW -runall