`timescale 1ns/1ns

module pc(
    input loadPC,
    input incPC,
    input reset,
    input [5:0] address,
    output reg [5:0] execadd
);

reg [5:0] temp;

always @(*) begin
    if (loadPC) begin
        temp = address;
    end 
    else if (incPC) begin
        temp = temp + 6'b000001;
    end 
    else if (reset) begin
        temp = 6'b000000;
    end
    execadd = temp;
end

endmodule
