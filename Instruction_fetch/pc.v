`timescale 1ns/1ns

module pc(
    input loadPC,
    input incPC,
    input [5:0] address,
    output reg [5:0] execadd
);

reg [5:0] temp;

always @(*) begin
    if (loadPC == 1 && incPC == 0) begin
        temp = address;
    end else if (loadPC == 0 && incPC == 1) begin
        temp = temp + 6'b000001;
    end else if (loadPC == 0 && incPC == 0) begin
        temp = 6'b000000;
    end
    execadd = temp;
end

endmodule