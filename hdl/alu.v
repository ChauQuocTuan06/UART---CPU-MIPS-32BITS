module ALU (
    input wire [1:0] ALUcontrol,
    input wire [31:0] A,B,
    output wire [31:0] Result
);
    wire [31:0] S0,S1,I1;
    wire Y;
    assign I1[31:1] = 31'd0;
    full_adder_32bit fa0 (.a(A),.b(B),.s(S0),.cin(1'b0));
    full_adder_32bit fa1 (.a(A),.b(~B),.s(S1),.cin(1'b1));
    assign I1[0] = S1[31] ? 1'b1 : 1'b0;
    assign Y = ALUcontrol[0] ? 1'b1 : 1'b0;
    mux2to1_32bit mux0 (.I0(S0),.I1(I1),.S0(Y),.Y(Result));
endmodule