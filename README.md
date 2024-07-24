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

### Datapath
The microprocessor's datapath includes the following stages:
1. **Instruction Fetch (IF):** Fetches the instruction from memory.
2. **Instruction Decode (ID):** Decodes the fetched instruction to determine the operation and operands.
3. **Execute (EX):** Performs the required operation on the operands.
4. **Writeback (WB):** Writes the result back to the register file or memory.

### Hazards and Mitigation Methods

#### Hazards
Pipelining introduces several types of hazards, which can impede the smooth execution of instructions:
- **Data Hazards:** Occur when an instruction depends on the result of a previous instruction that is not yet complete.
- **Control Hazards:** Occur due to branch instructions that change the flow of execution.
- **Structural Hazards:** Occur when two or more instructions require the same hardware resource simultaneously.

#### Mitigation Methods

1. **Data Hazards Mitigation:**
   - **Forwarding:** Utilized to resolve data hazards by routing the output of one pipeline stage directly to a previous stage that needs it. This ensures that instructions can use the most recent data without waiting for it to be written back to the register file.
   - **Stalling:** Implemented when forwarding cannot resolve the hazard. This introduces NOP (no operation) instructions into the pipeline to wait for the required data to be available.

2. **Control Hazards Mitigation:**
   - **Branch Prediction:** Simple static prediction where branches are assumed to be not taken. This allows the pipeline to fetch the next sequential instruction.
   - **Flushing the Pipeline:** When a branch is taken, the instructions in the pipeline fetched after the branch are invalidated. This ensures that incorrect instructions do not execute.

3. **Structural Hazards Mitigation:**
   - **Resource Duplication:** Ensuring that sufficient resources are available to handle multiple instructions. For example, separate instruction and data memories help in avoiding conflicts.

### Pipeline Flushing

To handle branching, a method is used to detect branching using the Program Counter (PC). An additional register stores the address of the next instruction. If this address differs from the expected next instruction address, a branch is detected, and the pipeline is flushed. This ensures that no incorrect instructions proceed through the pipeline stages.
