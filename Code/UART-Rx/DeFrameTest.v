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
reg reset_n;
reg recieved_flag;
reg [10:0] data_parll;

//  Wires to show the outputs
wire parity_bit;
wire start_bit;
wire stop_bit;
wire [7:0] raw_data;

//  Design module instance
DeFrame ForTest(
    .reset_n(reset_n),
    .recieved_flag(recieved_flag),
    .data_parll(data_parll),

    .parity_bit(parity_bit),
    .start_bit(start_bit),
    .stop_bit(stop_bit),
    .raw_data(raw_data)
);

//  Resetting the system
initial begin
    reset_n = 1'b0;
    #10 reset_n = 1'b1;
end

//  Initializing the Data
initial begin
    data_parll = {11{1'b1}};
end

//  Enable
initial begin
    recieved_flag = 1'b0;
    #10 recieved_flag = 1'b1;
    #50 recieved_flag = 1'b0;
    #30 recieved_flag = 1'b1;
end

//  Test
initial begin
    //  Checking Ten different frames
    repeat(10)
    begin
      #10 data_parll = $random % (2048);
    end
end

endmodule