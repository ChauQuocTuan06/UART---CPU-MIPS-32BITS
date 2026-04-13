module uart_tx (
    input wire clk,
    input wire rst_n,
    input wire baud_tick, // Tín hi?u này ph?i nháy 1 xung m?i 104.167ns (cho 9600 baud)
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);
    localparam IDLE=0, START=1, DATA=2, STOP=3;
    reg [1:0] state;
    reg [2:0] bit_cnt;
    reg [7:0] data_buf;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            tx <= 1'b1;
            tx_busy <= 1'b0;
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    if (tx_start) begin
                        data_buf <= tx_data;
                        tx_busy <= 1'b1;
                        state <= START;
                    end else begin
                        tx_busy <= 1'b0;
                    end
                end
                
                START: begin
                    tx <= 1'b0; // Kéo xu?ng 0 d? t?o Start bit
                    if (baud_tick) begin
                        bit_cnt <= 0;
                        state <= DATA;
                    end
                end
                
                DATA: begin
                    tx <= data_buf[bit_cnt]; // Ð?y t?ng bit Data ra
                    if (baud_tick) begin
                        if (bit_cnt == 7) begin
                            state <= STOP;
                        end else begin
                            bit_cnt <= bit_cnt + 1'b1;
                        end
                    end
                end
                
                STOP: begin
                    tx <= 1'b1; // Kéo lên 1 d? t?o Stop bit
                    if (baud_tick) begin
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule