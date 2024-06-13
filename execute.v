`timescale 1ns/1ps
`include "memoryBank.v"
`include "regFile.v"
`include "alu.v"
module execute (result,result_md,opcode,am,rd,rs1,rs2,mem_addr,instr_mem_addr,enable,reset);
output reg [7:0] result;
output reg [15:0] result_md;
input [3:0] opcode;
input am;
input enable,reset;
input [2:0] rd,rs1,rs2;
input [4:0] mem_addr,instr_mem_addr;

wire [7:0] rs1_data;
wire [7:0] rs2_data;
wire [7:0] mem_data;
wire [7:0] alu_out;
wire [15:0] alu_outmd;
reg [7:0] mux_1_out;
wire [7:0] mem_data_in;
wire [4:0] mem_addr_in;
wire [2:0] rd_addr;
wire [7:0] rd_data;

regFile r1(rs1_data,rs2_data,rs1,rs2,rd_addr,rd_data,enable,reset);
memoryBank m1(mem_data,mem_data_in,mem_addr,mem_addr_in,enable,reset);
alu a1(alu_out,alu_outmd,rs1_data,mux_1_out,opcode,enable,reset);

always @(*) begin
    if(am == 0)
    mux_1_out <= rs2_data;
    else
    mux_1_out <= mem_data;
end

always @(*) begin
    if(opcode == 1101)
    begin
        result <= {3'b0,instr_mem_addr};
    end
    else
    begin
        result <= alu_out;
        result_md <= alu_outmd;
    end
end

endmodule //execute