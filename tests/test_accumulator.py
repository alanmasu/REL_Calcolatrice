import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer, NextTimeStep

@cocotb.test()
async def test_acc_basic(dut):
    # Avvia clock a 100MHz
    clock = Clock(dut.clock, 10, unit="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut.reset.value = 0
    dut.acc_init.value = 0
    dut.acc_en.value = 0
    dut.d.value = 0
    await RisingEdge(dut.clock)
    dut.reset.value = 1
    await RisingEdge(dut.clock)

    # Verifica che sia zero dopo reset
    assert dut.q.value == 0, "Errore: Reset non ha azzerato l'uscita"

    # Scrittura dato
    dut.d.value = 0x55
    dut.acc_en.value = 1
    await RisingEdge(dut.clock)
    
    # Aspettiamo un ciclo per vedere il dato stabile in uscita
    dut.acc_en.value = 0
    await RisingEdge(dut.clock)
    await NextTimeStep()
    assert dut.q.value == 0x55, f"Errore: Caricamento fallito, ottenuto {dut.q.value}"
    
    # Ora usiamo il reset sincrono per azzerare
    dut.acc_init.value = 1
    assert dut.q.value == 0x55, f"Errore: 'acc_init' non è sinconro" 
    await RisingEdge(dut.clock)
    await NextTimeStep()
    assert dut.q.value == 0, f"Errore: 'acc_init' non ha azzerato l'uscita, ottenuto {dut.q.value}"
    
    # Carichiamo un altro dato
    dut.d.value = 0xAA
    dut.acc_init.value = 0
    dut.acc_en.value = 1
    await RisingEdge(dut.clock)
    dut.acc_en.value = 0
    await RisingEdge(dut.clock)
    await NextTimeStep()
    assert dut.q.value == 0xAA, f"Errore: Caricamento fallito, ottenuto {dut.q.value}"
    
    # Reset finale asincrono
    dut.reset.value = 0
    await NextTimeStep()
    assert dut.q.value == 0, f"Errore: Reset asincrono non ha azzerato l'uscita, ottenuto {dut.q.value}"