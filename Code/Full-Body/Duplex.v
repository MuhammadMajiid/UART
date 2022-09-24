//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: Duplex.v
//  TYPE: module.
//  DATE: 23/9/2022
//  KEYWORDS: UART, Full duplex.
//  PURPOSE: An RTL modelling for the Top module for the duplex UART body.
//  Architecture designed by Mohamed Maged,
//  according to the UART protocol.
//  Full Architecture will be provided in the README file.

module Duplex (
    input   wire         reset_n,       //  Active low reset.
    input   wire         send,          //  An enable to start sending data.
    input   wire         clock,         //  The main system's clock.
    input   wire  [1:0]  parity_type,   //  Parity type agreed upon by the Tx and Rx units.
    input   wire  [1:0]  baud_rate,     //  Baud Rate agreed upon by the Tx and Rx units.
    input   wire  [7:0]  data_in,       //  The data input.

    output  wire         tx_active_flag, //  outputs logic 1 when data is in progress.
    output  wire         tx_done_flag,   //  Outputs logic 1 when data is transmitted
    output  wire         rx_active_flag, //  outputs logic 1 when data is in progress.
    output  wire         rx_done_flag,   //  Outputs logic 1 when data is recieved
    output  wire  [7:0]  data_out,       //  The 8-bits data separated from the frame.
    output  wire  [2:0]  error_flag
    //  Consits of three bits, each bit is a flag for an error
    //  error_flag[0] ParityError flag, error_flag[1] StartError flag,
    //  error_flag[2] StopError flag.
);

//  wires for interconnection
wire        data_tx_w;        //  Serial transmitter's data out.

//  Transmitter unit instance
TxUnit Transmitter(
    //  Inputs
    .reset_n(reset_n),
    .send(send),
    .clock(clock),
    .parity_type(parity_type),
    .baud_rate(baud_rate),
    .data_in(data_in),

    //  Outputs
    .data_tx(data_tx_w),
    .active_flag(tx_active_flag),
    .done_flag(tx_done_flag)
);

//  Reciever unit instance
RxUnit Reciever(
    //  Inputs
    .reset_n(reset_n),
    .clock(clock),
    .parity_type(parity_type),
    .baud_rate(baud_rate),
    .data_tx(data_tx_w),

    //  Outputs
    .data_out(data_out),
    .error_flag(error_flag),
    .active_flag(rx_active_flag),
    .done_flag(rx_done_flag)
);

endmodule