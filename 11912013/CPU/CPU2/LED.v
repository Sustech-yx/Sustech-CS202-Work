`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 19:56:34
// Design Name: 
// Module Name: io_out
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module LED(led_clk, ledrst, ledwrite, ledcs, ledaddr,ledwdata, ledout);
    input led_clk;    		    // 时钟信号
    input ledrst; 		        // 复位信号
    input ledwrite;		       	// 写信号
    input ledcs;		      	// 从memorio来的LED片选信号   !!!!!!!!!!!!!!
    input[1:0] ledaddr;	        // 到LED模块的地址低端  !!!!!!!!!!!!!!!!!!!!
    input[15:0] ledwdata;	  	// 写到LED模块的数据，注意数据线只有16根
    output[31:0] ledout;		// 向板子上输出的24位LED信号
  
    reg [31:0] ledout;
    
    always@(posedge led_clk or posedge ledrst) begin
        if(ledrst) begin
            ledout <= 24'h000000;
        end
		else if(ledcs && ledwrite) begin
			if(ledaddr == 2'b00)
				ledout[31:0] <= { ledout[31:16], ledwdata[15:0] };
			else if(ledaddr == 2'b10 )
				ledout[31:0] <= { ledwdata[15:0], ledout[15:0] };
			else
				ledout <= ledout;
        end
		else begin
            ledout <= ledout;
        end
    end
endmodule
