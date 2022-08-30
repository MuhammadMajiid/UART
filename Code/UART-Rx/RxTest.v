//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: RxTest.v
//  TYPE: Test fixture "Test bench".
//  DATE: 31/8/2022
//  KEYWORDS: Reciever, UART-Rx.

`timescale 1ns/1ps
module RxTest;

//  Regs to drive inputs
reg reset_n;
reg data_tx;
reg clock;
reg [1:0] parity_type;
reg [1:0] baud_rate;

//  Wires to show the outputs
wire [2:0] error_flag;
wire [7:0] Data;

//  Instance of the design module
RxUnit ForTest(
    .reset_n(reset_n),
    .data_tx(data_tx),
    .clock(clock),
    .parity_type(parity_type),
    .baud_rate(baud_rate),

    .error_flag(error_flag),
    .Data(Data)
);

//  Resetting the system
initial 
begin
    reset_n = 1'b0;
    #10 reset_n = 1'b1;
end

//  System clock 50MHz
initial 
begin
    clock = 1'b0;
    forever 
    begin
        #10 clock = ~clock;
    end
end

//  Test for 9600 baud_rate
initial 
begin
    baud_rate = 2'b10;
    //  Testing with odd parity
    parity_type = 2'b01;
    //  Data for test, frame of 110101010
    //  with odd parity, 1 stop bit
    //  Sent at baud rate of 9600
    data_tx = 1'b1;
    //  Idle at first
    repeat(10)
    begin
      #104166.667 data_tx = ~data_tx;
    end
    //  Stop bit
    #104166.667;
    data_tx = 1'b1;
end

endmodule