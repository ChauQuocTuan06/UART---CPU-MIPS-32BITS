module full_adder_32bit(a,b,cin,s);
    input   wire[31:0] a,b;
    input   wire cin;
    output  wire[31:0] s;
    wire[31:0]         cout;
    full_adder fa0(.a(a[0]), .b(b[0]), .cin(cin), .s(s[0]), .cout(cout[0]));
    genvar i;
    generate
        for(i=1;i<32;i=i+1) begin: FA_GEN
            full_adder fa(.a(a[i]), .b(b[i]), .cin(cout[i-1]), .s(s[i]), .cout(cout[i]));
        end
    endgenerate
endmodule