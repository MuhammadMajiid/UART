//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.


`timescale 1ns/1ns
module InRegTest();

//Regs
reg DoneFlag, ResetN;
reg [7:0] DataIn;

//wire
wire [7:0] RegIn;

//Design module instance
InReg ForTest(DoneFlag, ResetN, DataIn, RegIn);

//Reset 
initial begin
        ResetN = 1'b0;
    #20 ResetN = 1'b1;
end

//DoneFlag
initial begin
        DoneFlag = 1'b1;
    #20 DoneFlag = 1'b0;
    #10 DoneFlag = 1'b1;
    #20 DoneFlag = 1'b0;
    #10 DoneFlag = 1'b1;
    #20 DoneFlag = 1'b0;
    #10 DoneFlag = 1'b1;
    #20 DoneFlag = 1'b0;
    #10 DoneFlag = 1'b1;
end

//DataIn
initial begin
        DataIn = 8'b0000_1111;
    #10 DataIn = 8'b0000_0001;
    #10 DataIn = 8'b0100_1111;
    #10 DataIn = 8'b0011_1101;
    #10 DataIn = 8'b1010_1001;
    #10 DataIn = 8'b1101_0011;
    #10 DataIn = 8'b1110_1100;
    #10 DataIn = 8'b0000_1111;
    #10 DataIn = 8'b0110_1011;
    #10 DataIn = 8'b1100_1010;
    #10 DataIn = 8'b0111_1000;
    #10 DataIn = 8'b0011_1100;
    #10 DataIn = 8'b1111_0000;
end

endmodule