//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: Parity.v
//  TYPE: module.
//  DATE: 30/8/2022
//  KEYWORDS: Parity, Odd, Even.
//  PURPOSE: An RTL modelling for Simple-parity-check unit 
//  uses Odd, Even and no parity methods.

module Parity(
  input wire         reset_n,     //  Active low reset.
  input wire  [7:0]  data_in,     //  The data input from the InReg unit.
  input wire  [1:0]  parity_type, //  Parity type agreed upon by the Tx and Rx units.

  output reg         parity_bit   //  The parity bit output for the frame.
);

//  Encoding for the parity types
localparam ODD        = 2'b01,
           Even       = 2'b10;

always @(*)
begin
  if (!reset_n) parity_bit = 1'b1;
  else
  begin
    case (parity_type)
    ODD:     parity_bit = (^data_in)? 1'b0 : 1'b1;
    Even:    parity_bit = (^data_in)? 1'b1 : 1'b0; 
    default: parity_bit = 1'b1;
    endcase
  end
end
endmodule