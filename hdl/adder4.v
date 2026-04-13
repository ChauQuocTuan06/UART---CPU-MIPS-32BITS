module adder4(a,cin,s);
    input   wire[4:0] a;
    input   wire cin;
    output  wire[4:0] s;
    wire[4:0]         cout;
    wire[4:0]          b;
    assign b = 5'd4;
    full_adder fa0(.a(a[0]), .b(b[0]), .cin(cin), .s(s[0]), .cout(cout[0]));
    genvar i;
    generate
        for(i=1;i<5;i=i+1) begin: FA_GEN
            full_adder fa(.a(a[i]), .b(b[i]), .cin(cout[i-1]), .s(s[i]), .cout(cout[i]));
        end
    endgenerate
endmodule