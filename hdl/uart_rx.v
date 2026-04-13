module uart_rx (
    input wire clk,
    input wire rst_n,
    input wire rx,          // Chân nh?n v?t lý
    input wire baud_tick,   // Xung t? baud_gen
    output reg [7:0] rx_data,
    output reg rx_done      // Nháy 1 lên khi nh?n xong 1 byte
);
    localparam IDLE=0, START=1, DATA=2, STOP=3;
    reg [1:0] state;
    reg [3:0] tick_cnt; // Ð?m 16 tick
    reg [2:0] bit_cnt;  // Ð?m 8 bit
    reg [7:0] data_buf;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            tick_cnt <= 0;
            bit_cnt <= 0;
            rx_done <= 1'b0;
            rx_data <= 0;
        end else begin
            rx_done <= 1'b0; // M?c d?nh t?t
            case (state)
                IDLE: begin
                    if (~rx) begin // Phát hi?n Start bit (kéo xu?ng 0)
                        state <= START;
                        tick_cnt <= 0;
                    end
                end
                START: begin
                    if (baud_tick) begin
                        if (tick_cnt == 7) begin // L?y m?u ? gi?a bit
                            state <= (~rx) ? DATA : IDLE; // Ki?m tra l?i cho ch?c
                            tick_cnt <= 0;
                            bit_cnt <= 0;
                        end else tick_cnt <= tick_cnt + 1'b1;
                    end
                end
                DATA: begin
                    if (baud_tick) begin
                        if (tick_cnt == 15) begin
                            tick_cnt <= 0;
                            data_buf[bit_cnt] <= rx; // Ð?c bit
                            if (bit_cnt == 7) state <= STOP;
                            else bit_cnt <= bit_cnt + 1'b1;
                        end else tick_cnt <= tick_cnt + 1'b1;
                    end
                end
                STOP: begin
                    if (baud_tick) begin
                        if (tick_cnt == 15) begin
                            state <= IDLE;
                            rx_done <= 1'b1; // Báo hi?u dã có 1 byte
                            rx_data <= data_buf;
                        end else tick_cnt <= tick_cnt + 1'b1;
                    end
                end
            endcase
        end
    end
endmodule