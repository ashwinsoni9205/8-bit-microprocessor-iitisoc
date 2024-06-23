`timescale 1ns/1ns
`include "pc.v"

module tb_pc;
    reg loadPC;
    reg incPC;
    reg [5:0] address;
    wire [5:0] execadd;

    pc uut (
        .loadPC(loadPC),
        .incPC(incPC),
        .address(address),
        .execadd(execadd)
    );

    initial begin
        // Initialize signals
        loadPC = 0;
        incPC = 0;
        address = 6'b0;
        #10;

        // Test loading an address
        address = 6'b001010;
        loadPC = 1;
        incPC = 0;
        #10;
        $display("execadd: %b", execadd);

        // Test incrementing the PC
        loadPC = 0;
        incPC = 1;
        #10;
        $display("execadd: %b", execadd);

        // Test resetting the PC
        loadPC = 0;
        incPC = 0;
        #10;
        $display("execadd: %b", execadd);

        $finish;
    end
    
endmodule