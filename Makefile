# Variabili
# MAKEFLAGS += --silent --no-print-directory
VENV = $(shell pwd)/.venv
# Aggiungiamo il venv al PATH: così ogni comando troverà il python e cocotb-config corretti
export PATH := $(VENV)/bin:$(PATH)

.PHONY: venv test clean

# Crea l'ambiente virtuale e installa le dipendenze
$(VENV)/bin/activate:
	python3 -m venv $(VENV)
	$(VENV)/bin/pip install cocotb==2.0.1 cocotb-bus==0.3.0 pytest

venv: $(VENV)/bin/activate

# Lancia i test
test: venv
	python3 $(PWD)/tests/runner.py
	mkdir -p waveforms
	cp sim_build/*.ghw waveforms/
	make clean

show_%: waveforms/%.ghw waveforms/%.gtkw
	gtkwave waveforms/$*.gtkw &

test_uvm:
	@(cd run/alu && vivado -mode batch -source run.tcl)
	@cat run/alu/xsim.log

# Pulisce i file di buld
clean:
	@echo "Cleaning up..."
	rm -rf tests/__pycache__
	rm -rf sim_build

# Pulisce i
clean_sim: 
	mkdir -p sim_build
	mv waveforms/*.ghw sim_build/
	make clean

clean_uvm:
	@echo "Cleaning up UVM build files..."
	rm -rf run/alu/*.log
	rm -rf run/alu/*.jou
	rm -rf run/alu/*.pb
	rm -rf run/alu/xsim.dir