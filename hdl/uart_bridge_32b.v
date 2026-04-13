module uart_bridge_32b (
    input wire clk, rst_n,
    
    // Giao ti?p UART 8-bit
    input wire rx_done,
    input wire [7:0] rx_data,
    input wire tx_busy,
    output reg tx_start,
    output reg [7:0] tx_data,

    // Giao ti?p v?i RAM 32-bit (H? d?a ch? Word: 0, 1, 2, 3...)
    output wire [31:0] mem_addr,
    output reg [31:0] mem_wdata,
    output reg mem_we,
    output reg mem_re,
    input wire [31:0] mem_rdata,

    // Tín hi?u di?u khi?n n?p/d?c
    input wire mode_write,   // 1: PC n?p code, 0: PC d?i d?c
    input wire trigger_read  // Xung yêu c?u g?i data lên PC
);

    // ==========================================
    // LU?NG RX: Gom 4 byte -> Ghi 1 Word
    // ==========================================
    reg [31:0] rx_addr;
    reg [1:0] rx_byte_cnt;
    reg [31:0] rx_buf;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_addr <= 32'd0;
            rx_byte_cnt <= 2'd0;
            mem_we <= 1'b0;
        end else if (mode_write) begin
            mem_we <= 1'b0; 
            
            // ÐÃ S?A: Ch? tang d?a ch? lên 1 sau khi ghi xong 1 Word
            if (mem_we) rx_addr <= rx_addr + 32'd1; 

            // ÐÃ S?A: Gi?i h?n m?ng RAM là 32 Word (t? 0 d?n 31)
            if (rx_done && rx_addr < 32'd32) begin 
                case (rx_byte_cnt)
                    2'b00: rx_buf[7:0]   <= rx_data;
                    2'b01: rx_buf[15:8]  <= rx_data;
                    2'b10: rx_buf[23:16] <= rx_data;
                    2'b11: rx_buf[31:24] <= rx_data;
                endcase
                
                if (rx_byte_cnt == 2'b11) begin
                    mem_wdata <= {rx_data, rx_buf[23:0]};
                    mem_we <= 1'b1;
                    rx_byte_cnt <= 2'd0;
                end else rx_byte_cnt <= rx_byte_cnt + 1'b1;
            end
        end else begin
            rx_addr <= 0; rx_byte_cnt <= 0;
        end
    end

    // ==========================================
    // LU?NG TX: Ð?c 1 Word -> G?i 4 byte
    // ==========================================
    reg [31:0] tx_addr;
    reg [1:0] tx_byte_cnt;
    reg [31:0] tx_buf;
    reg [2:0] tx_state;

    localparam TX_IDLE = 0, TX_READ_MEM = 1, TX_PUSH = 2, TX_WAIT = 3, TX_NEXT = 4;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_state <= TX_IDLE;
            tx_addr <= 32'd0;
            tx_start <= 1'b0;
            mem_re <= 1'b0;
        end else begin
            tx_start <= 1'b0;
            case (tx_state)
                TX_IDLE: begin
                    if (trigger_read && !mode_write) begin
                        tx_addr <= 32'd0;
                        tx_state <= TX_READ_MEM;
                        mem_re <= 1'b1;
                    end else mem_re <= 1'b0;
                end
                TX_READ_MEM: begin
                    tx_buf <= mem_rdata; 
                    tx_byte_cnt <= 2'd0;
                    tx_state <= TX_PUSH;
                end
                TX_PUSH: begin
                    if (!tx_busy) begin
                        tx_data <= tx_buf[7:0];
                        tx_start <= 1'b1;
                        tx_state <= TX_WAIT;
                    end
                end
                TX_WAIT: begin
                    if (!tx_busy && !tx_start) begin
                        if (tx_byte_cnt == 2'b11) tx_state <= TX_NEXT;
                        else begin
                            tx_buf <= tx_buf >> 8;
                            tx_byte_cnt <= tx_byte_cnt + 1'b1;
                            tx_state <= TX_PUSH;
                        end
                    end
                end
                TX_NEXT: begin
                    // ÐÃ S?A: Ði?m d?ng là Word s? 31
                    if (tx_addr == 32'd31) begin 
                        tx_state <= TX_IDLE;
                        mem_re <= 1'b0;
                    end else begin
                        tx_addr <= tx_addr + 32'd1; 
                        tx_state <= TX_READ_MEM;
                    end
                end
            endcase
        end
    end

    assign mem_addr = mode_write ? rx_addr : tx_addr;
endmodule