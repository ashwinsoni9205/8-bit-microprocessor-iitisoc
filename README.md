# IITISOC Project PS-3
# 8-bit Microprocessor with 16-bit Instruction Set and 4-Stage Pipelining

## Overview
This project involves designing an 8-bit microprocessor using Verilog HDL, optimized with a 4-stage pipeline and a 16-bit instruction set. The microprocessor features a Harvard architecture and RISC design, offering an efficient execution of instructions through stages: Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), and Writeback (WB). With a data width of 8 bits and a clock frequency of 500MHz, the processor supports various addressing modes, including Register Direct and Absolute Addressing, and a wide range of operations such as arithmetic, logical, and control instructions.

The project includes detailed modules for each stage, a robust hazard mitigation strategy to handle data, control, and structural hazards, and comprehensive testing to ensure functionality and efficiency. By integrating all components, the microprocessor ensures smooth data flow and control signal propagation across the pipeline, making it a versatile and powerful processor design.


## Specifications
- **Memory-Architecture:** Harvard Architecture
- **Microprocessor-Architecture:** RISC
- **Data Width:** 8 bits
- **Instruction Width:** 16 bits
- **Instruction Memory:** 64 x 16 bits
- **Data Memory:** 16 x 8 bits
- **Register File:** 8 x 8 bits
- **Program Counter:** 6 bits
- **Clock Frequency:** 500MHz

## Addressing Modes
- Register Direct Addressing
- Absolute Addressing

## Pipelining Stages
1. Instruction Fetch (IF)
2. Instruction Decode (ID)
3. Execute (EX)
4. Writeback (WB)

# GETTING STARTED

## Prerequesites

Please install Icarus Verilog (Iverilog- commonly used in interface with vscode to code and simulate in verilog ) along with gtkwave\
(used for waveform simulation and analysis) in your system to begin with.\
Icarus verilog is available at : [https://bleyer.org/icarus/](https://bleyer.org/icarus/)\
Further interface your VSCODE with run time environment (if it's not default from environment variables in the settings).\
Install necessary extensions for verilog formatting into VS CODE from [https://marketplace.visualstudio.com/items?itemName=mshr-h.VerilogHDL](https://marketplace.visualstudio.com/items?itemName=mshr-h.VerilogHDL)

## Setup Instructions

Run the following in the terminal of VS CODE

```
iverilog -o processor.vvp processortb.v
vvp processor.vvp
gtkwave
```

## Instruction Set
The microprocessor supports a variety of operations through its 16-bit instructions. Below are the opcodes for different operations:

| Opcode | Operation                |
|--------|--------------------------|
| 00000  | MOVE                     |
| 00001  | ADD                      |
| 00010  | SUBTRACT                 |
| 00011  | MULTIPLY                 |
| 00100  | DIVIDE                   |
| 00101  | INCREMENT                |
| 00110  | DECREMENT                |
| 00111  | AND                      |
| 01000  | OR                       |
| 01001  | NOT                      |
| 01010  | XOR                      |
| 01011  | LOAD                     |
| 01100  | STORE                    |
| 01101  | JUMP                     |
| 01110  | BRANCH (ZERO FLAG)       |
| 10000  | ARITHMETIC LEFT SHIFT    |
| 10001  | ARITHMETIC RIGHT SHIFT   |
| 10010  | LOGICAL LEFT SHIFT       |
| 10011  | LOGICAL RIGHT SHIFT      |
| 10100  | ROTATE LEFT              |
| 10101  | ROTATE RIGHT             |
| 10110  | BRANCH (CARRY FLAG)      |
| 10111  | BRANCH (AUXILIARY FLAG)  |
| 11000  | BRANCH (PARITY FLAG)     |
| 11111  | HALT                     |

## Instruction format
### R Type:
1. **MOVE:**
- **AM = 0:**
  
|opcode(5)|0|rd(3)|rs(3)|0000|
|---------|-|-----|-----|----|

- **AM = 1:**
  
|opcode(5)|1|rd(3)|mem_add(4)|000|
|---------|-|-----|----------|---|


2. **ADD,SUB,MUL,DIV,AND,OR,XOR,COMP:**
- **AM = 0:**
  
|opcode(5)|0|rd(3)|rs1(3)|rs2(3)|0|
|---------|-|-----|------|------|-|

- **AM = 1:**
  
|opcode(5)|1|rd(3)|rs1(3)|mem_add(4)|
|---------|-|-----|------|----------|


3. **INCR,DEC,NOT,all shift and rotate:**
- **AM = 0:**
  
|opcode(5)|0|rd(3)|s_r_amount(3)|0000|
|---------|-|-----|-------------|----|

- **AM = 1:**
  
|opcode(5)|1|data_mem(4)|s_r_amount(3)|000|
|---------|-|-----------|------------|----|

4. **LOAD(mem -> reg):**
  
|opcode(5)|X|rd(3)|data_mem(4)|000|
|---------|-|-----|-----------|---|

5. **LOAD(reg -> mem):**
  
|opcode(5)|X|data_mem(4)|rd(3)|000|
|---------|-|-----------|-----|---|

### J Type:

 **JUMP AND BRANCH:**
  
|opcode(5)|X|instr_mem(6)|0000|
|---------|-|------------|----|

 **HALT:**
  
|opcode(5)|X|0000000000|
|---------|-|----------|

## Modules

### pc.v
- **Description**: This module increments the program counter after each instruction fetch, enabling sequential instruction execution and branching when needed.

### regFile.v
- **Description**: This module supports reading from and writing to multiple registers simultaneously, essential for efficient instruction execution.

### memoryBank.v
- **Description**: This module interfaces with both the data memory and the control unit to handle memory read/write operations during the execute and memory access stages.

### instmem.v
- **Description**: This module stores the program's instructions and supports fast access to facilitate the instruction fetch stage.

### instfetch.v
- **Description**: This module fetches instructions from instruction memory based on the program counter, passing them to the decode stage.

### decoder2.v
- **Description**: This module decodes the fetched instructions, determining the operation type and identifying the required operands and control signals.

### executestage.v
- **Description**: This module performs the actual computation, utilizing the arithmetic logic unit (ALU) and handling operations like addition, subtraction, logical operations, and branching.

### write_back.v
- **Description**: This module takes the results from the execute stage or memory access stage and writes them back to the appropriate register in the register file.

### Latch_IF_ID.v
- **Description**: This module holds the fetched instruction between the instruction fetch and decode stages, ensuring smooth transition and synchronization in the pipeline.

### latch_ID_EX.v
- **Description**: This module stores data between the instruction decode and execute stages, ensuring smooth transition and synchronization in the pipeline.

### EX_WB_Latch.v
- **Description**: This module temporarily holds data between the execution stage and the write-back stage, maintaining pipeline flow and data integrity.

### controller.v
- **Description**: This module generates control signals based on the decoded instruction, ensuring the correct operation of each pipeline stage and coordinating hazard detection and resolution.

### processor.v
- **Description**: This top-level module integrates all the individual components, orchestrating their interactions to ensure smooth data flow and control signal propagation across the pipeline.


## Datapath
The microprocessor's datapath includes the following stages:
### Pipeline Stages

### Instruction Fetch (IF)

- Fetches the instruction from memory.
- This stage retrieves the instruction located at the address specified by the program counter (PC). The PC is then incremented to point to the next instruction. This stage is crucial for ensuring that instructions are sequentially accessed and prepared for decoding.

### Instruction Decode (ID)

-  Decodes the fetched instruction to determine the operation, operands, destination register,memory address,addressing mode etc..
-  In this stage, the fetched instruction is decoded to identify the opcode, which specifies the operation to be performed. It also determines the source operands and the destination register. 

### Execute (EX)

- Performs the required operation on the operands.
-  This stage utilizes the arithmetic logic unit (ALU) to execute arithmetic and logical operations on the source operands. It also calculates memory addresses for load and store instructions and evaluates branch conditions. The results of these operations are then prepared for the next stage.

### Writeback (WB)

-  Writes the result back to the register file or memory as per opcode.
- In this final stage, the results of the execution stage are written back to the destination register specified during the decode stage. If the instruction involves memory operations, the data is written to or read from the memory. This stage ensures that the results of the executed instruction are properly stored and made available for future instructions.
  

![image](https://github.com/user-attachments/assets/03f5b45f-9851-4da5-be68-b43159fcd261)


## Controller FSM

![image](https://github.com/user-attachments/assets/3b0ac896-0e73-4762-9dcf-f95de5607c14)

The control system manages the following states:

1. S0: Initial State (Everything off)
   
2. S1: Reset State

3. S2: Clock Signal State
 
4. S3: Halt State

## State Descriptions

### S0: Initial State
- Description: Everything is off.
- Purpose: Represents the initial state where the microprocessor and all its components are turned off.
- Actions: No operations are performed; the system is in standby mode.

### S1: Reset State
- Description: Reset all stages and enable all pipeline latches.
- Purpose: Prepares the microprocessor for operation.
- Actions: Resets all pipeline stages and enables pipeline latches.

### S2: Clock Signal State
- Description: Clock signals to latches will be sent.
- Purpose: Sends clock signals to synchronize operations across different stages.
- Actions: Distributes clock signals to latches and checks the Halt signal.

### S3: Halt State
- Description: Halt = 1
- Purpose: Pauses microprocessor operations when the Halt signal is set.
- Actions: Halts operations and waits for an external interrupt or resume signal.

## State Transitions

- S0 to S1: Microprocessor is turned on or initialized.
- S1 to S2: After resetting stages and enabling latches.
- S2 to S3: If the Halt signal is set to 1.
- S3 to S1: If a resume interrupt is received.


## Hazards and Mitigation Methods

### Hazards
Pipelining introduces several types of hazards, which can impede the smooth execution of instructions:
1. **Data Hazards:** Occur when an instruction depends on the result of a previous instruction that is not yet complete.
 - **RAW hazard:** A Read After Write (RAW) hazard occurs when an instruction attempts to read a register before a preceding instruction has finished writing to that register. This can lead to the reading instruction obtaining an incorrect or stale value, affecting the correctness of the program.
 - **WAR hazard:** A Write After Read (WAR) hazard occurs when an instruction writes to a register before a preceding instruction has finished reading from that register. This can lead to the previous instruction reading an incorrect value or the write operation causing unintended side effects.
 - **WAW hazard:** A Write After Write (WAW) hazard occurs when two instructions write to the same register in a pipeline, and the order of writes can affect the final value of that register. If the second write completes before the first write, the final value written to the register might be incorrect.
2. **Control Hazards:** Occur due to jump or branch instructions that change the flow of execution.
3. **Structural Hazards:** Occur when two or more instructions require the same hardware resource simultaneously.

### Mitigation Methods

1. **Data Hazards Mitigation:**
   - **RAW hazard:** The Read After Write (RAW) hazard is mitigated by making the pipeline stages level-triggered. This ensures that if the register value changes in the middle of execution, the result in the stages gets updated accordingly.
   - **WAR hazard:** Write After Read (WAR) hazards do not occur in this processor because of sequential flow of instruction in the pipeline, which means that if instruction 1 is in the pipeline before instruction 2 then instruction 1 will write the regFile and memoryBank first then only instruction 2 can write it so, no chances of these files being written by any instruction occuring after the present instruction.
   - **WAW hazard:** Write After Write (WAW) hazards do not occur in this processor as data is written in register bank and memory only in the writeback stage which takes one instruction at a time so no two instruction can write the registers and memory simultaneously.

2. **Control Hazards Mitigation:**
   - **Pipeline Flushing:** Implemented pipeline flushing to mitigate control hazard, the jump and branch instructions with true condition sends signal to controller from writeback stage to flush the pipeline, controller then resets the IF_ID_Latch, Decode stage, ID_EX_Latch, Execute stage and EX_WB_Latch to flush the wrong instructions from the pipeline.

3. **Structural Hazards Mitigation:**
   - **Isolation of read and write signals:** Mitigated the structural hazard caused by regFile and memoryBank by isolating the read and write signals from each other. In our processor the read operation is done only in execute stage and write operation in writeback stage, both the stages works at different clock signals, so we enable read signal only when execute stage is given clock and write signal is enabled when writeback stage is given clock and instruction that require write operation is present in writeback stage. 



## VERILOG Schematic: 

![WhatsApp Image 2024-07-26 at 13 11 06_f6d0554b](https://github.com/user-attachments/assets/b565e76d-bcaa-4505-85f8-187ac01a5718)


## Simulation results:
The total format has been clearly described in the file named instrmean.txt in the same repo. These are the output waveforms observed correspondingly.

**Hazard Detection** 
|----------------|
|0000100010100110|
|0000111000010010|
|1001101110010000|
|1011000010000000|
|1111100000000000|
|1111100000000000|
|1111100000000000|
|1111100000000000|
|1001101110010000|
|1111100000000000|




![WhatsApp Image 2024-07-26 at 12 55 00_59a9a6ca](https://github.com/user-attachments/assets/9d995306-227b-4828-8e5b-ffb80325e223)

**Arthimetic and logical operations**
|----------------|
|0000001001011110| 
|0101001000101110|
|0000111001010000|


![WhatsApp Image 2024-07-27 at 10 38 50_78aedb63](https://github.com/user-attachments/assets/eb753964-ee59-43ff-b537-71a7c5b97be9)

**Shift and Flag Instructions**
|----------------|
|1000001110010000|
|1000011111001000| 
|1001101110100000|
|1001111111010000|
|0001111101101111|
|1001001110010000|
|1011000100010000|

![WhatsApp Image 2024-07-27 at 10 49 13_7578ca82](https://github.com/user-attachments/assets/4d2b36b9-92aa-40d6-8095-8abf6aaf0615)

![WhatsApp Image 2024-07-27 at 10 49 46_e594a9f7](https://github.com/user-attachments/assets/f976fd20-fdad-4bd6-867d-c76d1357b158)


**Jump Instructions**:


## Team Members

- Ashwin Soni &emsp; [![GitHub](https://img.shields.io/badge/-GitHub-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/ashwinsoni9205) &emsp; [![LinkedIn](https://img.shields.io/badge/-LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ashwin-soni-099200262)
- S.V. Jaya Chand &emsp; [![GitHub](https://img.shields.io/badge/-GitHub-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/Jay1chand) &emsp; [![LinkedIn](https://img.shields.io/badge/-LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/s-v-jaya-chand-a32806257)
- Yash Baghel &emsp; [![GitHub](https://img.shields.io/badge/-GitHub-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/shadowchaser004) &emsp; [![LinkedIn](https://img.shields.io/badge/-LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/yash-baghel-3435b525b)
- Sanidhya Baheti &emsp; [![GitHub](https://img.shields.io/badge/-GitHub-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/SanidhyaBaheti) &emsp; [![LinkedIn](https://img.shields.io/badge/-LinkedIn-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/sanidhya-baheti-122b39252)

