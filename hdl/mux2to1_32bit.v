module mux2to1_32bit (
    input wire [31:0] I0,I1,
    input wire S0,
    output wire [31:0] Y
);
    assign Y = S0 ? I1 : I0;
endmodule