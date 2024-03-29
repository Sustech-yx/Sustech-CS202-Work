`timescale 1ns / 1ps

module ControllerIO(Opcode, Function_opcode, Jr, Jmp, Jal, Branch, nBranch, RegDST, 
    Alu_resultHigh, 
    MemorIOtoReg, RegWrite, 
    MemRead, MemWrite, 
    IORead, IOWrite, 
    ALUSrc, I_format, Sftmd, ALUOp);

    input[5:0]   Opcode;    // instruction[31..26]    
    input[5:0]   Function_opcode;  // instructions[5..0] 
    input[21:0]  Alu_resultHigh; // From the execution unit Alu_Result[31..10] 

    output       Jr;        // 1 indicate the instruction is "jr", other wise it's not
    output       Jmp;       //  1 indicate the instruction is "j", otherwise it's not    
    output       Jal;       //  1 indicate the instruction is "jal", otherwise it's not    
    output       Branch;    //  1 indicate the instruction is "beq" , otherwise it's not    
    output       nBranch;   //  1 indicate the instruction is "bne", otherwise it's not    
    output       RegDST;    //  1 indicate destination register is "rd",otherwise it's "rt"    
    output       RegWrite;  //  1 indicate write register, otherwise it's not    
    output       MemWrite;  //  1 indicate write data memory, otherwise it's not  
    output       MemorIOtoReg; // 1 indicates that data needs to be read from memory or I/O to the register 
    output       MemRead; // 1 indicates that the instruction needs to read from the memory 
    output       IORead; // 1 indicates I/O read
    output       IOWrite; // 1 indicates I/O write  
    output       ALUSrc;    //  1 indicate the 2nd data is immidiate (except "beq","bne")    
    output       I_format;  //  1 indicate the instruction is I-type but isn't "beq","bne","LW" or "SW"    
    output       Sftmd;     //  1 indicate the instruction is shift instruction;
                            //  if the instruction is R-type or I_format, ALUOp is 2'b10; if the instruction is"beq" or "bne", ALUOp is 2'b01;  
                            //  if the instruction is"lw" or "sw", ALUOp is 2'b00;
    output[1:0]  ALUOp;
    
    wire R_format, sw, lw;

    assign Jr = ((Function_opcode == 6'b001000) && (Opcode == 6'b000000)) ? 1'b1 : 1'b0;
    // assign Jmp = ((Function_opcode == 6'b001000) && (Opcode == 6'b000010)) ? 1'b1 : 1'b0;
    assign Jmp = (Opcode == 6'b000010) ? 1'b1 : 1'b0;
    // assign Jal = ((Function_opcode == 6'b001000) && (Opcode == 6'b000011)) ? 1'b1 : 1'b0;
    assign Jal =  (Opcode == 6'b000011) ? 1'b1 : 1'b0;
    // assign Branch = ((Function_opcode == 6'b001000) && (Opcode == 6'b000100)) ? 1'b1 : 1'b0;
    assign Branch =  (Opcode == 6'b000100) ? 1'b1 : 1'b0;
    // assign nBranch = ((Function_opcode == 6'b001000) && (Opcode == 6'b000101)) ? 1'b1 : 1'b0;
    assign nBranch = (Opcode == 6'b000101) ? 1'b1 : 1'b0;
    assign R_format = (Opcode == 6'b000000) ? 1'b1 : 1'b0;
    assign I_format = (Opcode[5:3] == 3'b001) ? 1'b1 : 1'b0;
    assign RegDST = R_format && (~I_format && ~lw);

    // assign MemtoReg = (!R_format && Opcode == 6'b100011) ? 1'b1 : 1'b0;
    assign RegWrite = ((R_format || Jal || I_format || lw) && !(Jr)) ? 1'b1 : 1'b0;
    // assign MemWrite = (!R_format && Opcode != 6'b100011 && Opcode == 6'b101011 && Opcode != 6'b000100) ? 1'b1 : 1'b0;

    assign sw = (Opcode == 6'b101011) ? 1'b1 : 1'b0;
    assign lw = (Opcode == 6'b100011) ? 1'b1 : 1'b0;

    assign MemWrite = (sw  == 1'b1 && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1 : 1'b0;
    assign MemRead = (lw  == 1'b1 && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1 : 1'b0;
    assign IORead = (lw  == 1'b1 && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1 : 1'b0;
    assign IOWrite = (sw  == 1'b1 && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1 : 1'b0;
    assign MemorIOtoReg = IORead || MemRead;

    assign ALUOp = {(R_format || I_format), (Branch || nBranch)};
    assign Sftmd =  ((Function_opcode[5:3] == 3'b000) && R_format)? 1'b1:1'b0;
    assign ALUSrc = (I_format || lw || sw) ? 1'b1:1'b0;
endmodule
