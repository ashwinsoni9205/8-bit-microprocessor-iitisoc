`timescale 1ns/1ns

module pc(
    input clk,
    input loadPC,
    input incPC,
    input [4:0] address,
    output reg [4:0] execadd
);

reg [15:0] temp;

always @(posedge clk) begin
    if (loadPC == 1 && incPC == 0) begin
        temp <= address;
    end else if (loadPC == 0 && incPC == 1) begin
        temp <= temp + 4'h001;
    end else if (loadPC == 0 && incPC == 0) begin
        temp <= 4'h000;
    end
    execadd <= temp;
end

endmodule
