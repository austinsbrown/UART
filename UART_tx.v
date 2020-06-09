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
    reg [2:0] bitPosition                                       // index for data reg

    always @(posedge clk)
    begin
        case(state)
            idle:
                if(enable)                                      // if enable bit is high
                begin
                    state       <= state;                       // go to next state
                    data        <= inputData;                   // transfer input data to data reg
                    bitPosition <= 0;                           // clear data index
                end
            end

            startState:
            begin
                
            end
        endcase
    end
endmodule