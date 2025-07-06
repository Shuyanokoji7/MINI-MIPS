module Decoder(
    input [31:0] instruction,
    output reg [5:0] opcode,funct,
    output reg [4:0] rs,rd,rt,shamt,
    output reg [15:0] immediate,
    output reg [25:0] jump_addr
);
    
    always @(*) begin
        opcode = instruction[31:26];
        funct = instruction[5:0];
        rs = instruction[25:21];
        rt = instruction[20:16];
        rd = instruction[15:11];
        shamt = instruction[10:6];
        immediate = instruction[15:0];
        jump_addr = instruction[25:0];
    end
endmodule
