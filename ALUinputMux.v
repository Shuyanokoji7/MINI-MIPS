module ALU_Input_Mux(
    input [31:0] read1,read2, immediate,
    input alu_src,
    output reg [31:0] alu_input1,alu_input2
);
always @(*) begin
        alu_input1 = read1;
        if (alu_src) begin
            alu_input2 = immediate;
        end 
        else begin
            alu_input2 = read2;
        end
    end
endmodule