`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/10 15:05:17
// Design Name: 
// Module Name: Executs32
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


module ALU(
    Read_data_1, Read_data_2, Imme_extend, Function_opcode, opcode, ALUOp, Shamt, Sftmd, ALUSrc, I_format, Jr, PC_plus_4,
    Zero, ALU_Result, Addr_Result
);
    // from decoder
    input [31:0] Read_data_1;           //the source of A_input
    input [31:0] Read_data_2;           //one of the sources of B_input
    input [31:0] Imme_extend;           //one of the sources of B_input 

    // from ifetch
    input [5:0] Function_opcode;        // instructions[5:0]
    input [5:0] opcode;                 // instruction[31:26]
    input [4:0] Shamt;                  // instruction[10:6], the amount of shift bits
    input [31:0] PC_plus_4;             // pc+4

    // from controller
    input [1:0] ALUOp;                  // { (R_format || I_format) , (Branch || nBranch) }
    input ALUSrc;                       // 1 means the 2nd operand is an immedite (except beq，bne）
    input I_format;                     // 1 means I-Type instruction except beq, bne, LW, SW
    input Sftmd;                        // 1 means this is a shift instruction
    input Jr;                           // 1 means this is a jr instruction 

    output Zero;                        // 1 means the ALU_output_mux is zero, 0 otherwise
    output reg [31:0] ALU_Result;       // the ALU calculation result
    output [31:0] Addr_Result;          // the calculated instruction address 

    wire[31:0] Ainput,Binput;           // two operands for calculation 

    wire[5:0] Exe_code;                 // use to generate ALU_ctrl. (I_format==0) ? Function_opcode : { 3'b000 , Opcode[2:0] }; 
    wire[2:0] ALU_ctl;                  // the control signals which affact operation in ALU directely 
    wire[2:0] Sftm;                     // identify the types of shift instruction, equals to Function_opcode[2:0]

    reg[31:0] Shift_Result;             // the result of shift operation 

    wire[32:0] Branch_Addr;             // the calculated address of the instruction, Addr_Result is Branch_Addr[31:0]


    assign Sftm = Function_opcode[2:0];
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 1'b0) ? Read_data_2 : Imme_extend;
    
    assign Exe_code = (I_format == 1'b0) ? Function_opcode : { 3'b000 , opcode[2:0] };
    assign ALU_ctl[0] = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
    assign ALU_ctl[1] = ( (!Exe_code[2]) | (!ALUOp[1]) );
    assign ALU_ctl[2] = (Exe_code[1] & ALUOp[1]) | ALUOp[0];

    assign Zero = ALU_output_mux == 32'd0 ? 1'b1 : 1'b0;
    assign Branch_Addr = PC_plus_4[31:2] + Imme_extend;
    assign Addr_Result = Branch_Addr;

    always @* begin // six types of shift instructions 
        if(Sftmd) begin
            case(Sftm[2:0]) 
                3'b000:Shift_Result = Binput << Shamt; //Sll rd,rt,shamt 00000 
                3'b010:Shift_Result = Binput >> Shamt; //Srl rd,rt,shamt 00010 
                3'b100:Shift_Result = Binput << Ainput; //Sllv rd,rt,rs 000100 
                3'b110:Shift_Result = Binput >> Ainput; //Srlv rd,rt,rs 000110 
                3'b011:Shift_Result = $signed(Binput) >>> Shamt; //Sra rd,rt,shamt 00011 
                3'b111:Shift_Result = $signed(Binput) >>> Ainput; //Srav rd,rt,rs 00111 
                default:Shift_Result = Binput; 
            endcase 
        end
        else begin
            Shift_Result = Binput; 
        end
    end
    // always @* begin // six types of shift instructions 
    //     if(Sftmd) begin
    //         case(Sftm[2:0]) 
    //             3'b000:Shift_Result = Binput << Shamt; //Sll rd,rt,shamt 00000 
    //             3'b010:Shift_Result = ???; //Srl rd,rt,shamt 00010 
    //             3'b100:Shift_Result = Binput << Ainput; //Sllv rd,rt,rs 000100 
    //             3'b110:Shift_Result = ???; //Srlv rd,rt,rs 000110 
    //             3'b011:Shift_Result = ???; //Sra rd,rt,shamt 00011 
    //             3'b111:Shift_Result = ???; //Srav rd,rt,rs 00111 
    //             default:Shift_Result = Binput; 
    //         endcase 
    //     end
    //     else begin
    //         Shift_Result = Binput; 
    //     end
    // end
    // From practice 2.2

    reg[31:0] ALU_output_mux;           // the result of arithmetic or logic calculation 
    always @(ALU_ctl or Ainput or Binput) begin
        case (ALU_ctl)
            3'b000 : ALU_output_mux = Ainput & Binput;
            3'b001 : ALU_output_mux = Ainput | Binput;
            3'b010 : ALU_output_mux = Ainput + Binput;
            3'b011 : ALU_output_mux = Ainput + Binput; 
            3'b100 : ALU_output_mux = Ainput ^ Binput; 
            3'b101 : ALU_output_mux = ~(Ainput | Binput); 
            3'b110 : ALU_output_mux = Ainput - Binput;
            3'b111 : ALU_output_mux = Ainput - Binput; 
            default: ALU_output_mux = 32'h00000000;
        endcase
    end

    always @* begin 
        //set type operation (slt, slti, sltu, sltiu) 
        if(((ALU_ctl==3'b111) && (Exe_code[3]==1))||((ALU_ctl[2:1]==2'b11) && (I_format==1))) begin 
            ALU_Result =  ($signed(Ainput) < $signed(Binput)) ? 32'd1 : 32'd0; 
        end
        //lui operation 
        else if((ALU_ctl==3'b101) && (I_format==1)) begin 
            ALU_Result[31:0]={Binput[15:0],{16{1'b0}}}; 
        end
        //shift operation 
        else if(Sftmd==1) begin
            ALU_Result = Shift_Result; 
        end
        //other types of operation in ALU (arithmatic or logic calculation) 
        else begin
            ALU_Result = ALU_output_mux[31:0]; 
        end 
    end

endmodule