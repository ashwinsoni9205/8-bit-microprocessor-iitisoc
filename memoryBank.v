`timescale 1ns/1ps
module memoryBank (
output reg [7:0] mem_data_out, // data to be fetched from mem
input [7:0] mem_data_in, // data to be saved in mem
input [3:0] mem_addr_in,// addr_in for address where data to be saved 
input [3:0] mem_addr_out,// addr_out for address from where data is collected for output.
input r_w,
input enable,
input reset,
input clk
);

integer i;

reg [7:0] memory [0:15]; // 32 memory locations  , 8 bit each

initial begin
    $readmemb("datamem.txt",memory); // feeding data to the memory;
end
always @(*) 
begin
    if(reset)
    begin
       $readmemb("datamem.txt",memory);
    end
    else
    begin
        if(r_w == 1)
        begin
            mem_data_out <= memory[mem_addr_out];
        end
        else if(r_w == 0)
        begin
            memory[mem_addr_in] <= mem_data_in;
        end
        else
        begin
        end
    end
end
// integer j = 0;
// initial
// begin
//     for (j = 0; j < 32; j = j + 1) begin
//         $display("mem_data: %b",memory[j]);
//     end
// end

endmodule //memoryBank