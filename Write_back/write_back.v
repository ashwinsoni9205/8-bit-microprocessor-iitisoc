`timescale 1ns/1ps

module write_back (
    input reset,
    input [4:0] opcode,
    input am,
    input [2:0] rd,
    input [3:0] mem_addr,
    input [5:0] instr_mem_addr,
    input clk,
    input [15:0] alu_out,
    output reg HALTED,
    input zero_flag,
    input carry_flag,
    input auxiliary_flag,
    input parity_flag,
    output reg loadPC,
    output reg [5:0] address,
    output reg [15:0] rd_data,
    output reg input_length,
    output reg r_w_reg,
    output reg r_w_mem,
    output reg [7:0] mem_data_in // data to be saved in memory

);
    reg r_w;
    wire [7:0] rs1_data, rs2_data, mem_data_out;
    
    reg incPC;

    parameter MOVE = 5'b00000, ADD = 5'b00001, SUB = 5'b00010, MUL = 5'b00011, 
              DIV = 5'b00100, INC = 5'b00101, DEC = 5'b00110, AND = 5'b00111, 
              OR = 5'b01000, NOT = 5'b01001, XOR = 5'b01010, LOAD = 5'b01011, 
              STORE = 5'b01100, JUMP = 5'b01101, BEQZ = 5'b01110, HALT = 5'b11111,      
              ASHL = 5'b10000, ASHR = 5'b10001, LSHL = 5'b10010, LSHR = 5'b10011,       
              ROTL = 5'b10100, ROTR = 5'b10101, BC = 5'b10110, BAUX = 5'b10111,          
              BPAR = 5'b11000, COMPARE = 5'b11001;

    always @(*)
    begin
    if(reset)
    begin
        HALTED = 1'bz;
        loadPC = 1'bz;
        address = 6'bz;
        rd_data = 16'bz;
        input_length = 1'bz;
        r_w_reg = 1'bz;
        r_w_mem = 1'bz;
        mem_data_in = 8'bz;
    end
    else begin
        HALTED <= 0;
        input_length = 1'b0;
        loadPC = 1'b0;  
        r_w_mem = 1'bz;
        r_w_reg = 1'bz;
        if(clk)
        begin
            r_w_reg = 1;
            r_w_mem = 1;
            #2;
            r_w_reg = 1'bz;
            r_w_mem = 1'bz;
        end

        case(opcode)
            MOVE, ADD, SUB, AND, OR, XOR, COMPARE, LOAD: begin 
                rd_data = alu_out;
                r_w_reg = 0;
                #1;
                r_w_reg = 1'bz;
                if (opcode == LOAD) 
                begin 
                    r_w_mem = 1'b1; 
                    #1;
                    r_w_mem = 1'bz;
                end
            end
            MUL, DIV: begin
                input_length = 1'b1;
                rd_data = alu_out;
                r_w_reg = 0;
                #1;
                r_w_reg = 1'bz;
            end
            INC, DEC, NOT, ASHL, ASHR, LSHL, LSHR, ROTL, ROTR: begin
                if (am == 1'b0) 
                begin
                    rd_data = alu_out;
                    r_w_reg = 0;
                    #1;
                    r_w_reg = 1'bz;
                end
                else begin
                    mem_data_in = alu_out;
                    r_w_mem = 1'b0;
                    #1;
                    r_w_mem = 1'bz;
                    r_w = 1'b0; 
                end
            end
            STORE: begin
                mem_data_in = alu_out;
                r_w_mem = 1'b0;
                #1;
                r_w_mem = 1'bz; 
            end
            JUMP: begin
                address <= instr_mem_addr;
                loadPC = 1'b1;
            end 
            BEQZ: if(zero_flag) begin
                address <= instr_mem_addr;
                loadPC = 1'b1;
            end
            BC: if(carry_flag) begin
                address <= instr_mem_addr;
                loadPC = 1'b1;
            end
            BAUX: if(auxiliary_flag) begin
                address <= instr_mem_addr;
                loadPC = 1'b1;
            end
            BPAR: if(parity_flag) begin
                address <= instr_mem_addr;
                loadPC = 1'b1;
            end    
            HALT: begin
                HALTED <= 1'b1;
            end
            default: ;
        endcase
        end
    end
endmodule