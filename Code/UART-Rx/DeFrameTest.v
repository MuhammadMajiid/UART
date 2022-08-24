//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  This is a TestBench for the deframe unit.

`timescale 1ns/1ns
module DeFrameTest;

//  Regs to drive the inputs
reg ResetN;
reg RecievedFlag;
reg [10:0] DataParl;

//  Wires to show the outputs
wire ParityBit;
wire StartBit;
wire StopBit;
wire [7:0] RawData;

//  Design module instance
DeFrame ForTest(
    .ResetN(ResetN),
    .RecievedFlag(RecievedFlag),
    .DataParl(DataParl),

    .ParityBit(ParityBit),
    .StartBit(StartBit),
    .StopBit(StopBit),
    .RawData(RawData)
);

//  Resetting the system
initial begin
    ResetN = 1'b0;
    #10 ResetN = 1'b1;
end

//  Initializing the Data
initial begin
    DataParl = {11{1'b1}};
end

//  Enable
initial begin
    RecievedFlag = 1'b0;
    #10 RecievedFlag = 1'b1;
    #50 RecievedFlag = 1'b0;
    #30 RecievedFlag = 1'b1;
end

//  Test
initial begin
    //  Checking Ten different frames
    repeat(10)
    begin
      #10 DataParl = $random % (2048);
    end
end

endmodule