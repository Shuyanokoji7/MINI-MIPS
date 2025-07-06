module my_ALU_CTRL(
    input [3:0] aluOp,
    input [5:0] funct,
    output jump_src,
    output reg [3:0] aluControl
);  
    localparam [3:0] ALU_OP_RTYPE=4'd0;

    localparam [3:0] NOT =4'd0;
    localparam [3:0] ADD  = 4'd1;
    localparam [3:0] SUB  = 4'd2;
    localparam [3:0] ADDU  = 4'd3;
    localparam [3:0] SUBU  = 4'd4;
    localparam [3:0] MUL  = 4'd5;
    localparam [3:0] MADD   = 4'd6;
    localparam [3:0] MADDU  = 4'd7;
    localparam [3:0] AND   = 4'd8;
    localparam [3:0] OR  = 4'd9;
    localparam [3:0] XOR  = 4'd10;
    localparam [3:0] SLL  = 4'd11;  // Shift left logical
    localparam [3:0] SRL  = 4'd12;  // Shift right logical
    localparam [3:0] SRA  = 4'd13;
    localparam [3:0] SLT  = 4'd14;
    localparam [3:0] SEQ  = 4'd15;

    localparam [5:0] fun_ADD  = 6'd32;  // 100000
    localparam [5:0] fun_SUB  = 6'd34;  // 100010
    localparam [5:0] fun_ADDU = 6'd33;  // 100001
    localparam [5:0] fun_SUBU = 6'd35;  // 100011
    localparam [5:0] fun_MUL  = 6'd24;  // 011000
    localparam [5:0] fun_AND  = 6'd36;  // 100100
    localparam [5:0] fun_OR   = 6'd37;  // 100101
    localparam [5:0] fun_XOR  = 6'd38;  // 100110
    localparam [5:0] fun_SLL  = 6'd0;   // 000000
    localparam [5:0] fun_SRL  = 6'd2;   // 000010
    localparam [5:0] fun_SRA  = 6'd3;   // 000011
    localparam [5:0] fun_SLT  = 6'd42;  // 100000 
    localparam [5:0] fun_JR=6'd8;

    localparam [5:0] fun_SEQ=6'd48;
    localparam [5:0] fun_MADD=6'd49;
    localparam [5:0] fun_MADDU=6'd50;
    localparam [5:0] fun_NOT=6'd49;
    assign jump_src=    (funct==fun_JR);
    always@(*)begin
            case(aluOp)
            ALU_OP_RTYPE: begin
                case(funct)
                    fun_ADD: begin
                        aluControl<=ADD;
                    end
                    fun_SUB: begin
                        aluControl<=SUB;
                    end
                    fun_ADDU: begin
                        aluControl<=ADDU;
                    end
                    fun_SUBU: begin
                        aluControl<=SUBU;
                    end
                    fun_MUL: begin
                        aluControl<=MUL;
                    end
                    fun_AND: begin
                        aluControl<=AND;
                    end
                    fun_OR: begin
                        aluControl<=OR;
                    end
                    fun_XOR: begin
                        aluControl<=XOR;
                    end
                    fun_SLL: begin
                        aluControl<=SLL;
                    end
                    fun_SRL: begin
                        aluControl<=SRL;
                    end
                    fun_SRA: begin
                        aluControl<=SRA;
                    end
                    fun_SLT: begin
                        aluControl<=SLT;
                    end
                    fun_SEQ: begin
                        aluControl<=SEQ;
                    end
                    fun_NOT: begin
                        aluControl<=NOT;
                    end
                    fun_MADD: begin
                        aluControl<=MADD;
                    end    
                    fun_MADDU: begin
                        aluControl<=MADDU;
                    end
                    default:
                        aluControl<=ADD;      
                            
                endcase
            end
            default: aluControl <= aluOp;    
        endcase
    end    
endmodule