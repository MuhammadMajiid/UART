//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  A TestBench module code for a Serial-In-Parallel-Out shift register,

`timescale 1ns/1ns
module SipoTest;

//  Regs to drive inputs
reg ResetN;
reg DataTx;
reg Recieve;
reg BaudOut;

//  Wires to show outputs
wire RecievedFlag;
wire [10:0] DataParl;

//  Design instance
SIPO ForTest(
    .ResetN(ResetN),
    .DataTx(DataTx),
    .Recieve(Recieve),
    .BaudOut(BaudOut),

    .RecievedFlag(RecievedFlag),
    .DataParl(DataParl)
);

//  System clock 50MHz
initial begin
    BaudOut = 1'b0;
    forever begin
        #10 BaudOut = ~BaudOut;
    end
end

//  Resetting the system
initial begin
    ResetN = 1'b0;
    #5 ResetN = 1'b1;
    #230 ResetN = 1'b0;
    #5 ResetN = 1'b1;
end

//  Enable
initial begin
    Recieve = 1'b0;
    #5 Recieve = 1'b1;
    #300 Recieve = 1'b0;
    #20 Recieve = 1'b1;
end

//  Test 
initial begin
    //  Data frame of 01010101010
    DataTx = 1'b1;
    repeat(11)
    begin
      #10 DataTx = ~DataTx;
      #10;
    end

    //  Data frame of 01010101010 but with Recieve got disabled
    repeat(11)
    begin
      #10 DataTx = ~DataTx;
      #10;
    end
end

endmodule