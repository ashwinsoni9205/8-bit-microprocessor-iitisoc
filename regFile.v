`timescale 1ns/1ps
module regFile (
output reg [7:0] rs1_data,rs2_data, // data to be fetched from rs1 and rs2,
input [2:0] rs1_addr,rs2_addr,rd_addr,
input [15:0] rd_data, // data to be saved in rd,
input reset,
input input_length, // 0 will mean rd_data is of 8 bits and 1 will mean it is of 16 bits,
input r_w // 1 for read and 0 for write,
);
integer i = 0;
reg [7:0] registers [0:7];

initial begin
    $readmemb("regdata.txt",registers); // feeding data to the regbank
end

always @(*) begin
    if(reset)
    begin
        for (i = 0; i<8; i = i + 1 ) begin
            registers[i] = 8'b0;
        end
    end
    else
    begin
        if(r_w == 1)
        begin
            rs1_data <= registers[rs1_addr];
            rs2_data <= registers[rs2_addr];
        end
        else if(r_w == 0)
        begin
            if(input_length == 1'b0)
            begin
                registers[rd_addr] <= rd_data[7:0];
            end
            else if(input_length == 1'b1)
            begin
                registers[rd_addr] <= rd_data[15:8];
                registers[rd_addr+1] <= rd_data[7:0];
            end
        end
        else
        begin
        end
    end
end


endmodule //regFile