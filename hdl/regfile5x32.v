module regfile5x32bit (
    input wire clk,rst_n,RegWrite,
    input wire [4:0] RR1,RR2,
    input wire [4:0] WR,
    input wire [31:0] WD,
    output wire [31:0] RD1,RD2
);
    reg [31:0] reg_mem [31:0];
    integer i;
    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for (i = 0; i < 32; i = i + 1) begin
                reg_mem[i] <= 32'b0;
            end
        end
        else begin
            if(RegWrite) begin
                reg_mem[WR] <= WD;
            end
        end
    end
    assign RD1 = (RR1 == 0)? 32'b0 : reg_mem[RR1];
    assign RD2 = (RR2 == 0)? 32'b0 : reg_mem[RR2];
endmodule