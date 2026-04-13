module DATA_MEMORY(
  input rst_n,clk,
  input [31:0] ADDR,       
  input [31:0] WRITEDATA,   
  input MEMWRITE,          
  input MEMREAD,            
  output [31:0] READDATA   
);
  reg [31:0] WORD [31:0];  
  reg [31:0] read_reg;
  integer i;
  always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        for(i = 0; i < 32; i = i + 1) begin
          WORD[i] <= i;
      end
    end
    else if (MEMWRITE)
        WORD[ADDR] <= WRITEDATA;
end
    always @(posedge clk) begin
        if (MEMREAD)
            read_reg <= WORD[ADDR];
        else
            read_reg <= 32'b0;
    end

    assign READDATA = read_reg;
endmodule