`timescale 1ns/1ns
`include "pc.v"
`include "instmem.v"

module instfetch(
    input loadPC,
    input incPC,
    input [5:0] address,
    input reset,
    input enable,
    output [15:0] instruction
);

    wire [5:0] execadd;

    // Instantiate the pc module
    pc pc_inst (
        .loadPC(loadPC),
        .incPC(incPC),
        .address(address),
        .execadd(execadd)
    );

    // Instantiate the instmem module
    instmem instmem_inst (
        .instruction(instruction),
        .pc(execadd),
        .reset(reset),
        .enable(enable)
    );

endmodule
