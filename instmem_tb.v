`timescale 1ns/1ns
`include "instmem.v"
`timescale 1ns/1ns

module tb_instmem;
    reg [5:0] pc;
    reg reset;
    reg enable;
    wire [15:0] instruction;

    instmem uut (
        .instruction(instruction),
        .pc(pc),
        .reset(reset),
        .enable(enable)
    );

    initial begin
        // Initialize signals
        pc = 6'b0;
        reset = 1;
        enable = 0;
        #10;

        // Test reset functionality
        reset = 0;
        enable = 1;
        pc = 6'b000000;
        #10;
        $display("Instruction at PC %b: %b", pc, instruction);

        // Test reading another instruction
        pc = 6'b000001;
        #10;
        $display("Instruction at PC %b: %b", pc, instruction);

        // Test reading another instruction
        pc = 6'b000010;
        #10;
        $display("Instruction at PC %b: %b", pc, instruction);

        // Test reading another instruction
        pc = 6'b000011;
        #10;
        $display("Instruction at PC %b: %b", pc, instruction);

        $finish;
    end

    initial begin
        // Load instruction memory from file
        $readmemb("instruct.txt", uut.instrmem);
    end
endmodule
