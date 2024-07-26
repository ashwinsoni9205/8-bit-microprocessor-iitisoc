`timescale 1ns/1ps
`include "executestage.v"
module executetb ();

wire [15:0] result; 
reg [4:0] opcode;
reg am;
reg enable,reset;
reg [2:0] rd,rs1,rs2,s_r_amount;
reg [3:0] mem_addr;
reg [5:0] instr_mem_addr;
reg clk;
wire zero_flag,carry_flag,ac_flag,parity_flag;

executestage dut(.zero_flag(zero_flag),.result(result),.opcode(opcode),.am(am),.enable(enable),.reset(reset)
,.rd(rd),.rs1(rs1),.rs2(rs2),.mem_addr(mem_addr),.instr_mem_addr(instr_mem_addr),.clk(clk),.s_r_amount(s_r_amount)
,.carry_flag(carry_flag),.ac_flag(ac_flag),.parity_flag(parity_flag));

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
   $monitor("opcode: %b , am: %b , rd: %b, rs1: %b, rs2: %b, result: %b, zero_flag: %b, carry_flag: %b, parity_flag: %b, ac_flag: %b",
   opcode,am,rd,rs1,rs2,result,zero_flag,carry_flag,parity_flag,ac_flag);
    #2;
    opcode <= 5'b00011; am <= 1'b0; rd <= 3'b100; rs1 <= 3'b101; s_r_amount <= 1'bz; 
    rs2 <= 3'b111; mem_addr<= 4'bzzzz; enable <= 1'b1; reset <=1'b0;
    #5;
    opcode <= 5'b00001; am <= 1'b0; rd <= 3'b100; rs1 <= 3'b101; s_r_amount <= 1'bz;
    rs2 <= 3'b111; mem_addr<= 4'bzzzz; enable <= 1'b1; reset <=1'b0;
    #5;
    opcode <= 5'b01010; am <= 1'b0; rd <= 3'b100; rs1 <= 3'b101; s_r_amount <= 1'bz;
    rs2 <= 3'b111; mem_addr<= 4'bzzzz; enable <= 1'b1; reset <=1'b0;
    #5;
    opcode <= 5'b01110; am <= 1'b0; rd <= 3'bzzz; rs1 <= 3'bzzz; s_r_amount <= 3'bzzz;
    rs2 <= 3'bzzz; mem_addr<= 4'bzzzz; enable <= 1'b1; reset <=1'b0;
    #5;
    opcode <= 5'b01011; am <= 1'b0; rd <= 3'b100; rs1 <= 3'bzzz; s_r_amount <= 3'bzzz;
    rs2 <= 3'bzzz; mem_addr<= 4'bzzzz; enable <= 1'b1; reset <=1'b0;
    #5;
    opcode <= 5'b10100; am <= 1'b0; rd <= 3'b111; rs1 <= 3'bzzz; s_r_amount <= 3'b001;
    rs2 <= 3'bzzz; mem_addr<= 4'bzzzz; enable <= 1'b1; reset <=1'b0;
    #5;
    opcode <= 5'b10010; am <= 1'b0; rd <= 3'b111; rs1 <= 3'bzzz; s_r_amount <= 3'b001;
    rs2 <= 3'bzzz; mem_addr<= 4'bzzzz; enable <= 1'b1; reset <=1'b0;
    #5;
    opcode <= 5'b10000; am <= 1'b0; rd <= 3'b111; rs1 <= 3'bzzz; s_r_amount <= 3'b001;
    rs2 <= 3'bzzz; mem_addr<= 4'bzzzz; enable <= 1'b1; reset <=1'b0;
    #5;
    opcode <= 5'b00101; am <= 1'b0; rd <= 3'b111; rs1 <= 3'bzzz; s_r_amount <= 3'bzzz;
    rs2 <= 3'bzzz; mem_addr<= 4'bzzzz; enable <= 1'b1; reset <=1'b0;
    #5;
    opcode <= 5'b11111; am <= 1'bz; rd <= 3'bzzz; rs1 <= 3'bzzz; s_r_amount <= 3'bzzz;
    rs2 <= 3'bzzz; mem_addr<= 4'bzzzz; enable <= 1'b1; reset <=1'b0;
    #50 $finish;
end
endmodule //executetb
/* ./iverilog -o execute.vvp executetb.v
./vvp execute.vvp */