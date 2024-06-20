`timescale 1ns/1ps
`include "execute.v"
module executetb ();

wire [15:0] result; 
reg [3:0] opcode;
reg am;
reg enable,reset;
reg [2:0] rd,rs1,rs2;
reg [4:0] mem_addr,instr_mem_addr;
reg clk;
wire zero_flag;

execute dut(.zero_flag(zero_flag),.result(result),.opcode(opcode),.am(am),.enable(enable),.reset(reset)
,.rd(rd),.rs1(rs1),.rs2(rs2),.mem_addr(mem_addr),.instr_mem_addr(instr_mem_addr),.clk(clk));

initial
begin
    clk = 1'b0;
    forever 
    begin
        #5 clk = ~clk;
    end
end
initial
begin
   $dumpfile("execute.vcd");
   $dumpvars(0,executetb);
   $monitor("opcode: %b , am: %b , rd: %b, rs1: %b, rs2: %b, result: %b, zero_flag: %b",
   opcode,am,rd,rs1,rs2,result,zero_flag);
    #2;
    opcode <= 4'b0101; am <= 1'b0; rd <= 3'b001; rs1 <= 3'b011; 
    rs2 <= 3'b111; mem_addr<= 0111; enable <= 1'b1; reset <=1'b0;
    #5;
    opcode <= 4'b0110; am <= 1'b1; rd <= 3'b001; rs1 <= 3'b011; 
    rs2 <= 3'b111; mem_addr<= 0000; enable <= 1'b1; reset <=1'b0;#5;
    #5;
    opcode <= 4'b0011; am <= 1'b0; rd <= 3'b001; rs1 <= 3'b011; 
    rs2 <= 3'b111; mem_addr<= 0000; enable <= 1'b1; reset <=1'b0;#5;
    #5;
    opcode <= 4'b0011; am <= 1'b1; rd <= 3'b001; rs1 <= 3'b011; 
    rs2 <= 3'b111; mem_addr<= 0000; enable <= 1'b1; reset <=1'b0;
    #50 $finish;
end
endmodule //executetb
// ./iverilog -o execute.vvp executetb.v
// ./vvp execute.vvp