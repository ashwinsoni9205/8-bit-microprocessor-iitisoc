`timescale 1ns/1ns
`include "instfetch.v"

module tb_instfetch;
    reg loadPC;
    reg incPC;
    reg [5:0] address;
    reg reset;
    reg enable;
    wire [15:0] instruction;

    instfetch uut (
        .loadPC(loadPC),
        .incPC(incPC),
        .address(address),
        .reset(reset),
        .enable(enable),
        .instruction(instruction)
    );

    initial begin
        // Initialize signals
        loadPC = 0;
        incPC = 0;
        address = 6'b0;
        reset = 0;
        enable = 0;
        #10;

        // Reset the instruction memory
        reset = 1;
        #10;
        reset = 0;
        enable = 1;

        // Test loading an address and fetching instruction
        address = 6'b000111;
        loadPC = 1;
        incPC = 0;
        #10;
        $display("Fetched instruction at address %b: %b", address, instruction);

        // Test incrementing the PC and fetching the next instruction
        loadPC = 0;
        incPC = 1;
        #10;
        $display("Fetched instruction at incremented PC: %b", instruction);

        // Test resetting the PC and fetching instruction at reset PC
        incPC = 0;
        #10;
        $display("Fetched instruction at reset PC: %b", instruction);

        $finish;
    end

    initial begin
        // Load instruction memory from file
        $readmemb("instruct.txt", uut.instmem_inst.instrmem);
    end
endmodule
