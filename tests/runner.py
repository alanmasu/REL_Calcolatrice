import os
from pathlib import Path

from cocotb_tools.runner import get_runner


def calcolatrice_runner():
    sim = os.getenv("SIM", "ghdl")
    proj_path = Path(__file__).resolve().parent

    # Search for all HDL sources in the "src" directory
    vhdl_sources = list((proj_path / "../src").rglob("*.vhd"))
    print(f"Trovati {len(vhdl_sources)} file VHDL per la simulazione.")
    runner = get_runner(sim)
    
    ## Test ALU
    runner.build(
        sources=vhdl_sources,
        hdl_toplevel="alu",
        always=True, # Ricompila sempre
        
    )
    runner.test(hdl_toplevel="alu", test_module="test_alu",waves=True)
    
    ## Test Accumulator
    runner.build(
        sources=vhdl_sources,
        hdl_toplevel="accumulator",
        always=True, # Ricompila sempre
    )
    runner.test(hdl_toplevel="accumulator", test_module="test_accumulator",waves=True)

if __name__ == "__main__":
    calcolatrice_runner()