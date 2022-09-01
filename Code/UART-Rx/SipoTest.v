//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: SipoTest.v
//  TYPE: Test fixture "Test bench".
//  DATE: 31/8/2022
//  KEYWORDS: SIPO, Shift register, Reciever.

`timescale 1ns/1ps
module SipoTest;

//  Regs to drive inputs
reg reset_n;
reg data_tx;
reg baud_clk;

//  Wires to show outputs
wire active_flag;
wire recieved_flag;
wire [10:0] data_parll;

//  Design instance
SIPO ForTest(
    .reset_n(reset_n),
    .data_tx(data_tx),
    .baud_clk(baud_clk),

    .active_flag(active_flag),
    .recieved_flag(recieved_flag),
    .data_parll(data_parll)
);

//  dump
initial
begin
    $dumpfile("SipoTest.vcd");
    $dumpvars;
end

//  Monitoring the outputs and the inputs
initial begin
    $monitor($time, "   The Outputs:  Active Flag = %b  Recieved Flag = %b  Data = %b
                        The Inputs:   Reset = %b  Data In = %b",
    active_flag, recieved_flag, data_parll[10:0], reset_n, data_tx);
end

//  System clock is Baud clock
//  Testing the most common BaudRate 9600 bps
//  16*9600 for oversampling protocol
initial 
begin
    baud_clk = 1'b0;
    forever begin
        #3255.208 baud_clk = ~baud_clk;
    end
end

//  Resetting the system
initial 
begin
    reset_n = 1'b0;
    #100 reset_n = 1'b1;
end

//  Test 
initial 
begin
    //  Data frame of 11010101010
    //  Sent at baud rate 9600
    data_tx = 1'b1;
    //  Idle at first
    repeat(10)
    begin
      #104166.667 data_tx = ~data_tx;
    end
    //  Stop bit
    #104166.667;
    data_tx = 1'b1;
    #104166.667;
end

//  Stop
initial begin
    #1250000 $stop;
    // Simulation for 1.5 ms
end

endmodule