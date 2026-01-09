import uvm_pkg::*;
`include "uvm_macros.svh"
class alu_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(alu_scoreboard)
    uvm_analysis_imp#(alu_transaction, alu_scoreboard) item_got;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_got = new("item_got", this);
    endfunction

    // Qui avviene il confronto reale
    function void write(alu_transaction tr);
        logic signed [31:0] expected_q;

        case(tr.op)
            ADD: expected_q = tr.d1 + tr.d2;
            SUB: expected_q = tr.d1 - tr.d2;
            MUL: expected_q = tr.d1 * tr.d2;
            DIV: expected_q = tr.d1 / tr.d2;
        endcase

        if(tr.q !== expected_q) begin
            `uvm_error("ALU_CHECK_FAIL", $sformatf("Errore! d1=%0d, d2=%0d, op=%s | Ottenuto=%0d, Atteso=%0d", 
                        tr.d1, tr.d2, tr.op.name(), tr.q, expected_q))
        end else begin
            `uvm_info("ALU_CHECK_PASS", $sformatf("OK! op=%s, q=%0d", tr.op.name(), tr.q), UVM_LOW)
        end
    endfunction
endclass