module main(
    clk ,rst,enable,
    inst_write_address,
    inst_write_data,
    mem_write_input_address,
    mem_write_input_data
    
);
    // inst_write_address
    input clk, rst,enable;
    input [9:0]inst_write_address;
    input [31:0]inst_write_data;
    // Program Counter
    input [9:0]mem_write_input_address;
    input [31:0]mem_write_input_data;
    
    wire mem_write_signal;
    wire [9:0]mem_write_address;
    wire [31:0]mem_write_data;
   
    
    
    
    wire [31:0] PC ; 
    wire [31:0] PC_plus_four;
    assign PC_plus_four = PC + 1;
    // Instruction
    wire [31:0] instruction;

    // Decoded Fields
    wire [5:0] opcode , funct;
    wire [4:0] rs , rt , rd , shamt;    
    wire [15:0] immediate;
    wire [31:0] sign_extended_immediate;
    wire [25:0] jump_address;

    // Data from register file
    wire [31:0] read_data1, read_data2, write_data;

    // ALU inputs and outputs
    wire [31:0] ALU_input1 , ALU_input2;
    wire [31:0] ALU_result;
    wire [3:0] ALU_op;
    wire [3:0] ALU_control;
    wire equal, less_than, greater_than;
    wire carry_out;
    //wire jump_src;
    wire overflow;

    // Data memory output
    wire [31:0] memory_data;

    // Multiplication registers
    wire [31:0] HI , LO;

    // Bramch and Jump
    wire [31:0] branch_target;
    wire [31:0] jump_target;

    wire[4:0] write_address;
    // mux control signals
    wire jump, reg_write, mem_read, mem_write, mem_to_reg, alu_src,  branch , jump_src;
    wire [1:0] reg_dst;
    // which branch
    wire [3:0] branches;
    wire [31:0] testdata1;
    wire [31:0] testdata2;
    wire [31:0] testdata3;
    wire [31:0] testdata4;
    
    assign mem_write_data = (enable) ? mem_write_input_data: read_data2;
    assign mem_write_address = (enable) ? mem_write_input_address: ALU_result[9:0];
    assign mem_write_signal = (enable) ? enable: mem_write;
    
     // fetch instruction 
    memory_wrapper inst_mem(
        .a(inst_write_address),
        .d(inst_write_data),
        .dpra(PC[9:0]),
        .clk(clk),
        .we(enable),
        .dpo(instruction)
    );
    
    Decoder decoder (
        .instruction(instruction),
        .opcode(opcode),
        .funct(funct),
        .rs(rs),
        .rt(rt),
        .rd(rd),
        .shamt(shamt),
        .immediate(immediate),
        .jump_addr(jump_address)
    );
    // Sign extender
    SignExtender sign_extender (
        .immediate(immediate),
        .sign_extended_immediate(sign_extended_immediate)
    );
    // data memory
    memory_wrapper data_mem(
        .a(mem_write_address),
        .d(mem_write_data),
        .dpra(ALU_result[9:0]),
        .clk(clk),
        .we(mem_write_signal),
        .dpo(memory_data)
    );
    // CU
    myControlUnit cu(
        .opcode(opcode),
        .regDst(reg_dst),
        .regWrite(reg_write),
        .aluSrc(alu_src),
        .memRead(mem_read),
        .memWrite(mem_write),
        .memToReg(mem_to_reg),
        .jump(jump),
        .branch(branches),
        .aluOp(ALU_op)
    );
    // Mux for writing address
    MUXWriteAddress inst_WriteAddress(
        .rt(rt),
        .rd(rd),
        .regDst(reg_dst),
        .write_address(write_address)
    );
    // regester file
    registerFile inst_RF (
        .rst(rst),
        .readAddress1(rs),
        .readAddress2(rt),
        .writeAddress(write_address),
        .writeData(write_data),               // fill after some time 
        .WE(reg_write),
        .clock(clk),
        .dataOut1(read_data1),
        .dataOut2(read_data2),
        .testdata1(testdata1),
        .testdata2(testdata2),
        .testdata3(testdata3),
        .testdata4(testdata4)
    );    
    /// selection of data for r type and i type inst
    ALU_Input_Mux alu_input_mux (
        .read1(read_data1),
        .read2(read_data2),
        .immediate(sign_extended_immediate),
        .alu_src(alu_src),
        .alu_input1(ALU_input1),
        .alu_input2(ALU_input2)
    ); 

    // ALU_ctrl 
    my_ALU_CTRL inst_ALU_CTRL(
        .aluOp(ALU_op),
        .funct(funct),
        .jump_src(jump_src),
        .aluControl(ALU_control)
    );

    // ALU 
    MY_ALU inst_MY_ALU(
        .ALU_input1(read_data1),
        .ALU_input2(ALU_input2),
        .branch(branches),
        .shamt(shamt),
        .ALU_control(ALU_control),
        .ALU_result(ALU_result),
        .HI(HI),
        .LO(LO),
        .zero(zero),
        .carry_out(carry_out),
        .overflow(overflow)
    );
    // MUX for selecting data for regester writedata
    MUXDataToRegester inst_MUXDataToRegester(
        .memToReg(mem_to_reg),
        .regDst(reg_dst),
        .readDATA(memory_data),
        .PC_plus_four(PC_plus_four),
        .ALU_result(ALU_result),
        .writedata(write_data)
    );
    update_pc inst_update_pc(
        .zero(zero),
        .jump_target(instruction[25:0]),
        .PC_plus_four(PC_plus_four),
        .signExtendedImmediate(sign_extended_immediate),
        .readDATA1(read_data1),
        .clk(clk),
        .rst(rst),
        .jump(jump),
        .jump_src(jump_src),
        .nextPC(PC)
    ) ;
    initial begin
        // Print selected signals when they change
        $monitor("Time = %0t|clk=%b | PC = %d|inst=%d |nextpc = %d|d1=%d|d2=%d|al1=%d|AL2=%d |rs=%d|rt=%d|rd=%d |wd=%d|regdata=%b|memwrite=%b|jump=%b|jumpSRC=%b", $time,clk,PC,+ instruction,$signed(PC_plus_four)+ $signed(sign_extended_immediate),testdata1,testdata2,$signed(read_data1),ALU_input2,rs,rt,rd,write_data,sign_extended_immediate,zero,jump,jump_src);
//             );
    end  
endmodule
