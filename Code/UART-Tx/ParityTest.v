//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  Test Bech for the parity module

module ParityTest();

//regs
reg [7:0] DataIn;
reg ResetN;
reg [1:0] ParityType;

//wire
wire ParityOut;

//Instatniation of the design module
Parity ForTest(.*);

//Reset
initial begin
    ResetN = 1'b0;
    #10 ResetN = 1'b1;
end

//Test
initial begin
        DataIn = 8'b00001111;
    #10 DataIn = 8'b10101111;
    #10 DataIn = 8'b10101001;
    #10 DataIn = 8'b10101001;
    #10 DataIn = 8'b10111101;
end

//Cases
initial begin
        ParityType = 2'b00;
    #10 ParityType = 2'b00;
    #10 ParityType = 2'b01;
    #10 ParityType = 2'b10;
    #10 ParityType = 2'b11;
end

endmodule