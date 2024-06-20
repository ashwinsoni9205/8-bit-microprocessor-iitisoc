`include "pc.v"
`timescale 1ns/1ns

module pc_tb;

    reg clk;
    reg loadPC;
    reg incPC;
    reg [15:0] address;
    wire [15:0] execadd;

    pc uut (
        .clk(clk),
        .loadPC(loadPC),
        .incPC(incPC),
        .address(address),
        .execadd(execadd)
    );

  
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10 ns clock period
    end

    initial begin
       
        loadPC = 0;
        incPC = 0;
        address = 16'b0;

        // Reset PC
        #10 loadPC = 0; incPC = 0;
        #10 loadPC = 1; incPC = 0; address = 16'h1234;  // Load address 1234h
        #10 loadPC = 0; incPC = 0;  // Reset PC
        #10 loadPC = 0; incPC = 1;  // Increment PC
        #10 loadPC = 0; incPC = 1;  // Increment PC
        #10 loadPC = 1; incPC = 0; address = 16'h5678;  // Load address 5678h
        #10 loadPC = 0; incPC = 1;  // Increment PC
        #10 loadPC = 0; incPC = 1;  // Increment PC

       
        #10 $finish;
    end

    
    initial begin
        $monitor("Time: %0t, loadPC: %b, incPC: %b, address: %h, execadd: %h", $time, loadPC, incPC, address, execadd);
    end

endmodule
