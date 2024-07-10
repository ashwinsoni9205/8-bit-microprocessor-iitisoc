`timescale 1ns/1ps
module controller (clk1,clk2,reset,enable,halted,resume,restart,controller_enable);
output reg clk1,clk2,reset,enable;
input halted,resume,restart,controller_enable;

parameter [1:0] S0 = 2'b00;
parameter [1:0] S1 = 2'b01;
parameter [1:0] S2 = 2'b10;
parameter [1:0] S3 = 2'b11;

reg [1:0] state = 2'b00;
reg internal_halted, internal_restart;
reg internal_clock;

always @(controller_enable)
begin
    if(controller_enable == 1)
    begin
forever begin
    internal_clock = 1;
    #1;
    internal_clock = 0;
    #1;
end
    end
    else if(controller_enable == 0)
    begin 
        internal_clock = 0;
    end
end
always@(restart or halted)
begin
    if(restart == 1)
    internal_restart <= 1;
    if(halted == 1 )
    internal_halted <= 1;
    else
    begin
    end
end
always @(posedge internal_clock or negedge internal_clock) begin
    if(controller_enable)
    begin
    if(state == S2 && halted == 1'b1)
    begin
    internal_halted <= halted;
    state <= S3;
    end
    else
    state <= S2;

    if(internal_restart == 1'b1)
    begin
        state <= S0;
    end
    if(state == S3 && resume == 1'b1)
    begin
        state <= S2;
        internal_halted <= 0;
    end
    if(internal_halted == 1'b1)
    begin
        state <= S3;
    end
    
case(state)
S0 : begin
    internal_restart <= 1'b0;
    internal_halted <= 1'b0;
    enable <= 1'b0;
    reset <= 1'b0;
    clk1 <= 0;
    clk2 <= 0;
    state <= S1;
end
S1 : begin 
    enable <= 1;
    reset <= 1;
    state <= S2;
end
S2 : begin
    if(internal_halted)
    state <= S3;
    else
    begin
    reset <= 0;
    clk1 <= 1'b1;
    clk2 <= 1'b0;
    #10;
    clk1 <= 1'b0;
    #10;
    clk2 <= 1'b1;
    #10;
    clk2 <= 1'b0;
    #10;
    end
end
S3 : begin
    clk1 <= 1'b0;
    clk2 <= 1'b0;
    if(internal_restart)
    begin
    state <= S0;
    internal_halted <= 0;
    internal_restart <= 0;
    end
end
default: begin
    state <= S0;
    internal_halted <= 1'b0;
    internal_restart <= 1'b0;
end
endcase
end
else 
begin
    clk1 <= 0;
    clk2 <= 0;
end
end


endmodule //controller