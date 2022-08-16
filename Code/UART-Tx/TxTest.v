//  This module is created by Ali Morgan, credits to him
//  Undergraduate ECE student, Alexandria university.
//  This is the testbench for the top module for the UART-Tx Unit.

`timescale 1ns/1ns
module TxTest ();

//Regs 
reg ResetN, StopBits, DataLength, Send, Clock; 
reg [1:0] ParityType, BaudRate;
reg [7:0] DataIn; 

//wires
wire DataOut, ParallParOut, ActiveFlag, DoneFlag; 

//Instance for the design module
TxUnit TxUT(
    .ResetN(ResetN), .StopBits(StopBits), .DataLength(DataLength), .Send(Send), 
    .Clock(Clock), .ParityType(ParityType), .BaudRate(BaudRate), .DataIn(DataIn), //Inputs


    .DataOut(DataOut), .ParallParOut(ParallParOut), .ActiveFlag(ActiveFlag), .DoneFlag(DoneFlag) //outputs
);

//50Mhz Clock
initial begin
    Clock = 1'b0;
    forever #10 Clock = ~Clock; 
end

integer  i ;
initial begin
    //reseting the system for 10ns 
    Send = 0 ; 
    ResetN = 0 ; 
    #10 ; 
    ResetN = 1 ;
    Send = 1 ; 

    StopBits = 0 ; // 1 stop bit 
    DataLength = 1 ; // 8 bits
    ParityType = 2'b00 ; 
    BaudRate = 2'b00 ;

    DataIn = 8'b10101010 ;

    for (i = 0;i < 4 ; i = i + 1) begin //testing four different speeds (BaudRate)
        BaudRate = i ; 
        ParityType = i ; 
        if (i > 1) begin
            StopBits = 1 ; 
            DataLength = 0 ; 
        end
        else begin
            StopBits    = 0;
            DataLength  = 1;
        end
        Send = 1 ; //Send data 
        #(4560000 / (i + 1)) ; 
        Send = 0 ; //stop Sending
        #1000;
    end 
end

/*
//Reset
initial begin
          ResetN = 1'b0; 
    #10   ResetN = 1'b1; 
    #50000  ResetN = 1'b1;
    #40000  ResetN = 1'b1;
end

//Send signal
initial begin
          Send = 1'b0;
    #10   Send = 1'b1;
    #50000 Send = 1'b0;
    #40000  Send = 1'b1;
end

//initialization 
initial
fork
    StopBits    = 1'b0; 
    DataLength  = 1'b1;
    ParityType  = 2'b00; 
    BaudRate    = 2'b00;
    DataIn      = 8'b0101_1010;
join

//Test
integer  Dummy;
initial begin

//test for 4 speeds with 4 parity types
    for (Dummy = 0; Dummy < 4 ; Dummy = Dummy + 1) begin 
        BaudRate    = Dummy; 
        ParityType  = Dummy; 
        if (Dummy > 1) begin
            StopBits    = 1'b1; 
            DataLength  = 1'b0; 
        end
        else begin
            StopBits    = 0;
            DataLength  = 1;
        end
        #(4560000 / (Dummy + 1)) ; 
    end 
end
*/

endmodule