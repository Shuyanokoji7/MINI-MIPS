module SignExtender(
    input [15:0] immediate,
    output  [31:0] sign_extended_immediate
);  
    assign sign_extended_immediate = {  {16{immediate[15]}} , immediate};
endmodule