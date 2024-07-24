# IITISOC Project PS-3
# 8-bit Microprocessor with 16-bit Instruction Set and 4-Stage Pipelining
## Overview
This project involves designing an 8-bit microprocessor using Verilog HDL. The microprocessor is optimized using a 4-stage pipelining process and supports a 16-bit instruction set. This README provides an overview of the microprocessor's specifications, architecture, and operational details.

### Team Members

Ashwin Soni

S.V. Jaya Chand

Yash Baghel

Sanidhya Baheti


### Specifications

Data Width: 8 bits

Instruction Width: 16 bits

Instruction Memory: 64 x 16 bits

Data Memory: 16 x 8 bits

Register File: 8 x 8 bits

Program Counter: 6 bits


### Addressing Modes:

Register Direct Addressing

Absolute Addressing

### Pipelining Stages

Instruction Fetch (IF)

Instruction Decode (ID)

Execute (EX)

Writeback (WB)


### Instruction Set
The microprocessor supports a variety of operations through its 16-bit instructions. Below are the opcodes for different operations:

Opcode	&emsp; Operation

00000	&emsp; MOVE

00001	  &emsp;ADD
  
00010	  &emsp;SUBTRACT

00011	  &emsp;MULTIPLY

00100	  &emsp;DIVIDE

00101	  &emsp;INCREMENT

00110	  &emsp;DECREMENT

00111	  &emsp;AND

01000	  &emsp;OR

01001	  &emsp;NOT

01010	  &emsp;XOR

01011	  &emsp;LOAD

01100	  &emsp;STORE

01101	  &emsp;JUMP

01110	  &emsp;BRANCH (ZERO FLAG)

10000	  &emsp;ARITHMETIC LEFT SHIFT

10001	  &emsp;ARITHMETIC RIGHT SHIFT

10010	  &emsp;LOGICAL LEFT SHIFT

10011	  &emsp;LOGICAL RIGHT SHIFT

10100	  &emsp;ROTATE LEFT

10101	  &emsp;ROTATE RIGHT

10110	  &emsp;BRANCH (CARRY FLAG)

10111	  &emsp;BRANCH (AUXILIARY FLAG)

11000	  &emsp;BRANCH (PARITY FLAG)

11111	  &emsp;HALT


### Datapath

The microprocessor's datapath includes the following stages:

Instruction Fetch (IF): Fetches the instruction from memory.

Instruction Decode (ID): Decodes the fetched instruction to determine the operation and operands.

Execute (EX): Performs the required operation on the operands.

Writeback (WB): Writes the result back to the register file or memory.
