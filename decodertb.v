`timescale 10ns/1ns
`include "decoder2.v"
module Decoder_tb();

    reg [15:0] instruction;      // Input instruction
    reg clk;                     // Clock signal
    
    // Outputs from InstructionDecoder module
    wire [3:0] opcode;            // Output: Opcode
    wire addressing_mode;         // Output: Addressing mode
    wire [2:0] reg1;              // Output: Register 1
    wire [2:0] reg2;              // Output: Register 2
    wire [2:0] reg3;              // Output: Register 3      
    wire [4:0]data_mem;
    wire [4:0]instruction_mem;
         
    // Instantiate the InstructionDecoder module
    Decoder dut (
        .instruction(instruction),
        .opcode(opcode),
        .addressing_mode(addressing_mode),
        .reg1(reg1),
        .reg2(reg2),
        .reg3(reg3),
        .data_mem(data_mem),
        .instruction_mem(instruction_mem)
        );
    
    always #5 clk = ~clk;
     
    initial begin
        clk = 0; // Initialize clock
        //Test 1
        instruction = 16'b0001_0110_0110_0000;
        #10;
        $display("Test 1");
        $display("Instruction: %b", instruction);
        $display("Opcode: %b", opcode);
        $display("Addressing Mode: %b", addressing_mode);
        $display("Reg1: %b, Reg2: %b, Reg3: %b", reg1, reg2, reg3);
        $display("Data_mem: %b", data_mem);
        $display("Instruction_mem:%b", instruction_mem);
        $display("");
        //Test 2
        instruction = 16'b0101_0110_0110_0000;
        #10;
        $display("Test 2");
        $display("Instruction: %b", instruction);
        $display("Opcode: %b", opcode);
        $display("Addressing Mode: %b", addressing_mode);
        $display("Reg1: %b, Reg2: %b, Reg3: %b", reg1, reg2, reg3);
        $display("Data_mem: %b", data_mem);
        $display("Instruction_mem:%b", instruction_mem);
        $display("");
    end

    initial begin
        #100; // Run simulation for some time after all tests
        $finish; // Finish simulation
    end
endmodule
        