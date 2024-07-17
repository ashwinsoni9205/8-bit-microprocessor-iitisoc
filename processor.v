`timescale 1ns/1ps

// Include all the necessary module files
`include "instfetch.v"
`include "decoder2.v"
`include "executestage.v"
`include "write_back.v"
`include "Latch_IF_ID.v"
`include "latch_ID_EX.v"
`include "EX_WB_Latch.v"
`include "controller.v"
`include "regFile.v"
`include "pc.v"
`include "memoryBank.v"
`include "instmem.v"

module pipeline_processor(
    input main_clk,
    input resume,
    input restart,
    input controller_enable
);
    reg r_w_clock, main_clk_reg;
    wire clk1, clk2, rst, enable, loadPC_wire, temp_wire, input_length_wire, HALTED, flush,flush_detected;
    wire [7:0] rs2_data_wire, operand_1, mem_data_wire, mem_data_in_wire;
    wire [5:0] address_wire, execadd_wire;
    // Wires for Instruction Fetch Stage
    wire [15:0] IF_instruction, rd_data_wire;
    wire [5:0] pc_out;

    // Wires for IF/ID Latch
    wire [15:0] IF_ID_instruction;

    // Wires for Decode Stage
    wire [4:0] ID_opcode;
    wire ID_addressing_mode, r_w_reg_wire, r_w_mem_wire;
    wire [2:0] ID_rd, ID_rs1, ID_rs2, mux_1_out_wire;
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

    always @(clk1 or clk2) begin
        if(clk2)
            r_w_clock = 1;
        else if(clk1)
            r_w_clock = 0; 
        else
            r_w_clock = 1;
    end
    
    always @(*) begin
        if(controller_enable) begin
            main_clk_reg <= main_clk;
        end else begin
            main_clk_reg <= 0;
        end
    end
    
    pc p1(
        .incPC(temp_wire),
        .execadd(execadd_wire),
        .reset(rst),
        .loadPC(loadPC_wire),
        .address(address_wire)
    );
    regFile r1(
        .rs1_data(operand_1),
        .rs2_data(rs2_data_wire),
        .rs1_addr(mux_1_out_wire),
        .rs2_addr(ID_EX_rs2),
        .rd_addr(EX_WB_rd),
        .rd_data(rd_data_wire),
        .r_w(r_w_reg_wire),
        .input_length(input_length_wire)
    );
    memoryBank m1(
        .mem_data_out(mem_data_wire),
        .mem_data_in(mem_data_in_wire),
        .mem_addr_in(EX_WB_mem_addr),
        .mem_addr_out(ID_EX_data_mem),
        .r_w(r_w_mem_wire),
        .enable(enable),
        .reset(rst),
        .clk(clk1)
    );
    instmem i1(
        .instruction(IF_instruction),
        .pc(execadd_wire),
        .reset(rst),
        .enable(enable)
    );

    // connecting the controller
    controller control(
        .internal_clock(main_clk_reg),
        .clk1(clk1),
        .clk2(clk2),
        .reset(rst),
        .enable(enable),
        .halted(HALTED),
        .resume(resume),
        .restart(restart),
        .controller_enable(controller_enable),
        .flush(flush),
        .flush_detected(flush_detected)
    );
    
    // Instruction Fetch Stage
    instfetch IF_stage(
        .clk(clk2),
        .reset(rst),
        .instruction(IF_instruction),
        .temp(temp_wire),
        .execadd(execadd_wire)
    );

    // IF/ID Latch
    Latch_IF_ID IF_ID_latch(
        .clk(clk1),
        .rst(rst | flush),
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
        .rst(rst | flush),
        .data_mem(ID_data_mem),
        .instruction_mem(ID_instruction_mem),
        .s_r_amount(ID_s_r_amount)
    );

    // ID/EX Latch
    Latch_ID_EX ID_EX_latch(
        .clk(clk2),
        .rst(rst | flush),
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
        .reset(rst | flush),
        .rs2_data(rs2_data_wire),
        .operand_1(operand_1),
        .mux_1_out(mux_1_out_wire),
        .mem_data(mem_data_wire)
    );

    // EX/WB Latch
    latch_ex_wb EX_WB_latch(
        .clk(clk1),
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
        .reset(rst),
        .mem_addr(EX_WB_mem_addr),
        .instr_mem_addr(EX_WB_instr_mem_addr),
        .clk(clk2),
        .alu_out(EX_WB_result),
        .HALTED(HALTED),
        .zero_flag(EX_WB_zero_flag),
        .carry_flag(EX_WB_carry_flag),
        .auxiliary_flag(EX_WB_ac_flag),
        .parity_flag(EX_WB_parity_flag),
        .loadPC(loadPC_wire),
        .address(address_wire),
        .rd_data(rd_data_wire),
        .input_length(input_length_wire),
        .r_w_reg(r_w_reg_wire),
        .mem_data_in(mem_data_in_wire),
        .r_w_mem(r_w_mem_wire),
        .flush_pipeline(flush_detected)
    );

endmodule
