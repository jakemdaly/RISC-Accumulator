# RISC-Accumulator
This project contains a working implementation of an accumulator-based instruction set architecture (ISA) for running encryption and decryption algorithms. The processor runs a custom assembly language for data retrieval and computation, and this project contains multiple example scripts using this assembly language, along with the python based assembler that converts instructions to machine code. 

**IMPORTANT: When switching back and forth between running program1 and program2and3, two files need to be changed:**
**InstROM.sv:** change *$readmemb("/path/to/source/code/machine_code_p1.txt",inst_rom);* to *$readmemb("/path/to/source/code/machine_code_p2and3.txt",inst_rom);*
**JumpAddressROM.sv:** change *$readmemb("/path/to/source/code/jump_addresses_p1.txt",jump_address_rom);* to *$readmemb("/path/to/source/code/jump_addresses_p2and3.txt",jump_address_rom);*

To run the two programs, create a new project in Modelsim and add all of the files in the zip directory to it. Compile all the files (you might need to make the Definitions.sv be the file that is compiled first and the top_level.sv and test benches the files that are compiled last). After successful compilation, you can run the two simulations.
Start with the encrypt_tb.sv, and run the simulation on this. You can check the output of the test bench by looking in the folder where you ran the scripts from--the output should be called msg_enocder_out.txt.
Before running program2and3, make the two changes mentioned above under **IMPORTANT**.
Then run decrypt_depad_tb.sv, and witness the output file from this testbench--the output should be called msg_decoder_out.txt

DUT files:
- ALU.sv
- Ctrl.sv
- data_mem.sv
- Definitions.sv
- InstFetch.sv
- InstROM.sv
- JumpAddressROM.sv
- RegFile.sv
- top_level.sv

Data files (ROM, machine code, assembly, etc.)
- jump_addresses_p1.txt
- jump_addresses_p2and3.txt
- machine_code_p1.txt
- machine_code_p2and3.txt
- program1.a
- program2and3.a

Test bench and output files:
- msg_enocder_out.txt
- msg_decoder_out.txt
- program1_tb.sv
- program3_tb.sv (runs program2and3.a)

Assembler python script to convert asembly to machine code:
- assembler.py
