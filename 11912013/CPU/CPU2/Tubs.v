`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/21 18:15:40
// Design Name: 
// Module Name: seg
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
// Gnerate the segment displayer with 50Hz, a new frequency of cpu clock is needed.
// Howerver, the needed Hz is too low, cannot generated by the component cpu_clk, so we 
// need to generate the new clk in this component.
// From SevenSegamentDigitalDisplayTube.srcs

module Tubs(clock, reset, Dig, Y, in_num);
    input clock, reset;
    output wire [7:0] Dig;
    output wire [7:0] Y;
    input [31:0] in_num; // The input from the top module. Just like the led.

    reg [7:0] Dig_r; // The rnverse of Digital selection.
    reg [6:0] Y_r; // The reverse of Digital.
    wire rst;
    wire [55:0] num;
    assign Dig = ~Dig_r;
    assign Y = {{1'b1}, {~Y_r}};
    assign rst = ~reset;

    reg clk;
    reg [31:0] clk_cnt;
    reg [3:0] scanner_cnt;

    num_gen gener(
        .in_num(in_num),
        .num(num)
    );

    initial begin
        clk = 1'b0;
    end

    parameter half_period = 40000;
    always @(posedge clock or negedge rst) begin
        if (!rst)
            clk_cnt <= 0;
        else  begin  
            clk_cnt <= clk_cnt + 1;
            if (clk_cnt  == (half_period >> 1) - 1)               
                clk <= 1'b1;
            else if (clk_cnt == half_period - 1) begin 
                clk <= 1'b0;
                clk_cnt <= 1'b0;      
            end
        end
    end

    always @(posedge clk or negedge rst) begin 
        if (!rst) begin
            scanner_cnt <= 4'b0000;
        end
        else begin
            scanner_cnt <= scanner_cnt + 1'b1;    
            if(scanner_cnt == 4'd9)  begin
                scanner_cnt <= 4'b0000;
            end
        end 
    end

    always @(scanner_cnt) begin
        case(scanner_cnt)
            4'b0001 : Dig_r <= 8'b0000_0001;    
            4'b0010 : Dig_r <= 8'b0000_0010;    
            4'b0011 : Dig_r <= 8'b0000_0100;    
            4'b0100 : Dig_r <= 8'b0000_1000;    
            4'b0101 : Dig_r <= 8'b0001_0000;    
            4'b0110 : Dig_r <= 8'b0010_0000;    
            4'b0111 : Dig_r <= 8'b0100_0000;     
            4'b1000 : Dig_r <= 8'b1000_0000;    
            default :Dig_r <= 8'b0000_0000;
        endcase
    end

    always @(scanner_cnt) begin
        case(scanner_cnt)
            4'b0001 : Y_r = num[6:0];    
            4'b0010 : Y_r = num[13:7];    
            4'b0011 : Y_r = num[20:14];    
            4'b0100 : Y_r = num[27:21];    
            4'b0101 : Y_r = num[34:28];    
            4'b0110 : Y_r = num[41:35];
            4'b0111 : Y_r = num[48:42];
            4'b1000 : Y_r = num[55:49];
            default :Y_r = 8'b0000_0000;
        endcase
    end
endmodule
