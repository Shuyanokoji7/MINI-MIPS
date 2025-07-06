module myControlUnit(opcode,regDst,regWrite,aluSrc,memRead,memWrite,memToReg,jump,branch,aluOp);
    input [5:0] opcode;
    output reg [1:0] regDst;
    output reg regWrite,aluSrc,memRead,memWrite,memToReg,jump;
    output reg [3:0] branch;
    output reg [3:0] aluOp;
    // Define local parameters for ALU operation codes
        localparam [3:0] ALU_OP_RTYPE=4'd0;
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
        localparam [3:0] Slt  = 4'd14;
        localparam [3:0] Seq  = 4'd15;    
         // Shift right arithmetic
        // localparam [3:0] SLT  = 4'd14;// Shift left logical
        // localparam [3:0] SRL  = 4'd15;  // Shift right logical
        // localparam [3:0] SRA  = 4'd16;  // Shift right arithmetic
        // localparam [3:0] SLT  = 4'd17; 
        // localparam [3:0] OR   = 4'd18;
        // localparam [3:0] XOR  = 4'd19;
        // localparam [3:0] SLL  = 4'd8;  // Shift left logical
        // localparam [3:0] SRL  = 4'd9;  // Shift right logical
        // localparam [3:0] SRA  = 4'd10;  // Shift right arithmetic
        // localparam [3:0] SLT  = 4'd11;  // Set on less than
        localparam [5:0] opCode_R_Type   = 6'd0;
        localparam [5:0] opCode_addIU_Type = 6'd9;
        localparam [5:0] opCode_ANDI_Type  = 6'd12;
        localparam [5:0] opCode_ORI_Type   = 6'd13;
        localparam [5:0] opCode_XORI_Type  = 6'd14;
        localparam [5:0] opCode_addI_Type  = 6'd8;
        localparam [5:0] opCode_load_Type  = 6'd35;
        localparam [5:0] opCode_SW_Type    = 6'd43;
        localparam [5:0] opCode_LUI_Type   = 6'd15;
        localparam [5:0] opCode_J_Type     = 6'd2;
        localparam [5:0] opCode_JAL_Type   = 6'd3;
        localparam [5:0] opCode_SLTI_Type  = 6'd10;
        localparam [5:0] opCode_beq_Type   = 6'd4;
        localparam [5:0] opCode_bne_Type   = 6'd5;
        

        // added instuction type
        localparam [5:0] opCode_bgt_Type=6'd32;  //32 bgte
        localparam [5:0] opCode_bgte_Type=6'd33;  //33 bgte
        localparam [5:0] opCode_ble_Type=6'd34;  //34 bgte
        localparam [5:0] opCode_bleq_Type=6'd36;  //35 bgte
        localparam [5:0] opCode_bleu_Type=6'd37;  //36 bleu
        localparam [5:0] opCode_bgtu_Type=6'd38;  //37 bgtu
        //localparam [5:0] opCode_bgtu_Type=6'b100000; //38 bgte
        localparam [5:0] opCode_SEQ_Type=6'b100110;  //38seq

        localparam [3:0] Branch_equal=4'd1;
        localparam [3:0] Branch_notEqual=4'd2;
        localparam [3:0] Branch_bgt=4'd3;
        localparam [3:0] Branch_bgte=4'd4;
        localparam [3:0] Branch_ble=4'd5;
        localparam [3:0] Branch_bleq=4'd6;
        localparam [3:0] Branch_bleu=4'd7;
        localparam [3:0] Branch_bgtu=4'd8;
    always @(*) begin
        

        regDst = 2'b00;
        regWrite = 0;
        aluSrc = 0;
        memRead = 0;
        memWrite = 0;
        memToReg = 0;
        jump = 0;
        branch = 4'b0000;
        aluOp = 4'b0000;
        // opcode decoding
        //6'b000000 R-type(add,addu,sub,subu,madd,maddu,mul,not and, or, xor, slt,seq,jr, sltu,sll,srl,sra,sla)
        case (opcode)
            opCode_R_Type: begin // R-type
                regDst = 2'b01;
                regWrite = 1;
                aluSrc = 0;
                memToReg = 0;
                aluOp = ALU_OP_RTYPE; // ALU operation defined by funct field
            end

            opCode_addI_Type: begin // addi
                regDst = 2'b00;
                regWrite = 1;
                aluSrc = 1;
                memToReg = 0;
                aluOp = ADD; // ALU operation for addi
            end

            opCode_addIU_Type: begin // addiu
                regDst = 2'b00;
                regWrite = 1;
                aluSrc = 1;
                memToReg = 0;
                aluOp = ADDU; // ALU operation for addi
            end
            opCode_ANDI_Type: begin // andi
                regDst = 2'b00;
                regWrite = 1;
                aluSrc = 1;
                memToReg = 0;
                aluOp = AND; // ALU operation for addi
            end
            opCode_ORI_Type: begin // ORI_TYPE
                regDst = 2'b00;
                regWrite = 1;
                aluSrc = 1;
                memToReg = 0;
                aluOp = OR; 
            end    
            opCode_XORI_Type: begin  //XORI
                regDst = 2'b00;
                regWrite = 1;
                aluSrc = 1;
                memToReg = 0;
                aluOp = XOR; 
            end
            opCode_load_Type: begin  //LW
                regDst = 2'b00;
                regWrite = 1;
                aluSrc = 1;
                memRead=1;
                memWrite=0;
                memToReg = 1;
                jump = 0;
                branch = 4'b0000;
                aluOp = ADD;    
            end
            opCode_SW_Type: begin  //SW
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 1;
                memRead=0;
                memWrite=1;
                memToReg = 1;
                jump = 0;
                branch = 4'b0000;
                aluOp = ADD;    
            end
            /// think again
            opCode_LUI_Type: begin  //LUI
                regDst = 2'b00;
                regWrite = 1;
                aluSrc = 1;
                memRead=0;
                memWrite=1;
                memToReg = 1;
                jump = 0;
                branch = 4'b0000;
                aluOp = ADD;    
            end
            opCode_beq_Type: begin  //Beq
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4'd1;
                aluOp = 4'd0;    
            end
            opCode_bne_Type: begin  //Bne
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4'd2;
                aluOp = 4'd0;    
            end
            opCode_bgt_Type: begin  //Bgt
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4;
                aluOp = 4'd3;    
            end
            opCode_bgte_Type: begin  //Bgte
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4'd4;
                aluOp = 4'd0;    
            end
            opCode_ble_Type: begin  //Ble
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4'd5;
                aluOp = 4'd0;    
            end
            opCode_bleq_Type: begin  //Bleq
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4'd6;
                aluOp = 4'd0;    
            end
            opCode_bleu_Type: begin  //Bleu
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4'd7;
                aluOp = 4'd0;    
            end
            opCode_bgt_Type: begin  //Bgtu
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4'd8;
                aluOp = 4'd0;    
            end
            opCode_bgtu_Type: begin  //Bgtu
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4'd8;
                aluOp = 4'd0;    
            end
            opCode_J_Type: begin  //Jump
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 1;
                branch = 4'd0;
                aluOp = 4'd0;    
            end
            opCode_JAL_Type: begin  //JAL
                regDst = 2'b10;
                regWrite = 1;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 1;
                branch = 4'd0;
                aluOp = 4'd0;    
            end
            opCode_SLTI_Type: begin  //SLTI
                regDst = 2'b0;
                regWrite = 1;
                aluSrc = 1;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4'd0;
                aluOp = Slt;    
            end
            opCode_SEQ_Type: begin  //SEQ
                regDst = 2'b00;
                regWrite = 1;
                aluSrc = 1;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4'd0;
                aluOp = Seq;    
            end
            default: begin
                regDst = 2'b00;
                regWrite = 0;
                aluSrc = 0;
                memRead=0;
                memWrite=0;
                memToReg = 0;
                jump = 0;
                branch = 4'd0;
                aluOp = 4'd0;
            end    
        endcase
    end
endmodule