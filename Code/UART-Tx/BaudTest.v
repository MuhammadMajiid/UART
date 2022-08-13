//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.

`timescale 1ns/1ns
module BaudTest();

//Regs
reg ResetN, Clock, Enable;
reg [1:0] BaudRate;

//wires
wire Tick;

//Instance of the design module
BaudGen ForTest(ResetN, Clock, Enable, BaudRate, Tick);

//Clock
initial begin
    Clock = 1'b0;
    forever #10 Clock = ~Clock;
end

//Reset and Enable
initial begin
    ResetN = 1'b0;
    Enable = 1'b0;
    #10 ResetN = 1'b1;
    Enable = 1'b1;
end

//Baud
initial begin
            BaudRate = 2'b00;
    #250000 BaudRate = 2'b01;
    #250000 BaudRate = 2'b10;
    #250000 BaudRate = 2'b11;
    #250000
end

endmodule