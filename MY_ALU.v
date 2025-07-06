module MY_ALU(
    input [31:0] ALU_input1, ALU_input2,
    input [3:0] branch,
    input [4:0] shamt,
    input [3:0] ALU_control,
    output reg [31:0] ALU_result,
    output reg [31:0] HI, LO,
    output reg zero, 
    output carry_out, overflow
);      
    localparam [3:0] Not         = 4'd0;
    localparam [3:0] ADD         = 4'd1;
    localparam [3:0] SUB         = 4'd2;
    localparam [3:0] ADDU        = 4'd3;
    localparam [3:0] SUBU        = 4'd4;
    localparam [3:0] MUL         = 4'd5;
    localparam [3:0] MADD        = 4'd6;
    localparam [3:0] MADDU       = 4'd7;
    localparam [3:0] AND         = 4'd8;
    localparam [3:0] OR          = 4'd9;
    localparam [3:0] XOR         = 4'd10;
    localparam [3:0] SLL         = 4'd11;  // Shift left logical
    localparam [3:0] SRL         = 4'd12;  // Shift right logical
    localparam [3:0] SRA         = 4'd13;
    localparam [3:0] Slt         = 4'd14;
    localparam [3:0] Seq         = 4'd15;

    localparam [3:0] Branch_equal    = 4'd1;
    localparam [3:0] Branch_notEqual = 4'd2;
    localparam [3:0] Branch_bgt      = 4'd3;
    localparam [3:0] Branch_bgte     = 4'd4;
    localparam [3:0] Branch_ble      = 4'd5;
    localparam [3:0] Branch_bleq     = 4'd6;
    localparam [3:0] Branch_bleu     = 4'd7;
    localparam [3:0] Branch_bgtu     = 4'd8;


    reg [63:0] temp;
   always@(*)begin
    case(branch)
        Branch_equal: begin
        zero = ($signed(ALU_input1) == $signed(ALU_input2)); // beq
        end
        Branch_notEqual: begin
            zero = ($signed(ALU_input1) != $signed(ALU_input2)); // bne
        end
        Branch_bgt: begin
            zero = ($signed(ALU_input1) > $signed(ALU_input2));  // bgt (signed)
        end
        Branch_bgte: begin
            zero = ($signed(ALU_input1) >= $signed(ALU_input2)); // bge (signed)
        end
        Branch_ble: begin
            zero = ($signed(ALU_input1) < $signed(ALU_input2));  // blt (signed)
        end
        Branch_bleq: begin
            zero = ($signed(ALU_input1) <= $signed(ALU_input2)); // ble (signed)
        end
        Branch_bleu: begin
            zero = ($unsigned(ALU_input1) <= $unsigned(ALU_input2)); // bleu (unsigned)
        end
        Branch_bgtu: begin
            zero = ($unsigned(ALU_input1) > $unsigned(ALU_input2));  // bgtu (unsigned)
        end
        default: begin
            zero = 0;              
            case(ALU_control)
                ADD: begin
                    ALU_result=$signed(ALU_input1) + $signed(ALU_input2);
                end 
                SUB: begin
                    ALU_result=$signed(ALU_input1) -$signed(ALU_input2);
                end 
                ADDU: begin
                    ALU_result=$unsigned(ALU_input1) + $unsigned(ALU_input2);
                end 
                SUBU: begin
                    ALU_result=$unsigned(ALU_input1) - $unsigned(ALU_input2);
                end 
                //
                MUL: begin
                    temp = $unsigned(ALU_input1) * $unsigned(ALU_input2);
                    HI = temp[63:32];
                    LO = temp[31:0];
                end 
                MADD: begin
                    temp = $signed(ALU_input1) * $signed(ALU_input2);
                    temp = temp + {HI, LO};
                    HI = temp[63:32];
                    LO = temp[31:0];
                end 
                MADDU: begin
                    temp = $unsigned(ALU_input1) * $unsigned(ALU_input2);
                    temp = temp + {HI, LO};
                    HI = temp[63:32];
                    LO = temp[31:0];
                end 
                //
                AND: begin
                    ALU_result=ALU_input1 & ALU_input2;
                end 
                OR: begin
                    ALU_result=ALU_input1 | ALU_input2;
                end 
                XOR: begin
                    ALU_result=ALU_input1 ^ ALU_input2;
                end 
                Slt: begin
                    ALU_result=($signed(ALU_input1)<$signed(ALU_input2));
                end
                Seq: begin
                    ALU_result=($signed(ALU_input1)==$signed(ALU_input2));
                end
                SLL: begin // Shift Left Logical
                    ALU_result = ALU_input2 << shamt;
                end
                SRL: begin
                    // Shift Right Logical
                    ALU_result = ALU_input2 >> shamt;
                end
                SRA: begin
                    // Shift Right Arithmetic (preserves the sign bit for signed values)
                    ALU_result = $signed(ALU_input2) >>> shamt;
                end
                Not: begin
                    // Bitwise NOT
                    ALU_result = ~ALU_input1;
                end    
                default : begin
                    ALU_result=32'd0;
                end    
            endcase
        end    
    endcase
   end 

endmodule