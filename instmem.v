`timescale 1ns/1ns
module instmem(
    output reg [15:0] instruction,
    input [5:0] pc,
    input reset,
    input enable
);

reg [15:0] instrmem [0:63];  // Memory with 32 locations of 16 bits each

always @(posedge reset or posedge enable or pc) begin
    if (reset)
    $readmemb("instruct.txt", instrmem); 
    if (enable)
        instruction <= instrmem[pc];
end

initial begin
    $readmemb("instruct.txt", instrmem);  
end

endmodule