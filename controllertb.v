`timescale 1ns/1ps
`include "controller.v"
module controllertb ();

reg halted,resume,restart,controller_enable;
wire clk1,clk2,reset,enable;

controller dut (.halted(halted),.resume(resume),.restart(restart),.clk1(clk1),.clk2(clk2),.reset(reset)
,.enable(enable),.controller_enable(controller_enable));

initial begin
    $dumpfile("controller.vcd");
    $dumpvars(0,controllertb);
    $monitor("time:%d, state: %d, halted: %d, resume: %d, clk1: %d, clk2: %d, reset: %d, enable: %d, internal_halted: %d, restart: %d",$time,dut.state,
    halted,resume,clk1,clk2,reset,enable,dut.internal_halted,restart);
    controller_enable = 1'b1;

    #70;
    halted = 1'b1;
    #5;
    halted = 1'b0;
    #150;
    resume = 1;
    #5;
    resume = 0;
    #100;
    halted = 1;
    #5;
    halted = 0;
    #300;
    restart = 1;
    #5;
    restart = 0;
    #100;
    controller_enable = 0;
    #100;
    $finish;
end
endmodule //controllertb
/*
./iverilog -o controller.vvp controllertb.v
./vvp controller.vvp 
*/