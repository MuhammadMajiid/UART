//  This module is created by Mohamed Maged
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
    #5  ResetN = 1'b1;
end

//Baud
initial begin
            BaudRate = 2'b11;        
    #500000 BaudRate = 2'b01;
    #500000 BaudRate = 2'b10;
    #500000 BaudRate = 2'b00;
end

endmodule