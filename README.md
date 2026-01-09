# REL Calcolatrice
This is a project based on laboratory acticities of a Logic Network course at UniTN.

This repository is a experimental project designed to explore and implement a **modern philosophy of hardware testing**. Instead of relying on traditional RTL-only testbenches, this project adopts a "Hardware-as-Code" approach, bridging the gap between digital design and software engineering best practices.

## 🎯 The Core Objective: A Paradigm Shift
The primary goal of this project is to experiment with a **new testing philosophy** that moves away from legacy verification methods. We are testing the feasibility and advantages of:

* **Software-Driven Verification:** Using **Python** (via cocotb) instead of Verilog/VHDL for testbenches, allowing us to use powerful libraries, object-oriented patterns, and high-level abstractions.
* **Agile Hardware Development:** Applying **Continuous Integration (CI)** to hardware. Every logic gate change is automatically validated, just like modern software microservices.
* **Automation over Manual Inspection:** Moving from manual waveform analysis (GTKWave) to automated, self-checking test suites that run in the cloud.

---

## 🏗️ System Architecture

### 1. The Design Under Test (DUT)
A digital logic module written in **VHDL**. (e.g., a simple adder or a counter).

### 2. The Verification Environment (cocotb)
The testbench is written in **Python**. Cocotb acts as a bridge between the Python interpreter and the HDL simulator (like Icarus Verilog). 
* **Async/Await:** Uses Python coroutines to handle simulation time.
* **Assertions:** Uses standard Python logic to verify that the DUT outputs match the expected results.

### 3. CI Pipeline (GitHub Actions)
The automation is handled by a workflow file (`.github/workflows/ci.yml`). Whenever code is pushed:
1.  A **Ubuntu runner** is initialized.
2.  **ghdl** and **Python** dependencies are installed.
3.  The simulation runs via a **Makefile**.
4.  The workflow returns a ✅ (Success) or ❌ (Failure) based on the test results.

---

## 🚀 Getting Started

### Prerequisites
To run this project locally, you will need:
* **Python 3.8+**
* **ghdl** (Simulator)
* **GTKWave** (Optional, for waveform viewing)
* **Make**

### Local Execution
1.  **Install ghdl & GTKWave**

    * [Here](http://ghdl.free.fr/site/pmwiki.php?n=Main.Installation) information on how to get GHDL.
    * [Here](https://gtkwave.sourceforge.net/) information on how to get GTKWave. (optional)
  
2.  **Clone the repo:**
    ```bash
    git clone https://github.com/alanmasu/REL-Calcolatrice.git
    cd REL-Calcolatrice
    ```
3.  **Run the regression test:**
    ```bash
    make test
    ```
4.  **View Waveforms (Optional):**
    If you want to inspect the waveforms, you can open the generated waveform file with GTKWave:
    ```bash
    make show_<module_name>
    ```
5. **Clean Up:**
    To clean up the build artifacts, run:
    ```bash
    make clean
    ```
    for removing also the waveform files, run:
    ```bash
    make clean_sim
    ```

---

## 📁 Project Structure
* `.github/workflows/` : Configuration for the automated CI pipeline.
* `src/` : Contains the `.vhd` (VHDL) source files.
* `tests/` : Contains the `.py` (cocotb) testbench files.
* `waveforms/`: Contains waveform configurations for GTKWave and after-simulation waveform dumps.
* `Makefile` : The build script that configures the simulator and starts cocotb.

### 🛠️ Adding modules
To add a new module to the project:
1. Place your VHDL source files in the `src/` directory as `<module_name>.vhd` files.
2. Create a corresponding Python testbench in the `tests/` directory, following the naming convention `test_<module_name>.py`.
3. Update the `tests/runner.py` file to include your new module in the `@pytest.mark.parametrize` decorator.
4. Run `make test_<module_name>` to build and test your new module.
5. Run `make show_<module_name>` to view the waveform if needed. (Optional)

---

## 📊 CI Integration
The status of the latest verification run is displayed on the GitHub repository page. This ensures that the master branch always contains **verified and working RTL code**.
