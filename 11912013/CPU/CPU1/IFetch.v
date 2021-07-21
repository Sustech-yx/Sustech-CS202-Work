`timescale 1ns / 1ps

module IFetch(
    Instruction, 
    branch_base_addr,
    Addr_result,
    Read_data_1,
    Branch,
    nBranch,
    Jmp,
    Jal,
    Jr,
    Zero,
    clock,
    reset,
    link_addr,
    pco
    );
     // input
    input[31:0]  Addr_result;
    input[31:0]  Read_data_1;
    input        Branch;
    input        nBranch;
    input        Jmp;
    input        Jal;
    input        Jr;
    input        Zero;
    input        clock;
    input        reset;    
    //1'b1 is 'reset' enable, 1'b0 means 'reset' disable. while 'reset' enable, the value of PC is set as 32'h0000_0000
    // output
    output     [31:0] Instruction;            
    output     [31:0] branch_base_addr;
    output reg [31:0] link_addr;
    output reg [31:0] pco;      // bind with the new output port 'pco' in IFetch32 

    reg [31:0] next_pc;
    wire [31:0] pc_plus4;
    
    assign pc_plus4[31:2] = pco[31:2] + 1'b1;
    assign pc_plus4[1:0] = pco[1:0];
    assign branch_base_addr = pc_plus4;

    prgrom instmem(
        .clka(clock),         // input wire clka        
        .addra(pco[15:2]),    // input wire [13 : 0] addra        
        .douta(Instruction)   // output wire [31 : 0] douta    
    );

    always @(*) begin
         if(Jr == 1'b1)begin
            next_pc = Read_data_1 * 4;
         end
         else if((Branch == 1'b1 && Zero == 1'b1) || (nBranch == 1'b1 && Zero == 1'b0)) begin
            next_pc = Addr_result * 4;
         end
         else begin
            next_pc = branch_base_addr;
         end
    end

    always @(negedge clock or posedge reset) begin
        if (reset) begin
            pco <= 32'h0000_0000;
        end 
        else if (Jal == 1'b1 || Jmp == 1'b1) begin
            link_addr = next_pc / 4;
            pco <= {4'b0000, Instruction[27:2], 2'b0};
        end
        else begin
            pco <= next_pc;
        end
    end
endmodule