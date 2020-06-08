`timescale 1ns/100ps
`include   "baud_gen.v"

module baud_gen_tb();
    wire clk = 0;
    reg rxClkEn, txClkEn;

    always
        #5 clk = ~clk;
        
    baud_gen uut
    (
        .clk(clk),
        .rxClkEn(rxClkEn),
        .txClkEn(txClkEn)
    );

    initial 
    begin
        
    end

    

    initial 
        #150 $finish;
endmodule