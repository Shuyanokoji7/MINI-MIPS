module tb_instructionMemory;

        reg rst;
        reg enable;
        reg clk;
        reg [9:0] address;
        reg [9:0]inst_write_address;
        reg [31:0]inst_write_data;
        reg [9:0]mem_write_input_address;
        reg [31:0]mem_write_input_data;
        wire [31:0]test;
        wire [31:0]tb_ALUresult;
        main inst(
            .rst(rst),
            .clk(clk),
            .enable(enable),
            .inst_write_address(inst_write_address),
            .inst_write_data(inst_write_data),
            .mem_write_input_address(mem_write_input_address),
            .mem_write_input_data(mem_write_input_data),
            .test(test),
            .tb_ALUresult(tb_ALUresult)

        );

        initial begin
        clk = 0;             // Start clock at 0
        forever #4 clk = ~clk;  // Toggle clock every 5 time units (period = 10)
        end

        initial begin
            rst = 0;
            enable = 0;
            #10
            rst = 1;
            enable = 1;

            // --- Write 4 dummy instructions ---
            inst_write_address = 0;
            inst_write_data = 32'd0;
            inst_write_address = 1;
            inst_write_data = 32'd0;
            inst_write_address = 2;
            inst_write_data = 32'd0;
            inst_write_address = 3;
            inst_write_data = 32'b001001_00000_00100_0000000000000000;  // addi $t0, $zero, 0
            #10;

            inst_write_address = 4;
            inst_write_data = 32'b001001_00000_01111_0000000000000101;  //    addi $t7, $zero, 5
            #10;

            inst_write_address = 5;
            inst_write_data = 32'b001001_00000_01000_0000000000000001;  // addi $t1, $zero, 1
            #10;

            inst_write_address = 6;
            inst_write_data = 32'b100000_01000_01111_0000000000010001;  // bgte , $t0 , $t7 , 17   change offset
            #10;

            inst_write_address = 7;
            inst_write_data = 32'b000000_00000_01000_01001_00010_000000;  //sll  , $t1 , $t0 , 2

            #10;

            inst_write_address = 8;
            inst_write_data = 32'b000000_01001_00100_01001_00000_100000;  // add t1,t0,t1

            #10;

            inst_write_address = 9;
            inst_write_data = 32'b100011_01001_01010_0000000000000000;  // Lw $t7, $zero, +7
            #10;

            inst_write_address = 10;
            inst_write_data =     32'b001001_01000_01011_1111111111111111;  // lw $t8, -1($s0+$t7))
            #10;

            inst_write_address = 11;
            inst_write_data = 32'b010110_01011_00000_0000000000001011;  // ble $t8, $t6, +4
            #10;

            inst_write_address = 12;
            inst_write_data = 32'b000000_00000_01011_01100_00010_000000;//     sw $t8, 0($s0+$t7))
            #10;

            inst_write_address = 13;
            inst_write_data = 32'b000000_01100001000110000000100000;  //     addi $t7, $t7, -1
            #10;

            inst_write_address = 14;
            inst_write_data = 32'b10001101100011010000000000000000;  //     j inner_loop (pc=6)
            #10;

            inst_write_address = 15;
            inst_write_data = 32'b01011101101010100000000000000011;  //     sw $t6, 0($s0+$t7)
            #10;

            inst_write_address = 16;
            inst_write_data =     32'b10101101100011010000000000000100;//  addi $t1, $t1, 1)
            #10;

            inst_write_address = 17;
            inst_write_data =     32'b00100101011010111111111111111111;  // j outer_loop (pc=3)
            #10;

            inst_write_address =18;
            inst_write_data =     32'b000010_00000000000000000000001010;  //lw $t0, 0($s0+0))
            #10;

            inst_write_address = 19;
            inst_write_data =     32'b00000000000010110110000010000000;  // lw $t1, 0($s0+1))
            #10;

            inst_write_address = 20;
            inst_write_data = 32'b00000001100001000110000000100000;  //     lw $t2, 0($s0+2)
            #10;

            inst_write_address = 21;
            inst_write_data =     32'b10101101100010100000000000000100;  //     lw $t3, 0($s0+3)
            #10;

            inst_write_address = 22;
            inst_write_data =     32'b00100101000010000000000000000001;  //     lw $t4, 0($s0+4)
            #10;

            inst_write_address = 23;
            inst_write_data = 32'b000010_00000000000000000000000101;  //         lw $t5, 0($s0+5)
            #10;

            inst_write_address = 24;
            inst_write_data =     32'b100011_00000_01001_0000000000010000; //     lw $t3, 0($s0+3)
            #10;
            inst_write_address = 25;
            inst_write_data =     {32{1'b1}}; //     lw $t3, 0($s0+3)
            #10;

//            inst_write_address = 5;
//            inst_write_data = {6'b101011, 5'b00000, 5'b01011, 16'b0000000000001100};  // sw $t3, 12($zero)
//            #10;
            // --- Write 4 dummy memory values ---
            mem_write_input_address = 0;      // sw t3 ,3$zero // addi t1,1 // jump 3rd instruction(lable)
            mem_write_input_data = 32'd4;
            #10;

            mem_write_input_address = 4;
            mem_write_input_data = 32'd2;
            #10;

            mem_write_input_address = 8;
            mem_write_input_data = 32'd1;
            #10;

            mem_write_input_address = 12;
            mem_write_input_data = 32'd7;
            #10;

            mem_write_input_address = 16;
            mem_write_input_data = 32'd9;
            #10;

            mem_write_input_address = 20;
            mem_write_input_data = 32'd8;
            #10;

            mem_write_input_address = 24;
            mem_write_input_data = 32'd14;
            #10;

            enable = 0;
            rst=0;
        end
        initial begin

            #100000 $finish;
        end
        initial begin

        end

    endmodule
