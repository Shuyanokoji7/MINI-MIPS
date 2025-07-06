module update_pc(zero,jump_target,PC_plus_four,signExtendedImmediate,readDATA1,clk,rst,jump,jump_src,nextPC);
input zero;
input [25:0] jump_target;
input [31:0] PC_plus_four;
input [31:0] signExtendedImmediate;
input [31:0] readDATA1;
input clk,rst,jump,jump_src;        
output reg [31:0] nextPC;
    always@(posedge clk or rst) begin
        if(rst) begin
            nextPC<=32'd0;
        end
        else begin
            if(jump) begin
                if(jump_src) begin
                    nextPC<=readDATA1;
                end  
                else begin
                    nextPC<={PC_plus_four[31:28],2'b00,jump_target[25:0]};
                end  
            end
            else begin
                if(zero) begin   // if branch split
                    nextPC<=$signed(PC_plus_four)+$signed(signExtendedImmediate);
                end 
                else begin
                    nextPC<=PC_plus_four;
                end     
            end
        end        
    end
endmodule