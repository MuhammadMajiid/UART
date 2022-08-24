//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  A TestBench for the error check unit
`timescale 1ns/1ns
module ChechTest;

//  Regs to drive the inputs
reg ResetN;
reg ParityBit;
reg StartBit;
reg StopBit;
reg [1:0] ParityType;
reg [7:0] RawData;

//  Wires to show the output
wire [2:0] ErrorFlag;

//  design module instance
ErrorCheck ForTest(
    .ResetN(ResetN),
    .ParityBit(ParityBit),
    .StartBit(StartBit),
    .StopBit(StopBit),
    .ParityType(ParityType),
    .RawData(RawData),

    .ErrorFlag(ErrorFlag)
);

//  resetting the system
initial begin
    ResetN = 1'b0;
    #10 ResetN = 1'b1;
end

//  initialization 
initial begin
    StartBit   = 1'b0;
    StopBit    = 1'b1;
    ParityBit  = 1'b1;
    ParityType = 2'b00;
    RawData    = 8'b1;
    #10;
end

//  Test
integer i = 0;
initial begin
    for (i = 0; i < 4; i = i + 1 ) begin
        ParityType = i;
        RawData    = $random % (256);    //  random number ranges from [-256:255]
        StartBit   = $random % (1);     //  random number ranges from [0:1]
        StopBit    = $random % (1);     //  random number ranges from [0:1]
        ParityBit  = $random % (1);     //  random number ranges from [0:1]
        case (ErrorFlag)
            3'b000 : $display("At %d   Holy moly! There is no error!", $time);
            3'b001 : $display("At time %d There is a parity bit error!", $time);
            3'b010 : $display("At time %d There is a start bit error!", $time);
            3'b011 : $display("At time %d There is a parity bit and start bit errors!", $time);
            3'b100 : $display("At time %d There is a stop bit error!", $time);
            3'b101 : $display("At time %d There is a parity bit and stop bit errors!", $time);
            3'b110 : $display("At time %d There is a start bit and stop bit errors!", $time);
            3'b111 : $display("At time %d This is a trash packet!", $time);
            default: $display("At %d   Holy moly! There is no error!", $time);
        endcase
        #50;
    end
end

endmodule