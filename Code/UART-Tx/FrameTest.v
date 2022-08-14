//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.

`timescale 1ns/1ns
module FrameTest();

//regs
reg [7:0] RegIn;
reg [1:0] ParityType;
reg ResetN, ParityOut, StopBits, DataLength;

//wires
wire [10:0] FrameOut;

//Design module instance
FrameGenerator ForTest(
     .RegIn(RegIn), .ParityType(ParityType), .ResetN(ResetN), .ParityOut(ParityOut), .StopBits(StopBits), .DataLength(DataLength), //inputs

     .FrameOut(FrameOut)      //output
);

//Reset
initial begin
     ResetN = 1'b0;
    #100 ResetN = 1'b1;
end

//Varying the stopits, datalength, paritytype >>> 4-bits with 16 different cases with 8 ignored cases <<<
initial begin

         {StopBits, DataLength, ParityType[1:0]} = 4'b0100;      //1-bit stop bit, 8-bits data length, no parity
         ParityOut  =   (^(8'b0000_0000))? 1'b0 : 1'b1;
    #100 {StopBits, DataLength, ParityType[1:0]} = 4'b0101;      //1-bit stop bit, 8-bits data length, odd parity
         ParityOut  =   (^(8'b0000_0010))? 1'b0 : 1'b1;
    #100 {StopBits, DataLength, ParityType[1:0]} = 4'b0110;      //1-bit stop bit, 8-bits data length, even parity
         ParityOut  =   (^(8'b0110_0011))? 1'b1 : 1'b0;
    #100 {StopBits, DataLength, ParityType[1:0]} = 4'b0111;      //1-bit stop bit, 8-bits data length, no parity
         ParityOut  =   (^(8'b0101_0010))? 1'b0 : 1'b1;
    #100 {StopBits, DataLength, ParityType[1:0]} = 4'b1000;      //2-bits stop bit, 7-bits data length, no parity
         ParityOut  =   (^(8'b1111_0100))? 1'b0 : 1'b1;
    #100 {StopBits, DataLength, ParityType[1:0]} = 4'b1001;      //2-bits stop bit, 7-bits data length, odd parity
         ParityOut  =   (^(8'b1111_0010))? 1'b0 : 1'b1;
    #100 {StopBits, DataLength, ParityType[1:0]} = 4'b1010;      //2-bits stop bit, 7-bits data length, even parity
         ParityOut  =   (^(8'b1111_0011))? 1'b1 : 1'b0;
    #100 {StopBits, DataLength, ParityType[1:0]} = 4'b1011;      //2-bits stop bit, 7-bits data length, no parity
         ParityOut  =   (^(8'b1111_0100))? 1'b0 : 1'b1;
end

//various Inputs 
initial begin

         RegIn = 8'b0000_0000;         //1-bit stop bit, 8-bits data bits, no parity bit
    #100 RegIn = 8'b0000_0010;         //1-bit stop bit, 8-bits data bits, odd parity
    #100 RegIn = 8'b0110_0011;         //1-bit stop bit, 8-bits data bits, even parity
    #100 RegIn = 8'b0101_0010;         //1-bit stop bit, 8-bits data bits, no parity bit
    #100 RegIn = 8'b1111_0100;          //2-bit stop bit, 7-bits data bits, no parity bit
    #100 RegIn = 8'b1111_0010;          //2-bit stop bit, 7-bits data bits, odd parity
    #100 RegIn = 8'b1111_0011;          //2-bit stop bit, 7-bits data bits, even parity
    #100 RegIn = 8'b1111_0100;          //2-bit stop bit, 7-bits data bits, no parity bit
    
end

endmodule