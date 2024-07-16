`timescale 1ns/1ps
module executestage (
output  reg [15:0] result, // final output from stage;
output reg zero_flag,carry_flag,ac_flag,parity_flag, // all flag registers,

input [4:0] opcode,
input [2:0] s_r_amount,
input am, // addressing mode,
input enable,reset,clk,
input [2:0] rd,rs1,rs2, // register addereses recieved from prev stages,
input [3:0] mem_addr,
input [5:0] instr_mem_addr, // memory addr. recieved from prev stages;
input [7:0] rs2_data,operand_1,
output reg[2:0] mux_1_out, // to decide from where the operand_1 will come;
input [7:0] mem_data
);


reg [7:0] operand_2;

reg [7:0] temp;

integer i;

always @( *) begin

    if(opcode == 5'b00101 || opcode == 5'b00110 || opcode == 5'b01001 || opcode == 5'b10000
    || opcode == 5'b10001 || opcode == 5'b10010 || opcode == 5'b10011 || opcode == 5'b10100
    || opcode == 5'b10101 || opcode == 5'b01100)
    begin
        mux_1_out <= rd;
    end
    else 
    begin
        mux_1_out <= rs1;
    end

    if(am == 0)
    begin 
        operand_2 <= rs2_data; // operand 2 will be reg data;
    end
    else if(am == 1)
    begin
        operand_2 <= mem_data; // operand 2 will be mem data;
    end
end

    always @(*) 
begin
    if(reset == 1)
    begin
        result = 16'bz;
        zero_flag = 1'bz;
        carry_flag = 1'bz;
        ac_flag = 1'bz;
        parity_flag = 1'bz;
        mux_1_out = 3'bz;
    end
    else
        begin
        if(enable)
            begin
            case(opcode)
                5'b00000 : begin
                result[15:8] <= 8'bx;
                if(am == 0)
                result[7:0] <= operand_1;
                else
                result[7:0] <= operand_2;
                end // move

                5'b00001 : begin
                    result[15:8] <= 8'bx;
                    {carry_flag,result[7:0]} <= operand_1 + operand_2;
                    end // addition {done [8:0] so that we can detect carry from the 9th bit}

                5'b00010 : begin
                    result[15:8] <= 8'bx;
                    {carry_flag,result[7:0]} <= operand_1 - operand_2;
                    end // subtraction

                5'b00011 : result <= operand_1 * operand_2; // multiplication
                
                5'b00100 : begin 
                    result[7:0] <= operand_1 / operand_2;
                    result[15:8] <= operand_1 % operand_2;
                end // division

                5'b00101 : begin
                    result[15:8] <= 8'bx;
                    if(am == 0)
                    {carry_flag,result[7:0]} <= operand_1 + 1;
                    else
                    {carry_flag,result[7:0]} <= operand_2 + 1;
                    end // increment

                5'b00110 : begin
                    result[15:8] <= 8'bx;
                    if(am == 0)
                    {carry_flag,result[7:0]} <= operand_1 - 1;
                    else
                    {carry_flag,result[7:0]} <= operand_2 - 1;
                    end // decrement

                5'b00111 : begin
                    result[15:8] <= 8'bx;
                    result[7:0] <= operand_1 & operand_2;
                    end // AND

                5'b01000 : begin
                    result[15:8] <= 8'bx;
                    result[7:0] <= operand_1 | operand_2;
                    end // OR

                5'b01001 : begin
                    result[15:8] <= 8'bx;
                    if(am == 0)
                    result[7:0] <= ~operand_1;
                    else
                    result[7:0] <= ~operand_2;
                    end // NOT

                5'b01010 : begin
                    result[15:8] <= 8'bx;
                    result[7:0] <= operand_1 ^ operand_2;
                    end // XOR

                5'b01011 : begin
                    result[15:8] <= 8'bx;
                    result[7:0] <= mem_data;
                    end // load mem to reg;

                5'b01100 : begin
                    result[15:8] <= 8'bx;
                    result[7:0] <= operand_1;
                    end // load reg to mem;    

                5'b01101 : begin
                    result[15:0] <= 16'bx;
                    end // jump

                5'b01110 | 5'b10110 | 5'b10111 | 5'b11000 : begin
                    result[15:0] <= 16'bx;
                    end // branch

                5'b10000 : begin
                    result[15:8] <= 8'bx;
                    if(am == 0)
                    {carry_flag,result[7:0]} <= operand_1[7:0] << s_r_amount;
                    else
                    {carry_flag,result[7:0]} <= operand_2[7:0] << s_r_amount;
                    end // arithmetic shift left

                5'b10001 : begin
                    result[15:8] <= 8'bx;
                    if(am==0)
                    temp = operand_1;
                    else
                    temp = operand_2;
                    for (i = 0; i < s_r_amount; i = i + 1) begin
                        carry_flag = temp[0];
                        temp[7:0] = {temp[7],temp[7:1]}; 
                    end
                    result[7:0] = temp;
                    end // arithmetic shift right 

                5'b10010 : begin
                    result[15:8] <= 8'bx;
                    if(am == 0)
                    {carry_flag,result[7:0]} <= operand_1[7:0] << s_r_amount; 
                    else
                    {carry_flag,result[7:0]} <= operand_2[7:0] << s_r_amount; 
                    end // logical shift left

                5'b10011 : begin
                    result[15:8] <= 8'bx;
                    if(am == 0)
                    {result[7:0],carry_flag} <= operand_1[7:0] >> s_r_amount;  
                    else                    
                    {result[7:0],carry_flag} <= operand_2[7:0] >> s_r_amount;  
                    end // logical shift right

                5'b10100 : begin
                    result[15:8] <= 8'bx;
                    if(am == 0)
                    temp = operand_1;
                    else
                    temp = operand_2;
                    for (i = 0; i < s_r_amount; i = i + 1) begin
                    temp[7:0] = {temp[6:0],temp[7]};
                    end
                    result[7:0] = temp;
                end // rotate left

                5'b10101 : begin
                    result[15:8] <= 8'bx;
                    if(am == 0)
                    temp = operand_1;
                    else
                    temp = operand_2;
                    for (i = 0; i < s_r_amount; i = i + 1) begin
                    temp[7:0] = {temp[0],temp[7:1]};
                    end
                    result[7:0] = temp;
                end // rotate right;

                5'b11001 : begin
                    result[15:1] <= 15'bx;
                    if(operand_1 >= operand_2)
                    result[0] <= 1;
                    else
                    result[0] <= 0;
                end // compare;

                5'b11111 : result <= 8'bx; 
                default : begin
                     result <= 8'bx;
                    end // halt
                    
            endcase
            end
        else
        begin
            result <= 8'bx;
        end
    end

    // updating zero_flag
    if(reset)
    zero_flag <= 1'bz;

    else
    begin
    if(opcode == 5'b00011)
    begin
        if(result == 0)
            begin
            zero_flag <= 1;
            end
        else 
            zero_flag <= 0;
    end
    else
    begin
        if(result[7:0] == 0)
            begin
            zero_flag <= 1;
            end
        else 
            zero_flag <= 0;
    end
    end

    // updating carry_flag during the operation

    // updating auxilliary carry - ac_flag
    if(opcode == 5'b00001) // addition case
    begin
        {ac_flag,temp[3:0]} = operand_1[3:0] + operand_2[3:0];
    end
    else if(opcode == 5'b00010) // subtraction case
    begin
        {ac_flag,temp[3:0]} = {1'b0,operand_1[3:0]} - {1'b0,operand_2[3:0]};
    end
    else if(opcode == 5'b00101) // increment case
    begin
        {ac_flag,temp[3:0]} = operand_1[3:0] + 1'b1;
    end
    else if(opcode == 5'b00110) // decrement case
    begin
        {ac_flag,temp[3:0]} = {1'b0,operand_1[3:0]} - 1'b1;
    end

    // updating parity_flag
    if(reset)
    parity_flag <= 1'bz;

    else
    begin
    if(opcode == 5'b00011)
    begin
        parity_flag = 0;
        for(i = 0 ; i < 16 ; i = i + 1)
        begin
        parity_flag = parity_flag^result[i];
        end
    end
    else if(opcode == 5'b11001)
    begin
        parity_flag = 0;
        parity_flag = parity_flag^result[0];
    end
    else if(opcode ==5'b01110 || opcode == 5'b10110 || opcode == 5'b10111 
    || opcode == 5'b11000 || opcode == 5'b01011 || opcode == 5'b01100)
    begin
    parity_flag = parity_flag;
    end
    else
    begin
        parity_flag = 0;
        for(i = 0 ; i < 8 ; i = i + 1)
        begin
            parity_flag = parity_flag^result[i];
        end
    end
    end

end
endmodule //execute
/* ./iverilog -o execute.vvp executetb.v
 ./vvp execute.vvp */