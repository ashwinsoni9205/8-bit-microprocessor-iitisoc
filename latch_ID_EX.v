module Latch_ID_EX(clk,rst,IF_ID_opcode,IF_ID_addressing_mode,IF_ID_rd,IF_ID_rs1,IF_ID_rs2,IF_ID_data_mem,IF_ID_instruction_mem,IF_ID_s_r_amount,ID_EX_opcode,ID_EX_addressing_mode,ID_EX_rd,ID_EX_rs1,ID_EX_rs2,ID_EX_data_mem,ID_EX_instruction_mem,ID_EX_s_r_amount );
input clk,rst;
input [4:0]IF_ID_opcode;
input IF_ID_addressing_mode;
input [2:0]IF_ID_rd;
input [2:0]IF_ID_rs1;
input [2:0]IF_ID_rs2;
input [3:0]IF_ID_data_mem;
input [5:0]IF_ID_instruction_mem;
input [2:0]IF_ID_s_r_amount;
output reg [4:0]ID_EX_opcode;
output reg ID_EX_addressing_mode;
output reg [2:0]ID_EX_rd;
output reg [2:0]ID_EX_rs1;
output reg [2:0]ID_EX_rs2;
output reg [3:0]ID_EX_data_mem;
output reg [5:0]ID_EX_instruction_mem;
output reg [2:0]ID_EX_s_r_amount;

always @ (*) begin
    if(clk) begin
        ID_EX_opcode = IF_ID_opcode;
        ID_EX_addressing_mode = IF_ID_addressing_mode;
        ID_EX_rd = IF_ID_rd;
        ID_EX_rs1 = IF_ID_rs1;
        ID_EX_rs2 = IF_ID_rs2;
        ID_EX_data_mem = IF_ID_data_mem;
        ID_EX_instruction_mem = IF_ID_instruction_mem;
        ID_EX_s_r_amount = IF_ID_s_r_amount;
    end
end

endmodule