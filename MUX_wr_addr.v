module MUXWriteAddress(rt,rd,regDst,write_address);
    input [4:0]rt,rd;
    input [1:0]regDst;
    output reg [4:0]write_address;
    always@(*) begin
        if(regDst==2'd0)begin
            write_address<=rt;
        end
        else if(regDst==2'd1) begin
            write_address<=rd;
        end
        else if(regDst==2'd2) begin
            write_address<=5'd31;
        end
        else begin
            write_address<=5'd0;
        end                
    end    
endmodule