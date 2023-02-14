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
reg         reset_n;
reg         data_tx;
reg         clock;
reg  [1:0]  parity_type;
reg  [1:0]  baud_rate;

//  Wires to show the outputs
wire         done_flag;
wire         active_flag;
wire  [2:0]  error_flag;
wire  [7:0]  data_out;
 
//  Instance of the design module
RxUnit ForTest(
    .reset_n(reset_n),
    .data_tx(data_tx),
    .clock(clock),
    .parity_type(parity_type),
    .baud_rate(baud_rate),

    .active_flag(active_flag),
    .done_flag(done_flag),
    .error_flag(error_flag),
    .data_out(data_out)
);

//  dump
initial
begin
    $dumpfile("RxTest.vcd");
    $dumpvars;
end

//Monitorin the outputs and the inputs
initial begin
    $monitor($time, "   The Outputs:  Data Out = %b  Error Flag = %b Active Flag = %b  Done Flag = %b  The Inputs:   Reset = %b   Data In = %b  Parity Type = %b  Baud Rate = %b ",
    data_out[7:0], error_flag[2:0], active_flag, done_flag, reset_n, 
    data_tx, parity_type[1:0], baud_rate[1:0]);
end

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

//  Test
initial 
begin
    //  Test for 9600 baud_rate
    baud_rate = 2'b10;
    //  Testing with ODD parity
    parity_type = 2'b01;
    //  Data for test, frame of 11001010110
    //  with ODD parity, 1 stop bit
    //  Sent at baud rate of 9600
    data_tx = 1'b1;
    //  Idle at first
    #104166.667 data_tx = 1'b0;
    #104166.667 data_tx = 1'b1;
    #104166.667 data_tx = 1'b1;
    #104166.667 data_tx = 1'b0;
    #104166.667 data_tx = 1'b1;
    #104166.667 data_tx = 1'b0;
    #104166.667 data_tx = 1'b1;
    #104166.667 data_tx = 1'b0;
    #104166.667 data_tx = 1'b0;
    #104166.667 data_tx = 1'b1;
    //  Stop bit
    #104166.667 data_tx = 1'b1;
    #104166.667;
    #104166.667;

//  _____________________________

    #100;
    //  Test for 19200 baud_rate
    baud_rate = 2'b11;
    //  Testing with EVEN parity
    parity_type = 2'b10;
    //  Data for test, frame of 11001010110
    //  with EVEN parity, 1 stop bit
    //  Sent at baud rate of 19200
    data_tx = 1'b1;
    //  Idle at first
    #52083.333 data_tx = 1'b0;
    #52083.333 data_tx = 1'b1;
    #52083.333 data_tx = 1'b1;
    #52083.333 data_tx = 1'b0;
    #52083.333 data_tx = 1'b1;
    #52083.333 data_tx = 1'b0;
    #52083.333 data_tx = 1'b1;
    #52083.333 data_tx = 1'b0;
    #52083.333 data_tx = 1'b0;
    #52083.333 data_tx = 1'b1;
    //  Stop bit
    #52083.333;
    data_tx = 1'b1;
    #52083.333;

end

//  Stop
initial begin
    #2600000 $stop;
    // Simulation for 2 ms
end

endmodule