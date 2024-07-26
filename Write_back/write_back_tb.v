`timescale 1ns/1ps
`include "write_back.v"

module tb_write_back();

    reg [4:0] opcode;
    reg am;
    reg [2:0] rd;
    reg [3:0] mem_addr;
    reg [5:0] instr_mem_addr;
    reg clk;
    reg [15:0] alu_out;
    wire HALTED;
    reg zero_flag;
    reg carry_flag;
    reg auxiliary_flag;
    reg parity_flag;
    write_back dut (.opcode(opcode),.am(am),.rd(rd),.mem_addr(mem_addr),.instr_mem_addr(instr_mem_addr),.clk(clk),.alu_out(alu_out),.HALTED(HALTED),.zero_flag(zero_flag),.carry_flag(carry_flag),.auxiliary_flag(auxiliary_flag),.parity_flag(parity_flag));

    integer i;
    
    always #5 clk = ~clk;

    initial begin
        #0;
        for (i = 0; i < 8; i = i + 1) begin
            $display("register: %b",dut.r1.registers[i]);
        end
         for (i = 0; i < 16; i = i + 1) begin
             $display("memory: %b",dut.m1.memory[i]);
        end
        //  (ADD operation)
        opcode = 5'b00001; // ADD
        alu_out = 16'bxxxxxxxx11000000;
        rd = 3'b001; // Register 1
        am = 0;
        #10;
        for (i = 0; i < 8; i = i + 1) begin
            $display("register: %b",dut.r1.registers[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin
             $display("memory: %b",dut.m1.memory[i]);
        end

        //  (INC operation FOR MEMORY)
        opcode = 5'b00101; // ADD
        alu_out = 16'bxxxxxxxx00000011;
        mem_addr=4'b0000;
        am = 1;
        #10;
        for (i = 0; i < 8; i = i + 1) begin
            $display("register: %b",dut.r1.registers[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin
             $display("memory: %b",dut.m1.memory[i]);
        end
       
        //   (STORE operation)
        opcode = 5'b01100; 
        alu_out = 16'bxxxxxxxx01000000;
        mem_addr = 4'b0010; 
        am = 0;
        #10;
        for (i = 0; i < 8; i = i + 1) begin
            $display("register: %b",dut.r1.registers[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin
            $display("memory: %b",dut.m1.memory[i]);
        end

        //  (JUMP operation)
        opcode = 5'b01101; // JUMP
        instr_mem_addr = 6'b000101; // New PC address
        #10;
        for (i = 0; i < 8; i = i + 1) begin
            $display("register: %b",dut.r1.registers[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin
             $display("memory: %b",dut.m1.memory[i]);
        end
        $display("pc: %b",dut.p1.execadd);
         if (dut.p1.execadd == 6'b000101) begin
            $display("JUMP instruction succeeded." ) ;
        end else begin
            $display("JUMP instruction failed. pc = %b", dut.p1.execadd);
        end

        //MUL operation
        opcode=5'b00011;
        rd=3'b011;
        am=0;
        alu_out=16'b1111111001000000;
        #10;
        for (i = 0; i < 8; i = i + 1) begin
            $display("register: %b",dut.r1.registers[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin
             $display("memory: %b",dut.m1.memory[i]);
        end

        //  (BEQZ operation)
        opcode = 5'b01110; // JUMP
        instr_mem_addr = 6'b000100; // New PC address
        zero_flag=0;
        #10;
        $display("pc: %b",dut.p1.execadd);
        zero_flag=1;
        #10
        for (i = 0; i < 8; i = i + 1) begin
            $display("register: %b",dut.r1.registers[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin
             $display("memory: %b",dut.m1.memory[i]);
        end
        $display("pc: %b",dut.p1.execadd);//value of pc changes only after zero_flag set to 1
        if (dut.p1.execadd == 6'b000100) begin
            $display("BRANCH instruction succeeded." ) ;
        end else begin
            $display("BRANCH instruction failed. pc = %b", dut.p1.execadd);
        end

        //  (BPAR operation)
        opcode = 5'b11000; // JUMP
        instr_mem_addr = 6'b000101; // New PC address
        parity_flag=0;
        #10;
        $display("pc: %b",dut.p1.execadd);
        parity_flag=1;
        #10;
        for (i = 0; i < 8; i = i + 1) begin
            $display("register: %b",dut.r1.registers[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin
             $display("memory: %b",dut.m1.memory[i]);
        end
        $display("pc: %b",dut.p1.execadd);//value of pc changes only after zero_flag set to 1
        if (dut.p1.execadd == 6'b000101) begin
            $display("BRANCH_parity instruction succeeded." ) ;
        end else begin
            $display("BRANCH_parity instruction failed. pc = %b", dut.p1.execadd);
        end

        //  HALT operation
        opcode = 5'b11111; // HALT
        #10;
        for (i = 0; i < 8; i = i + 1) begin
            $display("register: %b",dut.r1.registers[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin
             $display("memory: %b",dut.m1.memory[i]);
        end
        #20;
        $finish;
    end

    initial begin
        $monitor("Time: %0t | opcode: %b | am: %b | rd: %b | mem_addr: %b | instr_mem_addr: %b | alu_out: %h | HALTED: %b | zero_flag: %b | carry_flag: %b | auxiliary_flag: %b | parity_flag: %b", 
                 $time, opcode, am, rd, mem_addr, instr_mem_addr, alu_out, HALTED,zero_flag,carry_flag,auxiliary_flag,parity_flag);
    end

endmodule
/* ./iverilog -o writeback.vvp writebacktb.v 
./vvp writeback.vvp */
