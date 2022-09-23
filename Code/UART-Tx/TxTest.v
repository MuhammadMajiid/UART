//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: TxTest.v
//  TYPE: Test fixture "Test bench".
//  DATE: 30/8/2022
//  KEYWORDS: Tx.

`timescale 1ns/1ps
module TxTest;

//  Regs to drive the inputs
reg       reset_n;
reg       send;
reg       clock; 
reg [1:0] parity_type;
reg [1:0] baud_rate;
reg [7:0] data_in; 

//  wires to show the output
wire      data_tx;
wire      active_flag;
wire      done_flag; 

//  Instance for the design module
TxUnit ForTest(
    //  Inputs
    .reset_n(reset_n),
    .send(send), 
    .clock(clock),
    .parity_type(parity_type),
    .baud_rate(baud_rate),
    .data_in(data_in),

    //  Outputs
    .data_tx(data_tx),
    .active_flag(active_flag),
    .done_flag(done_flag)
);

//  dump
initial
begin
    $dumpfile("TxTest.vcd");
    $dumpvars;
end

//  Monitoring the outputs and the inputs
initial begin
    $monitor($time, "   The Outputs:  Data Tx = %b  Done Flag = %b  Active Flag = %b The Inputs:   Reset = %b  Data In = %b  Send = %b Parity Type = %b  Baud Rate = %b",
    data_tx, done_flag, active_flag, reset_n, 
    data_in[7:0], send, parity_type[1:0], baud_rate[1:0]);
end

//  50Mhz clock
initial
begin
    clock = 1'b0;
    forever
    begin
      #10 clock = ~clock; 
    end 
end

//  Reseting the system
initial
begin
    reset_n = 1'b0;
    send    = 1'b0;
    #100;
    reset_n = 1'b1;
    send    = 1'b1;
end

//  Varying the Baud Rate and the Parity Type
initial
begin
    //  Testing data
    data_in = 8'b10101010 ;
    //  test for baud rate 9600 and odd parity
    baud_rate   = 2'b10;
    parity_type = 2'b01;
    #1354166.671;   //  waits for the whole frame to be sent

    //  Testing data
    data_in = 8'b10101010 ;
    //  test for baud rate 19200 and even parity
    baud_rate   = 2'b11;
    parity_type = 2'b10;
    #677083.329;   //  waits for the whole frame to be sent
end

//  Stop
initial begin
    #2600000 $stop;
    // Simulation for 3 ms
end

endmodule