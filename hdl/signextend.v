module sign_extend (
    input wire [15:0] I,
    output wire [31:0] O
);
    assign O = {{16{I[15]}},I};
endmodule