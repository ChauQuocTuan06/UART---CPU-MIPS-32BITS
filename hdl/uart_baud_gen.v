module uart_baud_gen #(
    parameter CLK_FREQ = 50000000, // T?n s? Clock h? th?ng (Hz)
    parameter BAUD_RATE = 9600,    // T?c d? Baud (bps)
    parameter BAUDTICK = CLK_FREQ / (BAUD_RATE * 16) 
)(
    input  wire clk_i,
    input  wire rst_n,
    output wire tick_o  // Xung tick (nhanh g?p 16 l?n baudrate)
);
    localparam BIT_WIDTH = $clog2(BAUDTICK);
    reg [BIT_WIDTH-1:0] count;

    assign tick_o = (count == BAUDTICK - 1) ? 1'b1 : 1'b0;

    always @(posedge clk_i or negedge rst_n) begin
        if (!rst_n) 
            count <= 0;
        else 
            count <= (count == BAUDTICK - 1) ? 0 : count + 1'b1;
    end
endmodule