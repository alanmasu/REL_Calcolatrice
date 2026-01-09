# Variabili
VENV = $(shell pwd)/.venv
# Esportiamo il PATH in modo che tutti i sottoprocessi (inclusi i Makefile di Cocotb) usino il venv
export PATH := $(VENV)/bin:$(PATH)
export PYTHONPATH := $(shell pwd):$(PYTHONPATH)

# Configurazione simulazione
VHDL_SOURCES = $(wildcard src/*.vhd)
SIM ?= ghdl

.PHONY: venv test clean clean_sim

# Crea l'ambiente virtuale e installa le dipendenze
$(VENV)/bin/activate:
	python3 -m venv $(VENV)
	$(VENV)/bin/pip install cocotb==2.0.1 cocotb-bus==0.3.0 pytest

venv: $(VENV)/bin/activate

# --- NUOVA REGOLA TEMPLATE ---
# Esempio: 'make test_alu' cerca 'src/alu.vhd' come TOP e 'tests/test_alu.py' come test
test_%: venv
	@echo "Running Cocotb test for: $*"
	@# Troviamo il makefile di cocotb usando il path diretto nel venv
	$(eval COCOTB_MAKEFILE=$(shell $(VENV)/bin/cocotb-config --makefiles)/Makefile.sim)
	@MODULE=tests.test_$* TOPLEVEL=$* VHDL_SOURCES="$(VHDL_SOURCES)" \
	$(MAKE) -f $(COCOTB_MAKEFILE) \
		SIM=$(SIM) \
		SIM_ARGS="--wave=sim_build/$*.ghw" \
		--no-print-directory
	@mkdir -p waveforms
	@if [ -f sim_build/$*.ghw ]; then cp sim_build/$*.ghw waveforms/; fi
	@$(MAKE) -s --no-print-directory clean

# Lancia i regression test (pytest)
test: venv
	@pytest tests/runner.py
	@mkdir -p waveforms
	@cp sim_build/*.ghw waveforms/
	@$(MAKE) --no-print-directory clean

show_%: waveforms/%.ghw waveforms/%.gtkw
	gtkwave waveforms/$*.gtkw &

# Pulisce i file di build
clean:
	@echo "Cleaning up..."
	@rm -rf tests/__pycache__
	@rm -rf sim_build
	@rm -f results.xml

# Pulisce i file salvati ripristinando sim_build e poi cancellando tutto
clean_sim: 
	@mkdir -p sim_build
	@mv waveforms/*.ghw sim_build/ 2>/dev/null || true
	@$(MAKE) -s --no-print-directory clean