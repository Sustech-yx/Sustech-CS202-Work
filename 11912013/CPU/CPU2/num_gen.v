`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/21 19:03:35
// Design Name: 
// Module Name: num_gen
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
//////////////////////////////////////////////////////////////////////////////////
//                          a
//                        -----
//                      f|  g  |b
//                        -----
//                      e|     |c
//                        -----    .
//                          d      h
parameter Data_de =7'b0000000;
                     //gfedcba
parameter Data_0 = 7'b0111111; // 0
parameter Data_1 = 7'b0000110; // 1
parameter Data_2 = 7'b1011011; // 2
parameter Data_3 = 7'b1001111; // 3
parameter Data_4 = 7'b1100110; // 4
parameter Data_5 = 7'b1101101; // 5
parameter Data_6 = 7'b1111101; // 6
parameter Data_7 = 7'b0100111; // 7
parameter Data_8 = 7'b1111111; // 8
parameter Data_9 = 7'b1100111; // 9
parameter Data_a = 7'b1110111; // A
parameter Data_b = 7'b1111100; // B
parameter Data_c = 7'b0111001; // C
parameter Data_d = 7'b1011110; // D
parameter Data_e = 7'b1111001; // E
parameter Data_f = 7'b1110001; // F

module num_gen(in_num, num);
    input [31:0] in_num;
    output [55:0] num;

    assign num = {
        dt_translate(in_num[31:28]),
        dt_translate(in_num[27:24]),
        dt_translate(in_num[23:20]),
        dt_translate(in_num[19:16]),
        dt_translate(in_num[15:12]),
        dt_translate(in_num[11:8]),
        dt_translate(in_num[7:4]),
        dt_translate(in_num[3:0])
    };

    function [6:0] dt_translate;
        input [3:0] data;
        begin
            case(data)
                4'd0 : dt_translate = Data_0;
                4'd1 : dt_translate = Data_1;
                4'd2 : dt_translate = Data_2;
                4'd3 : dt_translate = Data_3;
                4'd4 : dt_translate = Data_4;
                4'd5 : dt_translate = Data_5;
                4'd6 : dt_translate = Data_6;
                4'd7 : dt_translate = Data_7;
                4'd8 : dt_translate = Data_8;
                4'd9 : dt_translate = Data_9;
                4'd10: dt_translate = Data_a;
                4'd11: dt_translate = Data_b;
                4'd12: dt_translate = Data_c;
                4'd13: dt_translate = Data_d;
                4'd14: dt_translate = Data_e;
                4'd15: dt_translate = Data_f;
            endcase
        end
    endfunction
endmodule
