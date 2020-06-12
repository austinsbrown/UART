`include "baud_gen.v"
`include "UART_tx.v"
`include "UART_rx.v"
module UART
(
    input  wire       enable,
    input  wire       clk,
    input  wire [7:0] inputData,
    input  wire       serialInput,
    output wire       serialOutput,
    output wire       txBusy,
    output wire [7:0] outputData
);
    wire TXEnable, RXEnable;
    baud_gen baud(clk, TXEnable, RXEnable);             // divide the clock to generate baud rate

   UART_tx transmission
   (
        enable,
        inputData,
        clk,
        TXEnable,
        serialOutput,
        txBusy
   ); 

   UART_rx revieve
   (
        serialInput,
        clk,
        RXEnable,
        outputData
   );
endmodule