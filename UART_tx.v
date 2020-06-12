module UART_tx
(
    input       enable,                                         // enable bit
    input [7:0] inputData,                                      // data to transmit
    input       clk,                                            // clock source
    input       clkEn,                                          // baud clk
    output reg  serialOutput,                                   // serial output
    output reg  busy                                            // logic high while transmitting
);
    reg [1:0] state      = 0;                                   // holds current state
    reg [1:0] idle       = 0;                                   // wait for data to transmit
    reg [1:0] startState = 1;                                   // state for sending start bit
    reg [1:0] dataState  = 2;                                   // send data
    reg [1:0] stopState  = 3;                                   // send stop bit

    reg [7:0] data;                                             // holds data to send 
    reg [2:0] bitPosition;                                      // index for data reg

    always @(posedge clk)
    begin
        case(state)
            idle:
            begin
                if(enable)                                      // if enable bit is high
                begin
                    state       <= startState;                  // go to next state
                    data        <= inputData;                   // transfer input data to data reg
                    bitPosition <= 0;                           // clear data index
                end
            end

            startState:
            begin
                if(clkEn)
                begin
                    serialOutput <= 0;                          // send the start bit
                    state        <= dataState;                  // transition to data state
                end
            end

            dataState:
            begin
                if(bitPosition == 7)                            // if all data has transmitted
                begin
                    state <= stopState;                         // transition to stop state
                end
                else
                begin
                    bitPosition  <= bitPosition+1;              // increment indexer
                    serialOutput <= data[bitPosition];          // send data bit
                end
            end

            default:
            begin
                state        <= idle;                           // tranition to idle
                serialOutput <= 1;                              // send idle bit
            end
        endcase

        if(state != idle)                                       // check to see if uart module is busy
            busy <= 1;
        else
            busy <= 0;
    end
endmodule