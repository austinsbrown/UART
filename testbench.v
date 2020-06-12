`timescale 1ns/100ps
`include   "UART.v"

module UART_tb();
    reg         enable = 0;
    reg         clk    = 0;
    reg         serialInput;
    reg  [7:0]  inputData  = 0;
    wire        serialOutput;
    wire        txBusy;
    wire [7:0]  outputData = 0;

    UART uut
    (
        .enable(enable),
        .clk(clk),
        .inputData(inputData),
        .serialInput(serialInput),
        .serialOutput(serialOutput),
        .txBusy(txBusy),
        .outputData(outputData)
    );

    initial 
    begin
        $dumpfile("dump.vcd");
        $dumpvars(0, UART_tb);

        #1;
        enable = 1;
        inputData = 8'b10101010;

    end

    always
        #1  clk = !clk; 

    initial 
        #150  $finish; 
endmodule