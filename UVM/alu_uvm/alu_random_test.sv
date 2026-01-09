import uvm_pkg::*;
`include "uvm_macros.svh"
class alu_random_test extends uvm_test;
    `uvm_component_utils(alu_random_test)

    alu_env env;

    function new(string name = "alu_random_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = alu_env::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        alu_sequence seq;
        seq = alu_sequence::type_id::create("seq");

        phase.raise_objection(this); // Impedisce alla simulazione di chiudersi subito
        
        `uvm_info("TEST", "Avvio della sequenza di test...", UVM_LOW)
        seq.start(env.agent.sequencer); // Collega la sequenza al sequencer dell'agente
        
        phase.drop_objection(this); // Ora la simulazione può terminare
    endtask
endclass