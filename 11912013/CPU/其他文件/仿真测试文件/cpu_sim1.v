`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 14:37:43
// Design Name: 
// Module Name: cpu_sim1
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


module cpu_sim1();
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
    #2 clk = ~clk;
end

initial begin
    clk = 1'b0;
    rst = 1'b1;
    switches = 24'h000000;
    #900
    #50 rst = 1'b0; switches = 24'h000001;
    #500 switches = 24'h000002;
    #500 switches = 24'h000003;
    #500 switches = 24'h000004;
    #500 switches = 24'h000005;
    #500 switches = 24'h000006;
    #500 switches = 24'h000007;
    #500 switches = 24'h000008;
    #500 switches = 24'h000009;
    #500 rst = 1'b1;
    #500 rst = 1'b0;
    #500 switches = 24'h00000A;
    #500 switches = 24'h00000B;
    #500 switches = 24'h00000C;
    #500 switches = 24'h00000D;
    #500 switches = 24'h00000E;
    #500 switches = 24'h00000F;
    #500 switches = 24'h000010;
    #500 switches = 24'hFFFFFC;
    #10 $finish;
end
endmodule
