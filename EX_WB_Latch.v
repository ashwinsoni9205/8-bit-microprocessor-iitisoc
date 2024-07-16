
`timescale 1ns / 1ps

module latch_ex_wb (
    input clk,
    input rst,
    input [4:0] ID_EX_opcode,   
    input ID_EX_am,  
    input [2:0] ID_EX_rd,
    input [3:0] ID_EX_mem_addr,
    input [5:0] ID_EX_instr_mem_addr,
    input [15:0] result,
    input zero_flag,
    input carry_flag,
    input ac_flag,
    input parity_flag,
    output reg [4:0] EX_WB_opcode,
    output reg EX_WB_am,
    output reg [2:0] EX_WB_rd,
    output reg [3:0] EX_WB_mem_addr,
    output reg [5:0] EX_WB_instr_mem_addr,
    output reg [15:0] EX_WB_result,
    output reg EX_WB_zero_flag,
    output reg EX_WB_carry_flag,
    output reg EX_WB_ac_flag,
    output reg EX_WB_parity_flag
);

    always @ (*) begin
        if (rst) begin
            EX_WB_opcode = 5'bz;
            EX_WB_am = 1'bz;
            EX_WB_rd = 3'bz;
            EX_WB_mem_addr = 4'bz;
            EX_WB_instr_mem_addr = 6'bz;
            EX_WB_result = 16'bz;
            EX_WB_zero_flag = 1'bz;
            EX_WB_carry_flag = 1'bz;
            EX_WB_ac_flag = 1'bz;
            EX_WB_parity_flag = 1'bz;
        end else if (clk) begin
            EX_WB_opcode = ID_EX_opcode;
            EX_WB_am = ID_EX_am;
            EX_WB_rd = ID_EX_rd;
            EX_WB_mem_addr = ID_EX_mem_addr;
            EX_WB_instr_mem_addr = ID_EX_instr_mem_addr;
            EX_WB_result = result;
            EX_WB_zero_flag = zero_flag;
            EX_WB_carry_flag = carry_flag;
            EX_WB_ac_flag = ac_flag;
            EX_WB_parity_flag = parity_flag;
        end
    end
endmodule
