import uvm_pkg::*;
`include "uvm_macros.svh"
class alu_env extends uvm_env;
    `uvm_component_utils(alu_env)

    alu_agent      agent;
    alu_scoreboard scoreboard;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = alu_agent::type_id::create("agent", this);
        scoreboard = alu_scoreboard::type_id::create("scoreboard", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        // Collega l'uscita del monitor all'ingresso dello scoreboard
        agent.monitor.item_collected_port.connect(scoreboard.item_got);
    endfunction
endclass