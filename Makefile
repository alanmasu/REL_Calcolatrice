# Variabili
VENV = $(shell pwd)/.venv
# Aggiungiamo il venv al PATH: così ogni comando troverà il python e cocotb-config corretti
export PATH := $(VENV)/bin:$(PATH)

.PHONY: venv test clean

# Crea l'ambiente virtuale e installa le dipendenze
$(VENV)/bin/activate:
	python3 -m venv $(VENV)
	$(VENV)/bin/pip install cocotb cocotb-bus pytest

venv: $(VENV)/bin/activate

# Lancia i test
test: venv
	$(MAKE) -C tests

# Pulisce i file di simulazione
clean:
	$(MAKE) -C tests clean
	rm -rf tests/__pycache__