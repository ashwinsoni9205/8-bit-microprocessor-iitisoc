`timescale 1ns/1ns

module instfetch(
    input reset,
    input clk,
    output [15:0] instruction,
    output reg temp,
    input [5:0] execadd
);

    always @(posedge clk) begin
        temp = 1;
        #5; 
        temp = 0;
    end

endmodule
