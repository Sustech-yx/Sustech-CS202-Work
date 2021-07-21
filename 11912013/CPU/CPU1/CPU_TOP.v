`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 15:46:11
// Design Name: 
// Module Name: cpu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This is the top module of the project.
// 
// Dependencies: control32, dememory32, Idecode32, Ifetc32, io_in, io_out, memorio, excute32.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU_TOP(clk, reset, switches, leds);
    input clk, reset;
    input[23:0] switches;
    output wire [23:0] leds;

    wire cpu_clock;
    // Control signals
    wire Branch, nBranch, Jmp, Jal, Jr, Zero, RegWrite, RegDst;
    wire [31:0] Instruction; 
    wire [31:0] Addr_Result; 
    wire [31:0] Read_data_1;     
    wire [31:0] Read_data_2; 
    wire [31:0] read_data;
    wire [31:0] link_addr;
    wire [31:0] branch_base_addr;
    wire [31:0] pco;
    //#%%
    wire [31:0] Imme_extend;
    //#%%
    wire        ALUSrc; //  1 indicate the 2nd data is immidiate (except "beq","bne")
    wire        MemorIOtoReg; 
    wire        MemRead; 
    wire        MemWrite;
    wire        IORead;
    wire        IOWrite;
    wire        I_format;
    wire        Sftmd;
    wire [1:0]  ALUOp;
    //#%%
    wire [31:0] ALU_Result; 
    wire [31:0] read_data_from_memory; 
    wire [31:0] address; 
    wire [31:0] write_data; 
    wire [15:0] ioread_data;
    //#%%
    wire        switchcs;
    wire [1:0]  switchaddr; 
    wire [15:0] switchrdata; 
    wire [23:0] switch_i;
    //#%%
    wire        ledcs;
    wire [1:0]  ledaddr;
    wire [15:0] ledwdata;

    ControllerIO controller(
        .Opcode(Instruction[31:26]), 
        .Function_opcode(Instruction[5:0]), 
        .Jr(Jr), 
        .Jmp(Jmp), 
        .Jal(Jal), 
        .Branch(Branch), 
        .nBranch(nBranch),
        .RegDST(RegDst), 
        .Alu_resultHigh(ALU_Result[31:10]), 
        .MemorIOtoReg(MemorIOtoReg), 
        .RegWrite(RegWrite), 
        .MemRead(MemRead), 
        .MemWrite(MemWrite), 
        .IORead(IORead), 
        .IOWrite(IOWrite), 
        .ALUSrc(ALUSrc), 
        .I_format(I_format), 
        .Sftmd(Sftmd), 
        .ALUOp(ALUOp)
    );

    Dmem memo(
        .read_data(read_data_from_memory), 
        .address(address), 
        .write_data(write_data), 
        .Memwrite(MemWrite), 
        .clock(cpu_clock)
    );

    ALU alu(
        .Read_data_1(Read_data_1), 
        .Read_data_2(Read_data_2), 
        .Imme_extend(Imme_extend), 
        .Function_opcode(Instruction[5:0]), 
        .opcode(Instruction[31:26]), 
        .ALUOp(ALUOp), 
        .Shamt(Instruction[10:6]), 
        .Sftmd(Sftmd), 
        .ALUSrc(ALUSrc), 
        .I_format(I_format), 
        .Jr(Jr), 
        .PC_plus_4(branch_base_addr),
        .Zero(Zero), 
        .ALU_Result(ALU_Result), 
        .Addr_Result(Addr_Result)
    );

    Decoder decoder(
        .read_data_1(Read_data_1),
        .read_data_2(Read_data_2),
        .Instruction(Instruction),
        .read_data(read_data),
        .ALU_result(ALU_Result),
        .Jal(Jal),
        .RegWrite(RegWrite),
        .MemtoReg(MemorIOtoReg),
        .RegDst(RegDst),
        .imme_extend(Imme_extend),
        .clock(cpu_clock),
        .reset(reset),
        .opcplus4(link_addr)
    );

    IFetch fetchInstru(
        .Instruction(Instruction), 
        .branch_base_addr(branch_base_addr),
        .Addr_result(Addr_Result),
        .Read_data_1(Read_data_1),
        .Branch(Branch),
        .nBranch(nBranch),
        .Jmp(Jmp),
        .Jal(Jal),
        .Jr(Jr),
        .Zero(Zero),
        .clock(cpu_clock),
        .reset(reset),
        .link_addr(link_addr),
        .pco(pco)
    );

    Switch in_put(
        .switclk(cpu_clock),
        .switrst(reset), 
        .switchread(IORead), 
        .switchcs(switchcs),
        .switchaddr(address[1:0]), 
        .switchrdata(switchrdata), 
        .switch_i(switches)
    );

    LED out_put(
        .led_clk(cpu_clock), 
        .ledrst(reset), 
        .ledwrite(IOWrite), 
        .ledcs(ledcs), 
        .ledaddr(address[1:0]),
        .ledwdata(write_data[15:0]), 
        .ledout(leds)
    );
    
    assign ioread_data = switchrdata;

    MemOrIO muxx(
        .mRead(MemRead), 
        .mWrite(MemWrite), 
        .ioRead(IORead), 
        .ioWrite(IOWrite),
        .addr_in(ALU_Result), 
        .addr_out(address), 
        .m_rdata(read_data_from_memory), 
        .io_rdata(ioread_data), 
        .r_wdata(read_data), 
        .r_rdata(Read_data_2), 
        .write_data(write_data), 
        .LEDCtrl(ledcs), 
        .SwitchCtrl(switchcs)
    );
    
    cpu_clk clock_gen(
        .clk_in1(clk),
        .clk_out1(cpu_clock)
    );
endmodule
