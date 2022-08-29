//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  A TestBench module code for a Serial-In-Parallel-Out shift register,

`timescale 1ns/1ps
module SipoTest;

//  Regs to drive inputs
reg ResetN;
reg DataTx;
reg BaudOut;

//  Wires to show outputs
wire RecievedFlag;
wire [10:0] DataParl;

//  Design instance
SIPO ForTest(
    .ResetN(ResetN),
    .DataTx(DataTx),
    .BaudOut(BaudOut),

    .RecievedFlag(RecievedFlag),
    .DataParl(DataParl)
);

//  System clock is Baud clock
//  Testing the most common BaudRate 9600 bps
//  16*9600 for oversampling protocol
initial 
begin
    BaudOut = 1'b0;
    forever begin
        #3255.208 BaudOut = ~BaudOut;
    end
end

//  Resetting the system
initial 
begin
    ResetN = 1'b0;
    #100 ResetN = 1'b1;
end

//  Test 
initial 
begin
    //  Data frame of 11010101010
    //  Sent at baud rate 9600
    DataTx = 1'b1;
    //  Idle at first
    repeat(10)
    begin
      #104166.667 DataTx = ~DataTx;
    end
    //  Stop bit
    #104166.667;
    DataTx = 1'b1;
end

endmodule