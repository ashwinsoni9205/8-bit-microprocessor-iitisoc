`timescale 1ns/1ps
module alu (alu_out, operand_1, operand_2, opcode, enable, reset,clk);

output reg [15:0] alu_out;
input [7:0] operand_1 , operand_2;
input [3:0] opcode;
input enable,reset,clk;

always @(*) 
begin
    if(reset)
    begin
        alu_out <= 8'b0;
    end
    else
        begin
        if(enable)
            begin
            case(opcode)
                4'b0000 : alu_out <= operand_1;
                4'b0001 : alu_out <= operand_1 + operand_2; // addition
                4'b0010 : alu_out <= operand_1 - operand_2; // subtraction
                4'b0011 : alu_out <= operand_1 * operand_2; // multiplication
                4'b0100 : alu_out <= operand_1 / operand_2; // division
                4'b0101 : alu_out <= operand_1 + 1; // increment 
                4'b0110 : alu_out <= operand_1 - 1; // decrement
                4'b0111 : alu_out <= operand_1 & operand_2; // AND
                4'b1000 : alu_out <= operand_1 | operand_2; // OR
                4'b1001 : alu_out <= ~operand_1; // NOT
                4'b1010 : alu_out <= operand_1 ^ operand_2; // XOR
                4'b1011 : alu_out <= operand_1 ; // load
                4'b1100 : alu_out <= operand_1 ; // load
                4'b1101 : alu_out <= operand_1 ; // jump
                4'b1110 : alu_out <= operand_1 ; // branch
                4'b1111 : begin alu_out <= 8'bx; // halt
                        end
                default : begin 
                     alu_out <= 8'bx;
                    end
                    
            endcase
            end
        else
        begin
            alu_out <= 8'bx;
        end
    end
end
endmodule //alu
