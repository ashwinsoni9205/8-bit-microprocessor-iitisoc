`timescale 1ns/1ps
`include "memoryBank.v"
`include "regFile.v"
`include "alu.v"
module execute (result,result_md,opcode,am,rd,rs1,rs2,mem_addr,instr_mem_addr,enable,reset,clk);
output  [7:0] result;
output  [15:0] result_md;
input [3:0] opcode;
input am;
input enable,reset,clk;
input [2:0] rd,rs1,rs2;
input [4:0] mem_addr,instr_mem_addr;

wire [7:0] rs1_data,rs2_data,rd_data,mem_data;
reg [7:0] mux_1_out;

regFile r1(rs1_data,rs2_data,rs1,rs2,rd,rd_data,1,0,clk);
memoryBank m1(mem_data,8'b0,mem_addr,5'b0,1,0,clk);
alu a1(result,result_md,rs1_data,mux_1_out,opcode,1,0,clk);

always @( *) begin
    if(am == 0)
    begin 
        mux_1_out <= rs2_data;
    end
    else
    begin
        mux_1_out <= mem_data;
    end
end

endmodule //execute