module uart_cpu_mux (
    // Tín hi?u ch?n kênh
    input wire load_mode,       // 1: Ch?n UART, 0: Ch?n CPU
    
    // ========================================================
    // LU?NG 1: Tín hi?u t? UART_32B_IP
    // ========================================================
    input wire [31:0] uart_addr,
    input wire [31:0] uart_wdata,
    input wire uart_we,
    input wire uart_re,

    // ========================================================
    // LU?NG 2: Tín hi?u t? CPU MIPS
    // ========================================================
    input wire [31:0] cpu_addr,
    input wire [31:0] cpu_wdata,
    input wire cpu_memwrite,
    input wire cpu_memread,

    // ========================================================
    // NGÕ RA: C?m th?ng vào DATA_MEMORY
    // ========================================================
    output wire [31:0] final_addr,
    output wire [31:0] final_wdata,
    output wire final_we,
    output wire final_re
);

    // Kênh Ð?a ch? (Address): Uu tiên UART n?u dang n?p code HO?C dang mu?n d?c d? li?u lên PC
    assign final_addr  = (load_mode || uart_re) ? uart_addr  : cpu_addr;
    
    // Kênh Ghi (Write): Ch? uu tiên UART n?u công t?c n?p code b?t
    assign final_wdata = load_mode              ? uart_wdata : cpu_wdata;
    assign final_we    = load_mode              ? uart_we    : cpu_memwrite;
    
    // Kênh Ð?c (Read): Uu tiên UART n?u b?t n?p code (ép b?ng 0) HO?C UART ra l?nh d?c
    assign final_re    = (load_mode || uart_re) ? uart_re    : cpu_memread;

endmodule