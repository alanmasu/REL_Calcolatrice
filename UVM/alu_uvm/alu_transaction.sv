import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum {ADD, SUB, MUL, DIV} alu_op_t;
class alu_transaction extends uvm_sequence_item;
    `uvm_object_utils(alu_transaction)
    
    rand logic signed [31:0] d1, d2;
    rand alu_op_t op; // Usa il nuovo tipo
    logic signed [31:0] q;

    // Constraint per evitare divisione per zero
    constraint c_div_zero {
        op == DIV -> d2 != 0;
    }

    function new(string name = "alu_transaction");
        super.new(name);
    endfunction
endclass