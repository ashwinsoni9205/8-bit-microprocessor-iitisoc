# IITISOC Project PS-3
# 8-bit Microprocessor with 16-bit Instruction Set and 4-Stage Pipelining

## Overview
This project involves designing an 8-bit microprocessor using Verilog HDL. The microprocessor is optimized using a 4-stage pipelining process and supports a 16-bit instruction set. This README provides an overview of the microprocessor's specifications, architecture, and operational details.

### Team Members
- Ashwin Soni
- S.V. Jaya Chand
- Yash Baghel
- Sanidhya Baheti

### Specifications
- **Data Width:** 8 bits
- **Instruction Width:** 16 bits
- **Instruction Memory:** 64 x 16 bits
- **Data Memory:** 16 x 8 bits
- **Register File:** 8 x 8 bits
- **Program Counter:** 6 bits

### Addressing Modes
- Register Direct Addressing
- Absolute Addressing

### Pipelining Stages
1. Instruction Fetch (IF)
2. Instruction Decode (ID)
3. Execute (EX)
4. Writeback (WB)

### Instruction Set
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

### Instruction format
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

6. **JUMP AND BRANCH:**
  
|opcode(5)|X|instr_mem(6)|0000|
|---------|-|------------|----|

6. **HALT:**
  
|opcode(5)|X|0000000000|
|---------|-|----------|


### Datapath
The microprocessor's datapath includes the following stages:
1. **Instruction Fetch (IF):** Fetches the instruction from memory.
2. **Instruction Decode (ID):** Decodes the fetched instruction to determine the operation ,operands,destination registor and etc.
3. **Execute (EX):** Performs the required operation on the operands.
4. **Writeback (WB):** Writes the result back to the register file or memory as per opcode.

### Hazards and Mitigation Methods

#### Hazards
Pipelining introduces several types of hazards, which can impede the smooth execution of instructions:
1. **Data Hazards:** Occur when an instruction depends on the result of a previous instruction that is not yet complete.
 - **RAW hazard:** A Read After Write (RAW) hazard occurs when an instruction attempts to read a register before a preceding instruction has finished writing to that register. This can lead to the reading instruction obtaining an incorrect or stale value, affecting the correctness of the program.
 - **WAR hazard:** A Write After Read (WAR) hazard occurs when an instruction writes to a register before a preceding instruction has finished reading from that register. This can lead to the previous instruction reading an incorrect value or the write operation causing unintended side effects.
 - **WAW hazard:** A Write After Write (WAW) hazard occurs when two instructions write to the same register in a pipeline, and the order of writes can affect the final value of that register. If the second write completes before the first write, the final value written to the register might be incorrect.
2. **Control Hazards:** Occur due to jump or branch instructions that change the flow of execution.
3. **Structural Hazards:** Occur when two or more instructions require the same hardware resource simultaneously.

#### Mitigation Methods

1. **Data Hazards Mitigation:**
   - **RAW hazard:** The Read After Write (RAW) hazard is mitigated by making the pipeline stages level-triggered. This ensures that if the register value changes in the middle of execution, the result in the stages gets updated accordingly.
   - **WAR hazard:** Write After Read (WAR) hazards do not occur in this processor because of sequential flow of instruction in the pipeline, which means that if instruction 1 is in the pipeline before instruction 2 then instruction 1 will write the regFile and memoryBank first then only instruction 2 can write it so, no chances of these files being written by any instruction occuring after the present instruction.
   - **WAW hazard:** Write After Write (WAW) hazards do not occur in this processor as data is written in register bank and memory only in the writeback stage which takes one instruction at a time so no two instruction can write the registers and memory simultaneously.

2. **Control Hazards Mitigation:**
   - **Pipeline Flushing:** Implemented pipeline flushing to mitigate control hazard, the jump and branch instructions with true condition sends signal to controller from writeback stage to flush the pipeline, controller then resets the IF_ID_Latch, Decode stage, ID_EX_Latch, Execute stage and EX_WB_Latch to flush the wrong instructions from the pipeline.

3. **Structural Hazards Mitigation:**
   - **Isolation of read and write signals:** Mitigated the structural hazard caused by regFile and memoryBank by isolating the read and write signals from each other. In our processor the read operation is done only in execute stage and write operation in writeback stage, both the stages works at different clock signals, so we enable read signal only when execute stage is given clock and write signal is enabled when writeback stage is given clock and instruction that require write operation is present in writeback stage. 


![image](https://github.com/user-attachments/assets/bfed9f1b-2f5f-49e6-80b0-80f921aa26f1)
