import uvm_pkg::*;
`include "uvm_macros.svh"
class alu_monitor extends uvm_monitor;
    `uvm_component_utils(alu_monitor)
    
    virtual alu_if vif;
    uvm_analysis_port #(alu_transaction) item_collected_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
            `uvm_fatal("MON", "Impossibile trovare l'interfaccia virtuale!")
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            alu_transaction tr;
            tr = alu_transaction::type_id::create("tr");
            
            #10; // Campioniamo dopo che il segnale si è stabilizzato
            
            tr.d1 = vif.d1;
            tr.d2 = vif.d2;
            tr.q  = vif.q;
            
            // Deduciamo l'operazione dai segnali attivi
            if (vif.add)      tr.op = ADD;
            else if (vif.subtract) tr.op = SUB;
            else if (vif.multiply) tr.op = MUL;
            else if (vif.divide)   tr.op = DIV;
            
            item_collected_port.write(tr); // Manda allo scoreboard
        end
    endtask
endclass