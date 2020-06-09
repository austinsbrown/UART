module UART_rx
(
    serialData,
    clk,
    clkEn,
    outputData
);

    input serialData;
    input clk;
    input clkEn;
    output reg [7:0] outputData;

    reg [1:0] state         = 0;                                        // holds the current state
    reg [1:0] startState    = 0;                                        // looks for start bit
    reg [1:0] dataState     = 1;                                        // recieve data bits
    reg [1:0] stopState     = 2;                                        // get stop bit
    reg [7:0] sampleCount   = 0;                                        // for stability purposes
    reg [7:0] parallelData  = 0;                                        // fianl data in parallel form
    reg [4:0] bitPosition   = 0;                                        // index for array

    always @(posedge clk)       
    begin       
        if(clkEn)                                                       // if baud clk
        begin       
            case(state)     
                startState:     
                begin       
                    if(!serialData || sampleCount != 0)                 // if start bit is 0 or sample count isnt 0
                        sampleCount <= sampleCount+1;       

                    if(sampleCount == 15)                               // if sample count has timed out
                    begin       
                        state        <= dataState;                      // go to next state
                        bitPosition  <= 0;                              // set bit position to 0
                        sampleCount  <= 0;                              // reset sample count
                        parallelData <= 0;                              // data reg is 0
                    end
                end

                dataState:
                begin
                    sampleCount <= sampleCount+1;                       // increment sample count
                    if(sampleCount == 8)                                // if halfway into sample.. 
                    begin
                        parallelData[bitPosition] <= serialData;        // record the data bit
                        bitPosition <= bitPosition+1;                   // increment bit position
                    end
                    if(bitPosition == 8 && sampleCount == 15)           // if bit position is maxed and samplecount is maxed
                        state <= stopState;                             // go to next state
                end

                stopState:
                begin
                    if(sampleCount == 15 || (sampleCount >= 8 && !serialData))
                    begin
                        state       <= startState;                      // go back to stop state
                        outputData  <= parallelData;                    // output the recieved data
                        sampleCount <= 0;                               // reset sample count
                    end
                    else
                    begin
                        sampleCount <= sampleCount+1;
                    end
                end

                default:
                begin
                    state <= startState;
                end
            endcase
        end
    end
endmodule 