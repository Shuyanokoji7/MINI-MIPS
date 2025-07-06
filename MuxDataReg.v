module MUXDataToRegester(memToReg,regDst,readDATA,PC_plus_four,ALU_result,writedata);
    input memToReg;
    input [1:0]regDst;
    input [31:0]readDATA;
    input [31:0]PC_plus_four;
    input [31:0]ALU_result;
    output reg [31:0]writedata;
    always@(*) begin
        if(regDst==2'b10) begin
            writedata<=PC_plus_four;
        end
        else begin
            if(memToReg) begin
                writedata<=readDATA;
            end 
            else begin
                writedata<=ALU_result;
            end       

        end    
    end
endmodule