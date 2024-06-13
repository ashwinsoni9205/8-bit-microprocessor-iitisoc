`timescale 1ns/1ps;
module alu (alu_out, alu_outmd, operand_1, operand_2, opcode, enable, reset);

output reg [7:0] alu_out;
output reg [15:0] alu_outmd;
input [7:0] operand_1 , operand_2;
input [3:0] opcode;
input enable,reset;

always @( *) 
begin
    if(reset)
    begin
        alu_out <= 8'b0;
        alu_outmd <= 16'b0;
    end
    else
        begin
        if(enable)
            begin
            case(opcode)
                0000 : alu_out <= operand_1;
                0001 : alu_out <= operand_1 + operand_2; // addition
                0010 : alu_out <= operand_1 - operand_2; // subtraction
                0011 : alu_outmd <= operand_1 * operand_2; // multiplication
                0100 : alu_outmd <= operand_1 / operand_2; // division
                0101 : alu_out <= operand_1 + 1; // increment 
                0110 : alu_out <= operand_1 - 1; // decrement
                0111 : alu_out <= operand_1 & operand_2; // AND
                1000 : alu_out <= operand_1 | operand_2; // OR
                1001 : alu_out <= ~operand_1; // NOT
                1010 : alu_out <= operand_1 ^ operand_2; // XOR
                1011 : alu_out <= operand_1 ; // load
                1100 : alu_out <= operand_1 ; // load
                1101 : alu_out <= operand_1 ; // jump
                1110 : alu_out <= operand_1 ; // branch
                1111 : begin alu_out <= 8'bx; // halt
                            alu_outmd <= 16'bx;
                        end
            endcase
            end
        else
        begin
            alu_out <= 8'bx;
            alu_outmd <= 16'bx;
        end
    end
end
endmodule //alu
