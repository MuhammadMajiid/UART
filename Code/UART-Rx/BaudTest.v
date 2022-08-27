//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  TestBench for the clocking module "Sampling".

`timescale 1ns/1ps
module BaudTest;

//  Regs to drive inputs
reg ResetN;
reg Clock;
reg [1:0] BaudRate;

//  wires to show outputs
wire BaudOut;

//  Instance of the design module
Sampling ForTest(
    .ResetN(ResetN),
    .Clock(Clock),
    .BaudRate(BaudRate),

    .BaudOut(BaudOut)
);

//  Clock 50MHz
initial
begin
    Clock = 1'b0;
    forever #10 Clock = ~Clock;
end

//  Resetting the system
initial 
begin
    ResetN = 1'b0;
    #10  ResetN = 1'b1;
end

//  Test
integer i = 0;
initial 
begin
    for (i = 0; i < 4; i = i +1) 
    begin
        BaudRate = i;
        #(5000000/(i+1));
    end
end

endmodule