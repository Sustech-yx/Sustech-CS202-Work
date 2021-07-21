`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/20 12:00:01
// Design Name: 
// Module Name: ifetc32_sim
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


module ifetc32_sim();
   reg[31:0]  Addr_result;
   reg[31:0]  Read_data_1;
   reg        Branch;
   reg        nBranch;
   reg        Jmp;
   reg        Jal;
   reg        Jr;
   reg        Zero;
   reg        clock;
   reg        reset;    
   //1'b1 is 'reset' enable, 1'b0 means 'reset' disable. while 'reset' enable, the value of PC is set as 32'h0000_0000
   wire     [31:0] Instruction;            
   wire     [31:0] branch_base_addr;
   wire [31:0] link_addr;
   wire [31:0] pco;      // bind with the new output port 'pco' in IFetch32 

Ifetc32 fetch_tb(
        .Instruction(Instruction), 
        .branch_base_addr(branch_base_addr),
        .Addr_result(Addr_result),
        .Read_data_1(Read_data_1),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jmp(Jmp),
        .Jal(Jal),
        .Jr(Jr),
        .Zero(Zero),
        .clock(clock),
        .reset(reset),
        .link_addr(link_addr),
        .pco(pco)
    );
    
    always begin #2 clock = ~clock; end
    
    initial begin
        Zero = 1'b0;
        Branch = 1'b0;
        nBranch = 1'b0;
        reset = 1'b1;
        clock = 1'b0;
        Addr_result = 32'h00000000;
        Read_data_1 = 32'h00000000;
        Jmp = 1'b0;
        Jal = 1'b0;
        Jr = 1'b0;
        #4 reset = 1'b0;
        #22 Jmp = 1'b1;
        #4 Jmp = 1'b0;
        
        #20 $finish;
    end
endmodule
