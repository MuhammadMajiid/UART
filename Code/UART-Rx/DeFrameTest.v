//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: DeFrameTest.v
//  TYPE: Test fixture "Test bench".
//  DATE: 31/8/2022
//  KEYWORDS: Frame, Data.

`timescale 1ns/1ps
module DeFrameTest;

//  Regs to drive the inputs
reg  [10:0]  data_parll;

//  Wires to show the outputs
wire         parity_bit;
wire         start_bit;
wire         stop_bit;
wire         done_flag;
wire  [7:0]  raw_data;

//  Design module instance
DeFrame ForTest(
    .data_parll(data_parll),

    .parity_bit(parity_bit),
    .start_bit(start_bit),
    .stop_bit(stop_bit),
    .done_flag(done_flag),
    .raw_data(raw_data)
);

//  dump
initial
begin
    $dumpfile("DeFrameTest.vcd");
    $dumpvars;
end

//Monitorin the outputs and the inputs
initial begin
    $monitor($time, "   The Outputs:  Data Out = %b  Start bit = %b  Stop bit = %b  Parity bit = %b Done Flag = %b   The Inputs: Data In = %b",
    raw_data[7:0], start_bit, stop_bit, parity_bit, done_flag, data_parll[10:0]);
end

//  Initializing the Data
initial begin
    data_parll = {11{1'b1}};
end

//  Test
initial begin
    //  Checking Five different frames
    repeat(5)
    begin
      #10 data_parll = $random % (2048);
    end
end

//  Stop
initial begin
    #100 $stop;
    //  Simulation for 100 ns
end

endmodule