module baud_gen
(
    clk,                                                // input clock
    rxClkEn,                                            // 50 mHz clock source for recieve line
    txClkEn                                             // 50 mHz clock source for transmit line
);

    parameter rxMax = 50000000 / (115200*16);           // oversampled by factor of 16 for stability
    parameter txMax = 50000000 / 115200;   

    parameter rxMaxWidth = $clog2(rxMax);               // number of bits needed to contain rxmax and txmax
    parameter txMaxWidth = $clog2(txMax);

    input clk;
    output reg rxClkEn = 0;                             // initialize to 0
    output reg txClkEn = 0;                             // initialize to 0

    reg [rxMaxWidth-1:0] rxCount = 0;                   // counter for clock divider
    reg [rxMaxWidth-1:0] txCount = 0;    
    reg [rxMaxWidth-1:0] rxFinal = 0;                   // values for counter to count to              
    reg [rxMaxWidth-1:0] txFinal = 0;       

    always @(posedge clk)
    begin
        if(rxCount == txFinal)                          // if the count value is reached...
        begin
            rxClkEn <= ~rxClkEn;                        // invert output clock signal
            rxClkEn <= 0;                               // reset counter
        end
        else
        begin
            rxClkEn <= rxClkEn+1;                       // increment counter
        end
    end

    always @(posedge clk)
    begin
        if(txCount == txFinal)
        begin
            txClkEn <= ~txClkEn;
            txClkEn <= 0;
        end
        else
        begin
            txClkEn <= txClkEn+1;
        end
    end
endmodule 