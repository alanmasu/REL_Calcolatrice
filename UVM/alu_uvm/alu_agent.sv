import uvm_pkg::*;
`include "uvm_macros.svh"
class alu_agent extends uvm_agent;
    `uvm_component_utils(alu_agent)

    alu_driver    driver;
    alu_monitor   monitor;
    uvm_sequencer#(alu_transaction) sequencer;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = alu_monitor::type_id::create("monitor", this);
        
        // Se l'agente è attivo, creiamo anche driver e sequencer
        if(get_is_active() == UVM_ACTIVE) begin
            driver = alu_driver::type_id::create("driver", this);
            sequencer = uvm_sequencer#(alu_transaction)::type_id::create("sequencer", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        if(get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
endclass