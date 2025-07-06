module registerFile (rst,readAddress1, readAddress2, writeAddress, writeData,
WE, dataOut1, dataOut2, clock,testdata1,testdata2,testdata3,testdata4);
    input rst;
    input [4:0] readAddress1, readAddress2, writeAddress;
    input [31:0] writeData;
    input WE, clock;
    output [31:0] dataOut1, dataOut2;
    output [31:0] testdata1;
    output [31:0] testdata2;
    output [31:0] testdata3;
    output [31:0] testdata4;
    reg [31:0] RF [31:0];
    assign dataOut1= RF[readAddress1];
    assign dataOut2= RF[readAddress2];
    assign testdata1=RF[9];
    assign testdata2=RF[10];
    assign testdata3=RF[writeAddress];
    assign testdata3=RF[12];
    integer i;
    always @(negedge clock or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                RF[i] <= 32'b0;
        end
        else if (WE && writeAddress != 0) begin
            RF[writeAddress] = writeData;
        end
    end

endmodule