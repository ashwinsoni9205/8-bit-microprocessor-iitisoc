`timescale 1ns/1ns
`include "pc.v"
`include "instmem.v"

module instfetch(
    input reset,
    input clk,
    output [15:0] instruction
);

    wire [5:0] execadd;
    reg temp,enable;

    
    always @(posedge clk) begin
        temp = 1;
        #5; 
        temp = 0;
    end

    // Instantiate the pc module
    pc pc_inst (
        .incPC(temp),
        .execadd(execadd),
        .reset(reset)
    );

    // Instantiate the instmem module
    instmem instmem_inst (
        .instruction(instruction),
        .pc(execadd),
        .reset(1'b0),
        .enable(1'b1)
    );

endmodule
