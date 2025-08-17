# Verilog
Verilog open sources projects
# Simple 8-Bit Verilog CPU

This repository contains the Verilog source code for a simple 8-bit, single-cycle CPU. It's designed for educational purposes to demonstrate the fundamental components and datapath of a basic processor.

## 🏛️ Architecture

This CPU implements a **Harvard architecture**, meaning it has separate memory for instructions and data. It's a **single-cycle** processor, where each instruction is executed in one clock cycle.

The core components are:
* **`simple_cpu.v`**: The top-level module that connects all components.
* **`alu.v`**: The Arithmetic Logic Unit, which handles calculations.
* **`register_file.v`**: A file with four 8-bit general-purpose registers.
* **`tb_simple_cpu.v`**: The testbench for simulating and verifying the CPU's functionality.



## 📝 Instruction Set Architecture (ISA)

The CPU uses a 16-bit fixed-length instruction format.

**Format:** `[15:12] Opcode | [11:10] Rd | [9:8] Rs | [7:0] Immediate/Address`

| Instruction | Opcode | Assembly Example      | Description                               |
| :---------- | :----: | :-------------------- | :---------------------------------------- |
| **HALT** | `0000` | `HALT`                | Stops the CPU clock.                      |
| **LOAD** | `0001` | `LOAD R1, [20]`       | Loads data from memory into a register.   |
| **STORE** | `0010` | `STORE R2, [30]`      | Stores data from a register into memory.  |
| **ADD** | `0011` | `ADD R3, R1`          | $R_d = R_d + R_s$                         |
| **SUB** | `0100` | `SUB R1, R2`          | $R_d = R_d - R_s$                         |
| **ADDI** | `0101` | `ADDI R1, 5`          | $R_d = R_d + \text{Immediate}$            |
| **JMP** | `0110` | `JMP 10`              | Jumps to a new instruction address.       |
| **AND** | `0111` | `AND R1, R2`          | $R_d = R_d \& R_s$                        |


## 🚀 How to Simulate

You can use a free Verilog simulator like [Icarus Verilog](http://iverilog.icarus.com/) to run this project.

1.  **Prerequisites:** Make sure you have Icarus Verilog and a waveform viewer like GTKWave installed.

2.  **Compile the Verilog files:**
    ```sh
    iverilog -o cpu_sim alu.v register_file.v simple_cpu.v tb_simple_cpu.v
    ```

3.  **Run the simulation:**
    ```sh
    vvp cpu_sim
    ```

### Expected Output

The simulation will print the state of the CPU's registers and memory at each clock cycle. You should see the following output, demonstrating the successful execution of the sample program embedded in `simple_cpu.v`.
