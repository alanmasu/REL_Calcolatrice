import uvm_pkg::*;
`include "uvm_macros.svh"
class alu_driver extends uvm_driver #(alu_transaction);
    `uvm_component_utils(alu_driver)
    
    virtual alu_if vif; // Interfaccia virtuale

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Fase di build: recuperiamo l'interfaccia dal database
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "Impossibile trovare l'interfaccia virtuale!")
    endfunction

    // Fase di run: dove avviene l'azione
    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req); // Prende una transazione
            drive_item(req);                 // Esegue lo stimolo
            seq_item_port.item_done();        // Notifica la fine
        end
    endtask

    task drive_item(alu_transaction tr);
        // Reset dei segnali
        vif.add <= 0; vif.subtract <= 0; vif.multiply <= 0; vif.divide <= 0;
        
        // Applica i dati
        vif.d1 <= tr.d1;
        vif.d2 <= tr.d2;
        
        // Attiva il segnale di controllo in base all'operazione
        case(tr.op)
            ADD: vif.add <= 1;
            SUB: vif.subtract <= 1;
            MUL: vif.multiply <= 1;
            DIV: vif.divide <= 1;
        endcase
        
        #10; // Attendiamo 10 unità di tempo per la stabilità del segnale
    endtask
endclass