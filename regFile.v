module regFile (data1,data2,addr1,addr2,rd_addr,rd_data,enable,reset);
output reg [7:0] data1,data2;
input [2:0] addr1,addr2,rd_addr;
input [7:0] rd_data;
input enable,reset;

endmodule //regFile