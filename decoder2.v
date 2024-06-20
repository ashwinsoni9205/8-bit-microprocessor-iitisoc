`timescale 1ns/1ps
module Decoder(instruction, opcode,addressing_mode,reg1,reg2,reg3,data_mem,instruction_mem);
input [15:0]instruction;
output reg [3:0]opcode; 
output reg addressing_mode;
output reg [2:0]reg1;
output reg [2:0]reg2;
output reg [2:0]reg3;
output reg [4:0]data_mem;
output reg [4:0]instruction_mem;

parameter MOVE=4'b0000, ADD=4'b0001, SUB=4'b0010, MUL=4'b0011, 
          DIV=4'b0100, INC=4'b0101, DEC=4'b0110, AND=4'b0111, 
          OR=4'b1000, NOT=4'b1001, XOR=4'b1010, LOAD=4'b1011, 
          STORE=4'b1100, JUMP=4'b1101, BRANCH=4'b1110, HALT=4'b1111;

always @(*) begin
    opcode = instruction[15:12];
    addressing_mode = instruction[11];
    //initializing values
    reg1 = 3'b000;
    reg2 = 3'b000;
    reg3 = 3'b000;
    data_mem = 5'b00000;
    instruction_mem = 5'b00000;

        case (opcode)
            MOVE: 
                begin 
                    if (addressing_mode == 1'b0) begin
                        reg1 = instruction[10:8];
                        reg2 = instruction[7:5];
                    end else begin
                        reg1 = instruction[10:8];
                        data_mem = instruction[7:3];
                    end
                end
            ADD,SUB,MUL,DIV,AND,OR,XOR:
                begin
                    if (addressing_mode == 1'b0) begin
                        reg1 = instruction[10:8];
                        reg2 = instruction[7:5];
                        reg3 = instruction[4:2];
                    end else begin
                        reg1 = instruction[10:8];
                        reg2 = instruction[7:5];
                        data_mem = instruction[4:0];
                    end
                end
            INC,DEC,NOT:
                begin
                    if (addressing_mode == 1'b0) begin
                        reg1 = instruction[10:8];
                    end else begin
                        data_mem = instruction[10:6];
                    end
                end
            LOAD:
                begin
                    reg1 = instruction[10:8];
                    data_mem = instruction[7:3];
                end
            STORE:
                begin
                    instruction_mem = instruction[10:6];
                    reg1 = instruction[5:3];
                end
            JUMP:
                begin
                    instruction_mem = instruction[10:6];
                end
            default: 
                begin
                    reg1 = 3'b000;
                    reg2 = 3'b000;
                    reg3 = 3'b000;
                    data_mem = 5'b00000;
                    instruction_mem = 5'b00000;
                end
        endcase       
    end    
endmodule