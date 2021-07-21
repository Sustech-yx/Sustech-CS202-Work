module Dmem(read_data, address, write_data, Memwrite, clock);
input clock;
input wire Memwrite;
input wire[31:0] address;
input wire [31:0] write_data;
output wire [31:0] read_data;
wire clk;

assign clk = ~clock;

RAM ram (
    .clka(clk),
    .wea(Memwrite),
    .addra(address[15:2]),
    .dina(write_data),
    .douta(read_data)
);
endmodule