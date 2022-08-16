//  This module is created by Ali Morgan
//  Undergraduate ECE student, Alexandria university.

`timescale 1ns/1ns
module BaudTest();

//Regs
reg ResetN, Clock;
reg [1:0] BaudRate;

//wires
wire BaudOut;

//Instance of the design module
BaudRateGen ForTest(ResetN, Clock, BaudRate, BaudOut);

//Clock
initial begin
                Clock = 1'b0;
    forever #10 Clock = ~Clock;
end

//Reset and Enable
initial begin
        ResetN = 1'b0;
    #10  ResetN = 1'b1;
end

//Baud
initial begin
      BaudRate = 2'b11;        
    #250000;
     BaudRate = 2'b10;
    #250000;
     BaudRate = 2'b01;
    #250000;
     BaudRate = 2'b00;
    #250000;
end

endmodule