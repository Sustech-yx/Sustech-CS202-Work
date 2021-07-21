`timescale 1ns / 1ps

module Decoder(read_data_1,
                read_data_2, 
                Instruction, 
                read_data, 
                ALU_result, 
                Jal, 
                RegWrite, 
                MemtoReg, 
                RegDst, 
                imme_extend, 
                clock, 
                reset, 
                opcplus4);

    // input 
    input[31:0]  Instruction;
    input[31:0]  read_data; // read_data from memory
    input[31:0]  ALU_result;
    input        Jal; 
    input        RegWrite;
    input        MemtoReg;
    input        RegDst;
    input        clock, reset;
    input[31:0]  opcplus4;      // from ifetch link_address
    // output

    output[31:0] read_data_1;
    output[31:0] read_data_2;
    output[31:0] imme_extend;

    reg   [31:0] register_bud [0:31];
    wire  [4:0] rs, rt, rd;
    wire  [4:0] writereg;
    wire  [15:0] imm = {16{Instruction[15]}};
    wire  rst;

    assign rs = Instruction[25:21];
    assign rt = Instruction[20:16];
    assign rd = Instruction[15:11];
    assign read_data_1 = (rs == 0) ? 32'b0 : register_bud[rs];
    assign read_data_2 = (rt == 0) ? 32'b0 : register_bud[rt];
    assign imme_extend = {imm, Instruction[15:0]};
    assign rst = ~reset;

    always @(posedge clock or negedge rst) begin
        if (rst == 1'b0) begin
            register_bud[1] <= 32'b0;
            register_bud[2] <= 32'b0;
            register_bud[3] <= 32'b0;
            register_bud[4] <= 32'b0;
            register_bud[5] <= 32'b0;
            register_bud[6] <= 32'b0;
            register_bud[7] <= 32'b0;
            register_bud[8] <= 32'b0;
            register_bud[9] <= 32'b0;
            register_bud[10]<= 32'b0;
            register_bud[11]<= 32'b0;
            register_bud[12]<= 32'b0;
            register_bud[13]<= 32'b0;
            register_bud[14]<= 32'b0;
            register_bud[15]<= 32'b0;
            register_bud[16]<= 32'b0;
            register_bud[17]<= 32'b0;
            register_bud[18]<= 32'b0;
            register_bud[19]<= 32'b0;
            register_bud[20]<= 32'b0;
            register_bud[21]<= 32'b0;
            register_bud[22]<= 32'b0;
            register_bud[23]<= 32'b0;
            register_bud[24]<= 32'b0;
            register_bud[25]<= 32'b0;
            register_bud[26]<= 32'b0;
            register_bud[27]<= 32'b0;
            register_bud[28]<= 32'b0;
            register_bud[29]<= 32'b0;
            register_bud[30]<= 32'b0;
            register_bud[31]<= 32'b0;
        end
        else begin
            if (Jal == 1'b1) begin
                register_bud[31] <= opcplus4;
            end
            else if (RegWrite == 1'b1) begin
                if (MemtoReg == 1'b1) begin
                    if (RegDst == 1'b1 && rd != 0) begin
                        register_bud[rd] <= read_data;
                    end 
                    else if (rt != 0) begin
                        register_bud[rt] <= read_data;
                    end
                end 
                else begin
                    if (RegDst == 1'b1 && rd != 0) begin
                        register_bud[rd] <= ALU_result;
                    end 
                    else if (rt != 0) begin
                        register_bud[rt] <= ALU_result;
                    end
                end
            end
        end
    end
endmodule