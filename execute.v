`timescale 1ns/1ps
`include "memoryBank.v"
`include "regFile.v"
`include "alu.v"
module execute (result,zero_flag,opcode,am,rd,rs1,rs2,mem_addr,instr_mem_addr,enable,reset,clk);
output  [15:0] result; // final output from stage;
output reg zero_flag;
//output  [15:0] result; // final output from stage for multiply and divide;
input [3:0] opcode;
input am; // addressing mode;
input enable,reset,clk;
input [2:0] rd,rs1,rs2; // register addereses recieved from prev stages;
input [4:0] mem_addr,instr_mem_addr; // memory addr. recieved from prev stages;

wire [7:0] operand_1,rs2_data,rd_data,mem_data;
reg[2:0] mux_1_out;
reg [7:0] mux_2_out; // for deciding operand as per addressing mode;

regFile r1(operand_1,rs2_data,mux_1_out,rs2,rd,rd_data,1,0,X);
memoryBank m1(mem_data,8'b0,mem_addr,5'b0,1,0,clk);
alu a1(result,operand_1,mux_2_out,opcode,1,0,clk);

always @( *) begin
    if(opcode == 4'b0101 || opcode == 4'b0110 || opcode == 4'b1001)
    begin
        mux_1_out <= rd;
    end
    else 
    begin
        mux_1_out <= rs1;
    end

    if(am == 0)
    begin 
        mux_2_out <= rs2_data; // operand 2 will be reg data;
    end
    else
    begin
        mux_2_out <= mem_data; // operand 2 will be mem data;
    end

    if(result == 0)
    begin
        zero_flag <= 1;
    end
    else 
    zero_flag <= 0;
end


endmodule //execute