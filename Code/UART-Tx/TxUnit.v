//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: TxUnit.v
//  TYPE: module.
//  DATE: 30/8/2022
//  KEYWORDS: Tx, Data-Tx, Transmitter, UART-Tx.
//  PURPOSE: An RTL modelling for the UART-Tx.

module TxUnit(
    input reset_n,             //  Active low reset.
    input send,                //  An enable to start sending data.
    input clock,               //  The main system's clock.
    input [1:0] parity_type,   //  Parity type agreed upon by the Tx and Rx units.
    input [1:0] baud_rate,     //  Baud Rate agreed upon by the Tx and Rx units.
    input [7:0] data_in,       //  The data input.

    output data_tx,            //  Serial transmitter's data out.
    output active_flag,        //  high when Tx is transmitting, low when idle.
    output done_flag           //  high when transmission is done, low when active.
);

//  Interconnections
wire parity_bit_w;
wire baud_clk_w;

//Parity unit instantiation 
Parity Unit2(
    //  Inputs
    .reset_n(reset_n),
    .data_in(data_in),
    .parity_type(parity_type),
    
    //  Output
    .parity_bit(parity_bit_w)
);

//  Baud generator unit instantiation
BaudGen Unit3(
    //  Inputs
    .reset_n(reset_n),
    .clock(clock),
    .baud_rate(baud_rate),
    
    //  Output
    .baud_clk(baud_clk_w)
);

//  PISO shift register unit instantiation
PISO Unit4(
    //  Inputs
    .reset_n(reset_n),
    .send(send),
    .baud_clk(baud_clk_w),
    .data_in(data_in),
    .parity_type(parity_type),
    .parity_bit(parity_bit_w),

    //  Outputs
    .data_tx(data_tx),
    .active_flag(active_flag),
    .done_flag(done_flag)
);

endmodule