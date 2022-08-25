//  This module is created by Mohamed Maged.
//  Undergraduate ECE student, Alexandria university.
//  This is the TestBench for Top module for the Reciever unit.
`timescale 1ns/1ns
module RxTest;

//  Regs to drive inputs
reg ResetN;
reg DataTx;
reg Clock;
reg [1:0] ParityType;
reg [1:0] BaudRate;

//  Wires to show the outputs
wire [2:0] ErrorFlag;
wire [7:0] Data;

//  Instance of the design module
RxUnit ForTest(
    .ResetN(ResetN),
    .DataTx(DataTx),
    .Clock(Clock),
    .ParityType(ParityType),
    .BaudRate(BaudRate),

    .ErrorFlag(ErrorFlag),
    .Data(Data)
);

//  Resetting the system
initial begin
    ResetN = 1'b0;
    #10 ResetN = 1'b1;
end

//  System Clock 50MHz
initial begin
    Clock = 1'b0;
    forever begin
        #10 Clock = ~Clock;
    end
end

//  Test
initial begin
    
end

endmodule