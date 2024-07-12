`timescale 1ns/1ps

// Include all the necessary module files
`include "instfetch.v"
`include "decoder.v"
`include "executestage.v"
`include "writeback.v"
`include "latch_if_id.v"
`include "latch_id_ex.v"
`include "latch_ex_wb.v"
`include "controller.v"

module pipeline_processor(
    input resume,
    input restart,
    input controller_enable
);

    wire clk1,clk2,rst,enable;
    // Wires for Instruction Fetch Stage
    wire [15:0] IF_instruction;
    wire [5:0] pc_out;

    // Wires for IF/ID Latch
    wire [15:0] IF_ID_instruction;

    // Wires for Decode Stage
    wire [4:0] ID_opcode;
    wire ID_addressing_mode;
    wire [2:0] ID_rd, ID_rs1, ID_rs2;
    wire [3:0] ID_data_mem;
    wire [5:0] ID_instruction_mem;
    wire [2:0] ID_s_r_amount;

    // Wires for ID/EX Latch
    wire [4:0] ID_EX_opcode;
    wire ID_EX_addressing_mode;
    wire [2:0] ID_EX_rd, ID_EX_rs1, ID_EX_rs2;
    wire [3:0] ID_EX_data_mem;
    wire [5:0] ID_EX_instruction_mem;
    wire [2:0] ID_EX_s_r_amount;

    // Wires for Execute Stage
    wire [15:0] EX_result;
    wire EX_zero_flag, EX_carry_flag, EX_ac_flag, EX_parity_flag;

    // Wires for EX/WB Latch
    wire [4:0] EX_WB_opcode;
    wire EX_WB_am;
    wire [2:0] EX_WB_rd;
    wire [3:0] EX_WB_mem_addr;
    wire [5:0] EX_WB_instr_mem_addr;
    wire [15:0] EX_WB_result;
    wire EX_WB_zero_flag, EX_WB_carry_flag, EX_WB_ac_flag, EX_WB_parity_flag;

    // connecting the controller
    controller control(
        .clk1(clk1),
        .clk2(clk2),
        .reset(rst),
        .enable(enable),
        .halted(HALTED),
        .resume(resume),
        .restart(restart),
        .controller_enable(controller_enable)
    );
    // Instruction Fetch Stage
    instfetch IF_stage(
        .clk(clk1),
        .reset(rst),
        .instruction(IF_instruction)
    );

    // IF/ID Latch
    Latch_IF_ID IF_ID_latch(
        .clk(clk2),
        .rst(rst),
        .IF_instruction(IF_instruction),
        .IF_ID_instruction(IF_ID_instruction)
    );

    // Decode Stage
    Decoder ID_stage(
        .instruction(IF_ID_instruction),
        .opcode(ID_opcode),
        .addressing_mode(ID_addressing_mode),
        .rd(ID_rd),
        .rs1(ID_rs1),
        .rs2(ID_rs2),
        .data_mem(ID_data_mem),
        .instruction_mem(ID_instruction_mem),
        .s_r_amount(ID_s_r_amount)
    );

    // ID/EX Latch
    Latch_ID_EX ID_EX_latch(
        .clk(clk1),
        .rst(rst),
        .IF_ID_opcode(ID_opcode),
        .IF_ID_addressing_mode(ID_addressing_mode),
        .IF_ID_rd(ID_rd),
        .IF_ID_rs1(ID_rs1),
        .IF_ID_rs2(ID_rs2),
        .IF_ID_data_mem(ID_data_mem),
        .IF_ID_instruction_mem(ID_instruction_mem),
        .IF_ID_s_r_amount(ID_s_r_amount),
        .ID_EX_opcode(ID_EX_opcode),
        .ID_EX_addressing_mode(ID_EX_addressing_mode),
        .ID_EX_rd(ID_EX_rd),
        .ID_EX_rs1(ID_EX_rs1),
        .ID_EX_rs2(ID_EX_rs2),
        .ID_EX_data_mem(ID_EX_data_mem),
        .ID_EX_instruction_mem(ID_EX_instruction_mem),
        .ID_EX_s_r_amount(ID_EX_s_r_amount)
    );

    // Execute Stage
    executestage EX_stage(
        .result(EX_result),
        .zero_flag(EX_zero_flag),
        .carry_flag(EX_carry_flag),
        .ac_flag(EX_ac_flag),
        .parity_flag(EX_parity_flag),
        .opcode(ID_EX_opcode),
        .am(ID_EX_addressing_mode),
        .rd(ID_EX_rd),
        .rs1(ID_EX_rs1),
        .rs2(ID_EX_rs2),
        .mem_addr(ID_EX_data_mem),
        .instr_mem_addr(ID_EX_instruction_mem),
        .s_r_amount(ID_EX_s_r_amount),
        .enable(~HALTED),
        .reset(rst),
        .clk(clk)
    );

    // EX/WB Latch
    latch_ex_wb EX_WB_latch(
        .clk(clk2),
        .rst(rst),
        .ID_EX_opcode(ID_EX_opcode),
        .ID_EX_am(ID_EX_addressing_mode),
        .ID_EX_rd(ID_EX_rd),
        .ID_EX_mem_addr(ID_EX_data_mem),
        .ID_EX_instr_mem_addr(ID_EX_instruction_mem),
        .result(EX_result),
        .zero_flag(EX_zero_flag),
        .carry_flag(EX_carry_flag),
        .ac_flag(EX_ac_flag),
        .parity_flag(EX_parity_flag),
        .EX_WB_opcode(EX_WB_opcode),
        .EX_WB_am(EX_WB_am),
        .EX_WB_rd(EX_WB_rd),
        .EX_WB_mem_addr(EX_WB_mem_addr),
        .EX_WB_instr_mem_addr(EX_WB_instr_mem_addr),
        .EX_WB_result(EX_WB_result),
        .EX_WB_zero_flag(EX_WB_zero_flag),
        .EX_WB_carry_flag(EX_WB_carry_flag),
        .EX_WB_ac_flag(EX_WB_ac_flag),
        .EX_WB_parity_flag(EX_WB_parity_flag)
    );

    // Write Back Stage
    write_back WB_stage(
        .opcode(EX_WB_opcode),
        .am(EX_WB_am),
        .rd(EX_WB_rd),
        .mem_addr(EX_WB_mem_addr),
        .instr_mem_addr(EX_WB_instr_mem_addr),
        .clk(clk),
        .alu_out(EX_WB_result),
        .HALTED(HALTED),
        .zero_flag(EX_WB_zero_flag),
        .carry_flag(EX_WB_carry_flag),
        .auxiliary_flag(EX_WB_ac_flag),
        .parity_flag(EX_WB_parity_flag)
    );

endmodule
