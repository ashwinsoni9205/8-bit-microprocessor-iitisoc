`timescale 1ns/1ps
module memoryBank (mem_data_out,mem_data_in,mem_addr_out,mem_addr_in,r_w,reset,clk);
output reg [7:0] mem_data_out; // data to be fetched from mem
input [7:0] mem_data_in; // data to be saved in mem
input [4:0] mem_addr_in,mem_addr_out;// addr_in for address where data to be saved 
// addr_out for address from where data is collected for output.
input r_w,enable,reset,clk;
integer i;

reg [7:0] memory [0:31]; // 32 memory locations  , 8 bit each

initial begin
    $readmemb("datamem.txt",memory); // feeding data to the memory;
end
always @(*) 
begin
    if(reset)
    begin
        for(i = 0 ; i < 32 ; i = i+1)
    begin
        memory[i] <= 8'b0;
    end
    end
    else
    begin
        if(r_w)
        begin
            mem_data_out <= memory[mem_addr_out];
        end
        else
        begin
            memory[mem_addr_in] <= mem_data_in;
        end
    end
end

endmodule //memoryBank