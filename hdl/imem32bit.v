module IMEM32 (
    input wire [4:0] addr, 
    output reg [31:0] q
);
    always @(*) begin
        case (addr[4:0])
          
            5'd0:  q = 32'h04430800; 
            5'd4:  q = 32'h20A4FFF7; 
            5'd8:  q = 32'h40411800; 
            5'd12: q = 32'h10410010; 
            5'd16: q = 32'h08410000;
            
      
            default: q = 32'h00000000;
        endcase
    end
endmodule