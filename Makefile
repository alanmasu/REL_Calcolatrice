# Variabili
VENV = .venv
PYTHON = $(VENV)/bin/python3
PIP = $(VENV)/bin/pip

.PHONY: venv test clean

# Crea l'ambiente virtuale e installa le dipendenze
venv:
	python3 -m venv $(VENV)
	$(PIP) install cocotb cocotb-bus pytest

# Lancia i test entrando nella cartella tests
test: venv
	source $(VENV)/bin/activate && $(MAKE) -C tests

# Pulisce i file di simulazione
clean:
	$(MAKE) -C tests clean
	rm -rf tests/__pycache__