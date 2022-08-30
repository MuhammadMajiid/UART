//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: CheckTest.v
//  TYPE: Test fixture "Test bench".
//  DATE: 31/8/2022
//  KEYWORDS: Parity, Error.

`timescale 1ns/1ps
module ChechTest;

//  Regs to drive the inputs
reg reset_n;
reg parity_bit;
reg start_bit;
reg stop_bit;
reg [1:0] parity_type;
reg [7:0] raw_data;

//  Wire to show the output
wire [2:0] error_flag;

//  design module instance
ErrorCheck ForTest(
    .reset_n(reset_n),
    .parity_bit(parity_bit),
    .start_bit(start_bit),
    .stop_bit(stop_bit),
    .parity_type(parity_type),
    .raw_data(raw_data),

    .error_flag(error_flag)
);

//  resetting the system
initial 
begin
    reset_n = 1'b0;
    #10 reset_n = 1'b1;
end

//  initialization 
initial 
begin
    start_bit   = 1'b0;
    stop_bit    = 1'b1;
    parity_bit  = 1'b1;
    parity_type = 2'b00;
    raw_data    = 8'b1;
    #10;
end

//  Test
integer i = 0;
initial 
begin
    for (i = 0; i < 4; i = i + 1 ) 
    begin
        parity_type = i;
        raw_data    = $random % (256);   //  random number ranges from [-256:255]
        start_bit   = $random % (1);     //  random number ranges from [0:1]
        stop_bit    = $random % (1);     //  random number ranges from [0:1]
        parity_bit  = $random % (1);     //  random number ranges from [0:1]
        case (error_flag)
            3'b000 : $display("At %d   Holy moly! There is no error!", $time);
            3'b001 : $display("At time %d There is a parity bit error!", $time);
            3'b010 : $display("At time %d There is a start bit error!", $time);
            3'b011 : $display("At time %d There is a parity bit and start bit errors!", $time);
            3'b100 : $display("At time %d There is a stop bit error!", $time);
            3'b101 : $display("At time %d There is a parity bit and stop bit errors!", $time);
            3'b110 : $display("At time %d There is a start bit and stop bit errors!", $time);
            3'b111 : $display("At time %d This is a trash packet!", $time);
            default: $display("At %d   Holy moly! There is no error!", $time);
        endcase
        #50;
    end
end

endmodule