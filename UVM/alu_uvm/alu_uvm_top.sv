module alu_uvm_top;
    // 1. IMPORTAZIONE UVM E PACKAGE
    import uvm_pkg::*;
    import alu_uvm_pkg::*;
    `include "uvm_macros.svh"

    // 2. ISTANZA DELL'INTERFACCIA
    // L'interfaccia è un "bundle" di fili. Invece di collegare add, subtract, d1, d2 
    // singolarmente ovunque, li raggruppiamo qui.
    alu_if #(32) vif();

    // 3. ISTANZA DEL DUT (Device Under Test) - IL TUO VHDL
    // Qui colleghiamo i segnali dell'interfaccia alle porte della tua entità VHDL.
    // Il simulatore (Xcelium o Vivado) gestisce il mix tra i due linguaggi.
    alu #(32) dut (
        .add(vif.add), 
        .subtract(vif.subtract), 
        .multiply(vif.multiply), 
        .divide(vif.divide),
        .d1(vif.d1), 
        .d2(vif.d2), 
        .q(vif.q)
    );

    // 4. IL BLOCCO INITIAL
    initial begin
        // A. Configurazione del Database (Il "Postino" di UVM)
        // Questa è la riga più importante. UVM non permette di passare l'interfaccia 
        // tramite porte fisiche alle classi. Usiamo quindi il 'config_db'.
        // "Setta nel database un'interfaccia virtuale chiamata 'vif' 
        // rendendola visibile a tutti i componenti (*)."
        uvm_config_db#(virtual alu_if)::set(null, "*", "vif", vif);

        // B. Avvio del Test
        // run_test() è una funzione magica di UVM che:
        //  - Legge il parametro da riga di comando +UVM_TESTNAME
        //  - Crea un'istanza di quel test
        //  - Fa partire le fasi di build, connect e run.
        run_test("alu_random_test");
    end
endmodule