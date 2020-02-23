# LC3BPV
This is a **V**erilog implementation of the **P**ipelined, **B**yte-Addressable **LC3** processor.

(In the code and documentation, the processor is just referred to as the LC3BP)

In our computer architecture class our final lab was to emulate the specified microarchitecture of a pipelined version of the LC3-B processor in C. This is the same implementation, but in Verilog.

The pipeline is a simple 5-stage pipeline:

1. Fetch (F)
2. Decode (DE)
3. Address Generation and Execution (AGEX)
4. Memory (MEM)
5. Store Result (SR)

Currently the project is just being simulated, but the goal is to have the project be synthesized and implemented on the [Basys 3](https://store.digilentinc.com/basys-3-artix-7-fpga-trainer-board-recommended-for-introductory-users/) board which contains a Xilinx Artix-7 FPGA (part no. [XC7A35T-1CPG236C](https://www.digikey.com/product-detail/en/xilinx-inc/XC7A35T-1CPG236C/122-1907-ND/5039071)). This board was chosen for no reason other than we used it for labs in my digital design course, and so it's what I had lying around. Should a better board be needed, I will upgrade.

:warning: If your goal is to compile/simulate this project yourself, you **must** make sure you add the root directory of the project to the include paths list. If you don't then some `` `include `` directives will fail!

## Important Documentation
Since currently I have made no modifications to the ISA or the pipeline, the standard documentation should suffice for describing the architecture.

[LC3-B ISA](https://drive.google.com/file/d/1b6OD_YVspwkl2c6o8Nr-t2aLnPpGf_ga/view?usp=sharing)

[LC3-B Pipeline Microarchitecture](https://drive.google.com/file/d/0B7NZdTrW3-46QWVycW5NTHRPSXM/view?usp=sharing)

## Project Structure
#### `/` (root directory)
Contains the Verilog files for the stages of the pipeline and the module for the overall LC3BP module itself.

#### `component/` 
Contains necessary modules that are part of the processor:

1. Register file
2. Memory
3. The control store
4. The ALU

#### `misc/` 
Contains miscellaneous modules that are used/will be used:

1. Clock dividers
2. Modules for interfacing with the 7-segment display on the Basys 3

#### `test/` 
Contains all the `.do` files I use to test my code in Modelsim. It also contains any test bench Verilog files that I use.

## Memories Notes
Since memory reads are synchronous (except for the register file), the memory needs to be clocked at twice the frequency as the latches between the stages. This is so that there will be be enough time during the stages to read memory and then perform any necessary computations.

### Control Store
The control store is a small ROM with synchronous reads that holds the microcode. It will be implemented in distributed RAM.

### Register File
The register file has _asynchronous_ reads and synchronous writes. It will be implemented in distributed RAM.

### Main Memory
The memory module is a RAM with 2 ports: a read-only port and a read-write port. Reads and writes are both synchronous in order to utilize the block RAM on the FPGA. 

Since the LC3-B ISA uses 16-bit addresses, all of memory can fit in the block RAM. Using 2 separate ports allows for the Fetch and Memory stages to access memory at the same time.

Memory is considered to be an external resource, i.e. it will not be part of the overall LC3BP processor. The LC3BP module will have ports for interfacing with memory.

## Testing
I currently do all testing in Modelsim. I simply load all the files into a project, compile, and then run the `.do` files in the `test/` folder. I then manually inspect the waveforms to make sure everything is accurate.

The plan for the future is to write a test bench for the overall processor when it is complete. It will go through one big program cycle by cycle and make sure all latches are what they should be. This would be more efficient than inspecting waveforms by eye alone and would also allow me to quickly test that functionality of the processor hasn't been broken by any iterations of the architecture.

To generate the data that will be tested against, I will use the lab I wrote for class. For obvious reasons, I can't publish that code to GitHub.

Simulation in the future will be done using [Icarus Verilog](http://iverilog.icarus.com/).

## Current Progress
* All necessary subcomponents except for the Shift Arthimetic (SHF) unit have been implemented.
* The Fetch and Decode stages have been implemented and tested.
* The LC3BP module has been create with the Fetch and Decode stages wired.
* A test bench and `.do` file have been created to test the F/DE pipeline. However, the tests themselves have not been implemented.

## Future Plans
This is what needs to be done in order for the LC3BP simulation to match the functionality of our lab:

* Write tests for the F/DE pipeline.
* Implement the remaining stages, AGEX, MEM, and SR, and write tests for those stages individually.
* Write a test bench for the overall LC3BP using the emulator we wrote for the lab as the guide.

After that, work will need to be done to make all the code synthesizable. Some method of observing the pipeline on the Basys 3 board will also be needed.
