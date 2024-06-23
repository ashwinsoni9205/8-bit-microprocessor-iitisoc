`timescale 10ns/1ns
`include "decoder2.v"
module Decoder_tb();

    reg [15:0] instruction;      // Input instruction
    reg clk;                     // Clock signal
    
    // Outputs from InstructionDecoder module
    wire [4:0] opcode;            // Output: Opcode
    wire addressing_mode;         // Output: Addressing mode
    wire [2:0] rd;              // Output: Register 1
    wire [2:0] rs1;              // Output: Register 2
    wire [2:0] rs2;              // Output: Register 3      
    wire [3:0]data_mem;
    wire [5:0]instruction_mem;
    wire [2:0]s_r_amount;
    integer infile, outfile, r;
         
    // Instantiate the InstructionDecoder module
    Decoder dut (
        .instruction(instruction),
        .opcode(opcode),
        .addressing_mode(addressing_mode),
        .rd(rd),
        .rs1(rs1),
        .rs2(rs2),
        .data_mem(data_mem),
        .instruction_mem(instruction_mem),
        .s_r_amount(s_r_amount)
        );
    
    always #5 clk = ~clk;
     
    initial begin
        clk = 0; // Initialize clock
        infile = $fopen("instruct.txt", "r");
        if (infile == 0) begin
        $display("Failed to open file.");
        $finish;
        end
        outfile = $fopen("output.txt", "w");
        if (outfile == 0) begin
        $display("Failed to open output file.");
        $fclose(infile);
        $finish;
        end

        // Read values from the file and apply them to the module

        while (!$feof(infile)) begin
        r = $fscanf(infile, "%b\n", instruction);    // Read a binary number from the file
        #10;  
        $fwrite(outfile,"Instruction: %b\n", instruction);
        $fwrite(outfile,"Opcode: %b\n", opcode);
        $fwrite(outfile,"Addressing Mode: %b\n", addressing_mode);
        $fwrite(outfile,"rd: %b, rs1: %b, rs2: %b\n", rd, rs1, rs2);
        $fwrite(outfile,"Data_mem: %b\n", data_mem);
        $fwrite(outfile,"Instruction_mem:%b\n", instruction_mem);
        $fwrite(outfile,"s_r_amount:%b\n", s_r_amount);
        $fwrite(outfile,"\n");
  // Write the output to the output file
        end

    $fclose(infile);
    $fclose(outfile);
    $finish;
    end
endmodule
        
