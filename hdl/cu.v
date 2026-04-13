module control_unit (
    input  [5:0] Op,          
    output       RegDst,      
    output       MemRead,      
    output       MemWrite,  
    output       MemToReg,     
    output       ALUSrc,      
    output       RegWrite,    
    output [1:0] ALUcontrol
);


    assign RegDst = Op[0] | Op[4];

  
    assign MemRead  = 1'b1 & Op[2]; 
    assign MemWrite = 1'b1 & Op[1];  
    assign MemToReg = 1'b1 & Op[2]; 

 
    assign ALUSrc = Op[1] | Op[2] | Op[3];


    assign RegWrite = Op[0] | Op[2] | Op[3] | Op[4];

    assign ALUcontrol[0] = Op[4] ? 1'b1 : 1'b0; 

  
    assign ALUcontrol[1] = 1'b1;

endmodule
