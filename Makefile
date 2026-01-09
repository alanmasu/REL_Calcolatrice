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
# test: venv
# 	pytest tests/runner.py
# 	mkdir -p waveforms
# 	cp sim_build/*.ghw waveforms/
# 	make clean
test: venv
	@pytest tests/runner.py
	@mkdir -p waveforms
	@cp sim_build/*.ghw waveforms/
	@$(MAKE) --no-print-directory clean

show_%: waveforms/%.ghw waveforms/%.gtkw
	gtkwave waveforms/$*.gtkw &

# Pulisce i file di buld
clean:
	@echo "Cleaning up..."
	@rm -rf tests/__pycache__
	@rm -rf sim_build

# Pulisce i
clean_sim: 
	mkdir -p sim_build
	mv waveforms/*.ghw sim_build/
	make clean