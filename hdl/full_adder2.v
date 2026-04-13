module full_adder(a,b,cin,s,cout);
    input   wire    a,b,cin;
    output  reg     s,cout;
    always@(a,b,cin) begin
        s = a^b^cin;
        cout = a&b | cin&(a^b);
    end
endmodule
