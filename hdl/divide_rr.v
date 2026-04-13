module divide_rr (
    input wire [31:0] PC,
    output wire [4:0] rr1,rr2
);
    assign rr1 = PC[25:21];
    assign rr2 = PC[20:16];
endmodule