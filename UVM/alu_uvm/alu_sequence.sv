import uvm_pkg::*;
`include "uvm_macros.svh"
class alu_sequence extends uvm_sequence#(alu_transaction);
    `uvm_object_utils(alu_sequence)

    function new(string name = "alu_sequence");
        super.new(name);
    endfunction

    // Il compito principale della sequence è nel task body
    virtual task body();
        repeat(50) begin // Facciamo 50 operazioni casuali
            req = alu_transaction::type_id::create("req");
            
            start_item(req);       // Aspetta che il sequencer sia pronto
            if (!req.randomize())  // Genera d1, d2 e op casuali
                `uvm_error("SEQ", "Randomizzazione fallita!")
            finish_item(req);      // Invia al driver e aspetta che finisca
            
            `uvm_info("SEQ", $sformatf("Inviata operazione: %s con d1=%0d, d2=%0d", 
                      req.op.name(), req.d1, req.d2), UVM_HIGH)
        end
    endtask
endclass