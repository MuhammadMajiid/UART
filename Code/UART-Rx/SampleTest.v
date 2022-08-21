//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.

`timescale 1ns/1ns
module SampleTest();

//Regs
reg ResetN, Clock, OverSel;
reg [1:0] BaudRate;

//wires
wire BaudOut;

//Instance of the design module
Sampling ForTest(ResetN, Clock, OverSel,BaudRate, BaudOut);

//Clock 50MHz
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
    {OverSel,BaudRate} = 3'b111;        
    #1000000;
    {OverSel,BaudRate} = 3'b110;
    #1000000;
    {OverSel,BaudRate} = 3'b101;
    #1000000;
    {OverSel,BaudRate} = 3'b100;
    #1000000;
    {OverSel,BaudRate} = 3'b011;        
    #1000000;
    {OverSel,BaudRate} = 3'b010;
    #1000000;
    {OverSel,BaudRate} = 3'b001;
    #1000000;
    {OverSel,BaudRate} = 3'b000;
    #1000000;
end

endmodule