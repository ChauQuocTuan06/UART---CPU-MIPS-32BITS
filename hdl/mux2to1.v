module mux2to1(
    input wire [4:0] I0,
    input wire [4:0] I1,
    input wire RegDst,
    output wire [4:0] Y
);

assign Y= RegDst ? I1 : I0;

endmodule
