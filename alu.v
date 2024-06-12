`timescale 1ns/1ps;
module alu (alu_out, operand_1 , operand_2 , opcode);

output [7:0] alu_out;
input [7:0] operand_1 , operand_2;
input [3:0] opcode;

always @( *) begin
    case(opcode)
    0000 : alu_out <= operand_1;
    0001 : alu_out <= operand_1 + operand_2; // addition
    0010 : alu_out <= operand_1 - operand_2; // subtraction
    // 0011 multiplication
    // 0100 division
    0101 : alu_out <= operand_1 + 1; // increment 
    0110 : alu_out <= operand_1 - 1;
    0111 : alu_out <= operand_1 & operand_2;
    1000 : alu_out <= operand_1 | operand_2;
    1001 : alu_out <= ~operand_1;
    1010 : alu_out <= operand_1 ^ operand_2;
    1011 : alu_out <= operand_1 ;
    1100 : alu_out <= operand_1 ;
    1101 : alu_out <= operand_1 ;
    1110 : alu_out <= operand_1 ;
    1111 : alu_out <= 16'bx;
    endcase
end
endmodule //alu
