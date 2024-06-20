`timescale 1ns/1ns
`include "instmem.v"
module instmem_tb;

    reg [15:0] pc;
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
        
        pc = 16'b0;
        reset = 1'b0;
        enable = 1'b0;

      
        reset = 1;
        #10; 
        reset = 0;

        
        enable = 1;

        
        #10 pc = 16'b0000000000000000; // Read address 0
        #10 pc = 16'b0000000000000001; // Read address 1
        #10 pc = 16'b0000000000000010; // Read address 2
        #10 pc = 16'b0000000000000011; // Read address 3
        #10 pc = 16'b0000000000000100; // Read address 4
        #10 pc = 16'b0000000000000101; // Read address 5

        
        enable = 0;
        #10;

        
        reset = 1;
        #10;
        reset = 0;

        
        $finish;
    end

    // Monitor changes
    initial begin
        $monitor("Time: %0t, Reset: %b, Enable: %b, PC: %h, Instruction: %h", $time, reset, enable, pc, instruction);
    end

endmodule
