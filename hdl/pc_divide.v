module divide_pc (
    input wire [31:0] PC,
    output wire [5:0] Op,
    output wire [15:0] Funct,
    output wire [4:0] o1,o2,o3
);
    assign Op = PC[31:26];
    assign Funct = PC[15:0];
    assign o1 = PC[25:21];
    assign o2 = PC[20:16];
    assign o3 = PC[15:11];
endmodule