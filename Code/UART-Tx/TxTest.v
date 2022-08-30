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
reg reset_n;
reg send;
reg clock; 
reg [1:0] parity_type;
reg [1:0] baud_rate;
reg [7:0] data_in; 

//  wires to show the output
wire data_tx;
wire active_flag;
wire done_flag; 

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
    send    = 1'b1
end

//  Testing data
initial
begin
    data_in = 8'b10101010 ;
end

//  Varying the Baud Rate and the Parity Type
integer i;
initial
begin 
    parity_type = 2'b00 ; 
    baud_rate   = 2'b00 ;
    for (i = 0;i < 4 ; i = i + 1)
    begin
        baud_rate = i ; 
        parity_type = i ; 
        #(4560000 / (i + 1)) ; 
    end 
    send    = 1'b0;
    reset_n = 1'b0;
end

endmodule