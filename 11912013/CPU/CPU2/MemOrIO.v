`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 16:52:01
// Design Name: 
// Module Name: memorio
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


module MemOrIO( mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, SwitchCtrl); 
    input mRead; // read memory, from control32 
    input mWrite; // write memory, from control32 
    input ioRead; // read IO, from control32 
    input ioWrite; // write IO, from control32 

    input[31:0] addr_in; // from alu_result in executs32 
    output[31:0] addr_out; // address to memory 

    input[31:0] m_rdata; // data read from memory 
    input[15:0] io_rdata; // data read from io,16 bits 

    output[31:0] r_wdata; // data to idecode32(register file) 
    input[31:0] r_rdata; // data read from idecode32(register file) 
    output reg[31:0] write_data; // data to memory or I/O（m_wdata, io_wdata） 

    output LEDCtrl; // LED Chip Select 
    output SwitchCtrl; // Switch Chip Select

    assign addr_out = addr_in;
    assign r_wdata = (ioRead == 1'b1) ? {16'h0000, io_rdata} : m_rdata;
    assign LEDCtrl = (ioWrite == 1'b1) ? 1'b1 : 1'b0;
    assign SwitchCtrl = (ioRead == 1'b1) ? 1'b1 : 1'b0;

    always @(*) begin
        if ((mWrite==1)||(ioWrite==1)) begin
            write_data = ((mWrite == 1'b1) ? r_rdata : {16'b0000000000000000, r_rdata[15:0]});
        end
        else begin
            write_data = 32'hZZZZZZZZ; 
        end
    end
endmodule
