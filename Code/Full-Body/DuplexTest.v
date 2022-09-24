//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: DuplexTest.v
//  TYPE: Test fixture "Test bench".
//  DATE: 24/9/2022
//  KEYWORDS: Duplex, UART.

`timescale 1ns/1ps
module DuplexTest;

//-----------------reg to drive the inputs-----------------\\
reg        reset_n_tb;
reg        send_tb;
reg        clock_tb;
reg [1:0]  parity_type_tb;
reg [1:0]  baud_rate_tb;
reg [7:0]  data_in_tb;

//-----------------wires to show the outputs-----------------\\
wire       tx_active_flag_tb;
wire       tx_done_flag_tb;
wire       rx_active_flag_tb;
wire       rx_done_flag_tb;
wire [2:0] error_flag_tb;
wire [7:0] data_out_tb;

//-----------------DUT-----------------\\
Duplex DUT(
    //  Inputs
    .reset_n(reset_n_tb),
    .send(send_tb),
    .clock(clock_tb),
    .parity_type(parity_type_tb),
    .baud_rate(baud_rate_tb),
    .data_in(data_in_tb),

    //  Outputs
    .tx_active_flag(tx_active_flag_tb),
    .tx_done_flag(tx_done_flag_tb),
    .rx_active_flag(rx_active_flag_tb),
    .rx_done_flag(rx_done_flag_tb),
    .error_flag(error_flag_tb),
    .data_out(data_out_tb)
);

//-----------------Save wave form-----------------\\
initial
begin
    $dumpfile("DuplexTest.vcd");
    $dumpvars;
end

//-----------------Monitorin the outputs and the inputs-----------------\\
initial begin
    $monitor($time, "   The Outputs:  Data Out = %h  Error Flag = %b  Tx Active Flag = %b  Tx Done Flag = %b  Rx Active Flag = %b  Rx Done Flag = %b  The Inputs:   Reset = %b  Send = %b  Data In = %h  Parity Type = %b  Baud Rate = %b ",
    data_out_tb[7:0], error_flag_tb[2:0], tx_active_flag_tb, tx_done_flag_tb, rx_active_flag_tb, rx_done_flag_tb, reset_n_tb, send_tb,
    data_in_tb[7:0], parity_type_tb[1:0], baud_rate_tb[1:0]);
end

//-----------------System clock generator 50MHz-----------------\\
initial 
begin
    clock_tb = 1'b0;
    forever 
    begin
        #10 clock_tb = ~clock_tb;
    end
end

//-----------------Resetting the system-----------------\\
initial 
begin
    reset_n_tb = 1'b0;
    #10 reset_n_tb = 1'b1;
end
//-----------------Test NO.1-----------------\\
initial
begin
    send_tb    = 1'b1;
    //  Testing data
    data_in_tb = 8'b10101010 ;
    //  test for baud rate 9600 and odd parity
    baud_rate_tb   = 2'b10;
    parity_type_tb = 2'b01;
    #1354166.671;   //  waits for the whole frame to be sent
end

//-----------------Test NO.2-----------------\\
initial
begin
    //  Testing data
    #1300000;
    data_in_tb = 8'b1011100 ;
    #90000;  // waits for the first frame
    //  test for baud rate 19200 and even parity
    baud_rate_tb   = 2'b11;
    parity_type_tb = 2'b10;
    #677083.329;   //  waits for the whole frame to be sent
end

//-----------------Stop-----------------\\                       
initial begin
    #2450000 $stop;
    // Simulation for 3 ms
end

endmodule