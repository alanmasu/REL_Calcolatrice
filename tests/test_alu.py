import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def test_alu_operations(dut):
    """Verifica le operazioni base della ALU"""
    
    # Test ADD: 10 + 5 = 15
    dut.d1.value = 10
    dut.d2.value = 5
    dut.add.value = 1
    dut.subtract.value = 0
    dut.multiply.value = 0
    dut.divide.value = 0
    await Timer(1, unit="ns")
    assert dut.q.value == 15, f"Errore ADD: atteso 15, ottenuto {dut.q.value}"
    
    # Test SUB: 15 - 10 = 5
    dut.d1.value = 15
    dut.d2.value = 10
    dut.add.value = 0
    dut.subtract.value = 1
    dut.multiply.value = 0
    dut.divide.value = 0
    await Timer(1, unit="ns")
    assert dut.q.value == 5, f"Errore SUB: atteso 5, ottenuto {dut.q.value}"
    
    # Test MUL: 4 * 3 = 12
    dut.d1.value = 4
    dut.d2.value = 3
    dut.add.value = 0
    dut.subtract.value = 0
    dut.multiply.value = 1
    dut.divide.value = 0
    await Timer(1, unit="ns")
    assert dut.q.value == 12, f"Errore MUL: atteso 12, ottenuto {dut.q.value}"  
    
    # Test DIV: 20 / 4 = 5
    dut.d1.value = 20
    dut.d2.value = 4
    dut.add.value = 0
    dut.subtract.value = 0
    dut.multiply.value = 0
    dut.divide.value = 1
    await Timer(1, unit="ns")
    assert dut.q.value == 5, f"Errore DIV: atteso 5, ottenuto {dut.q.value}"
    