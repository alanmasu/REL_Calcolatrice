# import os
# from pathlib import Path

# from cocotb_tools.runner import get_runner


# def calcolatrice_runner():
#     sim = os.getenv("SIM", "ghdl")
#     proj_path = Path(__file__).resolve().parent

#     # Search for all HDL sources in the "src" directory
#     vhdl_sources = list((proj_path / "../src").rglob("*.vhd"))
#     print(f"Trovati {len(vhdl_sources)} file VHDL per la simulazione.")
#     runner = get_runner(sim)
    
#     ## Test ALU
#     runner.build(
#         sources=vhdl_sources,
#         hdl_toplevel="alu",
#         always=True, # Ricompila sempre
        
#     )
#     runner.test(hdl_toplevel="alu", test_module="test_alu",waves=True)
    
#     ## Test Accumulator
#     runner.build(
#         sources=vhdl_sources,
#         hdl_toplevel="accumulator",
#         always=True, # Ricompila sempre
#     )
#     runner.test(hdl_toplevel="accumulator", test_module="test_accumulator",waves=True)

# if __name__ == "__main__":
#     calcolatrice_runner()
    
import os
import pytest
from pathlib import Path
from cocotb_tools.runner import get_runner

# Percorsi relativi
PROJ_ROOT = Path(__file__).resolve().parent.parent
SRC_DIR = PROJ_ROOT / "src/systemverilog"

# Lista dei moduli da testare
@pytest.mark.parametrize("unit", ["alu", "accumulator"])
def test_regression(unit):
    sim = os.getenv("SIM", "ghdl")
    runner = get_runner(sim)

    sources = list((PROJ_ROOT / "src").rglob("*.vhd"))
    # 1. Compilazione: punta a src/ per i sorgenti SV
    runner.build(
        sources=sources,
        hdl_toplevel=unit,
        build_dir=PROJ_ROOT / "sim_build", # Cartella di build dedicata
        always=True
    )

    # 2. Esecuzione: punta alla cartella test/ per i moduli Python
    runner.test(
        hdl_toplevel=unit,
        test_module=f"test_{unit}", # Cerca test_alu.py o test_fifo.py
        waves=True
    )