module Latch_IF_ID(clk, rst,IF_instruction, IF_ID_instruction,);
input clk,rst;
input [15:0]IF_instruction;
output reg [15:0] IF_ID_instruction;
always @(clk) begin
  if(clk && rst)begin
    IF_ID_instruction = IF_instruction;
  end
end

endmodule