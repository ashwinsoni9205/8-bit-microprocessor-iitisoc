`timescale 1ns/1ps
`include "processor.v"
module tb ();

    reg resume;
    reg restart;
    reg controller_enable;
    reg main_clk;
    integer i;

    pipeline_processor dut(.main_clk(main_clk),.resume(resume),.restart(restart),.controller_enable(controller_enable));

    initial
    begin
    forever
    begin
    main_clk = 0;
    #1;
    main_clk = 1;
    #1;
    end
    end
    
    initial begin
        #10;
        controller_enable <= 1'b1;
        // #500;
        // resume = 1;
        // #50;
        // resume = 0;
        #5000;
        controller_enable<= 1'b0;
        #100
        for (i = 0; i < 8; i = i + 1) begin
            $display("register: %b",dut.r1.registers[i]);
        end
        for (i = 0; i < 16; i = i + 1) begin
            $display("memory: %b",dut.m1.memory[i]);
        end
        $finish;
    end
    initial begin
       $dumpfile("processor.vcd");
       $dumpvars(0);
    end
endmodule
/*
./iverilog -o processor.vvp processortb.v
./vvp processor.vvp
*/