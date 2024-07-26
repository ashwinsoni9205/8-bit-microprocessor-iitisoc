module Decoder(instruction, opcode,addressing_mode,rd,rs1,rs2,data_mem,instruction_mem,s_r_amount,rst);
input [15:0]instruction;
input rst;
output reg [4:0]opcode; 
output reg addressing_mode;
output reg [2:0]rd;
output reg [2:0]rs1;
output reg [2:0]rs2;
output reg [3:0]data_mem;
output reg [5:0]instruction_mem;
output reg [2:0]s_r_amount;

parameter MOVE=5'b00000, ADD=5'b00001, SUB=5'b00010, MUL=5'b00011, 
          DIV=5'b00100, INC=5'b00101, DEC=5'b00110, AND=5'b00111, 
          OR=5'b01000, NOT=5'b01001, XOR=5'b01010, LOAD=5'b01011, 
          STORE=5'b01100, JUMP=5'b01101, BEQZ=5'b01110, HALT=5'b11111,      // BEQZ: Branch if equal to zero
          ASHL=5'b10000, ASHR=5'b10001, LSHL=5'b10010, LSHR=5'b10011,       // ASHL: Arithmetic Shift Left, LSHL: Logical Shift Left
          ROTL=5'b10100, ROTR=5'b10101,BC=5'b10110, BAUX=5'b10111,          // ROTL: Rotate Left, BC: Branch if carry flag is set, BAUX: Branch if Auxialiary carry flag is set
          BPAR=5'b11000, COMPARE=5'b11001  ;                                // BPAR: Branch if parity flag is set

always @(*) begin
    rd = 3'bzzz;
    rs1 = 3'bzzz;
    rs2 = 3'bzzz;
    data_mem = 4'bzzzz;
    instruction_mem = 6'bzzzzzz;
    s_r_amount = 3'bzzz;
    opcode = instruction[15:11];
    addressing_mode = instruction[10];
    if(~rst) begin
        case (opcode)
            MOVE: 
                begin 
                    if (addressing_mode == 1'b0) begin
                        rd = instruction[9:7];
                        rs1 = instruction[6:4];
                    end else begin
                        rd = instruction[9:7];
                        data_mem = instruction[6:3];
                    end
                end
            ADD,SUB,MUL,DIV,AND,OR,XOR,COMPARE:
                begin
                    if (addressing_mode == 1'b0) begin
                        rd = instruction[9:7];
                        rs1 = instruction[6:4];
                        rs2 = instruction[3:1];
                    end else begin
                        rd = instruction[9:7];
                        rs1 = instruction[6:4];
                        data_mem = instruction[3:0];
                    end
                end
            INC,DEC,NOT:
                begin
                    if (addressing_mode == 1'b0) begin
                        rd = instruction[9:7];
                    end else begin
                        data_mem = instruction[9:6];
                    end
                end
            LOAD:
                begin
                    rd = instruction[9:7];
                    data_mem = instruction[6:3];
                end
            STORE:
                begin
                    data_mem = instruction[9:6];
                    rd = instruction[5:3];
                end
            JUMP,BEQZ,BC,BAUX,BPAR:
                begin
                    instruction_mem = instruction[9:4];
                end
            ASHL,ASHR,LSHL,LSHR,ROTL,ROTR:
                begin
                    if (addressing_mode == 1'b0) begin
                        rd = instruction[9:7];
                        s_r_amount = instruction[6:4];
                    end else begin
                        data_mem = instruction[9:6];
                        s_r_amount = instruction[5:3];
                    end
                end
            default: 
                begin
                    rd = 3'bzzz;
                    rs1 = 3'bzzz;
                    rs2 = 3'bzzz;
                    data_mem = 4'bzzzz;
                    instruction_mem = 6'bzzzzzz;
                    s_r_amount=3'bzzz;
                end
        endcase 
    end
    end    
endmodule
