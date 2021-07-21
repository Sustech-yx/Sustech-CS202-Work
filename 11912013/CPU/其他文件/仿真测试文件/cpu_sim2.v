`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/20 18:03:37
// Design Name: 
// Module Name: cpu_sim2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module cpu_sim2();
reg rst, clk;
reg[23:0] switches;
wire[23:0] leds;

cpu cpu_tb(
    .clk(clk), 
    .reset(rst), 
    .switches(switches), 
    .leds(leds)
);

always begin
    #1 clk = ~clk;
end

initial begin
    clk = 1'b0;
    rst = 1'b1;
    switches = 24'h000000;
    #100 rst = 1'b0;
    switches = 24'h400000;
end
endmodule
