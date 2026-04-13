module uart_32b_ip #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)(
    input wire clk, rst_n,
    input wire rx_pin,
    output wire tx_pin,
    
    // Tín hi?u di?u khi?n
    input wire mode_write,
    input wire trigger_read,
    
    // Giao di?n 32-bit c?m vào MUX/RAM
    output wire [31:0] mem_addr,
    output wire [31:0] mem_wdata,
    output wire mem_we,
    output wire mem_re,
    input  wire [31:0] mem_rdata
);
    wire baud_tick, rx_done, tx_busy, tx_start;
    wire [7:0] rx_data, tx_data;

    uart_baud_gen #( .CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE) ) u_baud (
        .clk_i(clk), .rst_n(rst_n), .tick_o(baud_tick)
    );

    uart_rx u_rx (
        .clk(clk), .rst_n(rst_n), .rx(rx_pin), .baud_tick(baud_tick),
        .rx_data(rx_data), .rx_done(rx_done)
    );

    uart_tx u_tx (
        .clk(clk), .rst_n(rst_n), .baud_tick(baud_tick), .tx_start(tx_start),
        .tx_data(tx_data), .tx(tx_pin), .tx_busy(tx_busy)
    );

    uart_bridge_32b u_bridge (
        .clk(clk), .rst_n(rst_n),
        .rx_done(rx_done), .rx_data(rx_data),
        .tx_busy(tx_busy), .tx_start(tx_start), .tx_data(tx_data),
        .mem_addr(mem_addr), .mem_wdata(mem_wdata), .mem_we(mem_we),
        .mem_re(mem_re), .mem_rdata(mem_rdata),
        .mode_write(mode_write), .trigger_read(trigger_read)
    );
endmodule