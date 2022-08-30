//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: InRegTest.v
//  TYPE: Test fixture "Test bench".
//  DATE: 30/8/2022
//  KEYWORDS: Register.

`timescale 1ns/1ps
module InRegTest;

//  Regs to drive the inputs
reg done_flag;
reg reset_n;
reg [7:0] data_in;

//  wire to show the output
wire [7:0] reg_data;

//  Design module instance
InReg ForTest(
    .done_flag(done_flag),
    .reset_n(reset_n),
    .data_in(data_in),

    .reg_data(reg_data)
);

//  Resetting the system
initial
begin
        reset_n = 1'b0;
    #20 reset_n = 1'b1;
end

//  Done Flag Enable
initial
begin
        done_flag = 1'b1;
    #20 done_flag = 1'b0;
    #10 done_flag = 1'b1;
    #20 done_flag = 1'b0;
    #10 done_flag = 1'b1;
    #20 done_flag = 1'b0;
    #10 done_flag = 1'b1;
    #20 done_flag = 1'b0;
    #10 done_flag = 1'b1;
end

//  Data Input Test
initial
begin
        data_in = 8'b0000_1111;
    #10 data_in = 8'b0000_0001;
    #10 data_in = 8'b0100_1111;
    #10 data_in = 8'b0011_1101;
    #10 data_in = 8'b1010_1001;
    #10 data_in = 8'b1101_0011;
    #10 data_in = 8'b1110_1100;
    #10 data_in = 8'b0000_1111;
    #10 data_in = 8'b0110_1011;
    #10 data_in = 8'b1100_1010;
    #10 data_in = 8'b0111_1000;
    #10 data_in = 8'b0011_1100;
    #10 data_in = 8'b1111_0000;
end

endmodule