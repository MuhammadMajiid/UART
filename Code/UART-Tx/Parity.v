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
  input reset_n,            //  Active low reset.
  input [7:0] reg_data,     //  The data input from the InReg unit.
  input [1:0] parity_type,  //  Parity type agreed upon by the Tx and Rx units.

  output reg  parity_bit    //  The parity bit output for the frame.
);

//  Encoding for the parity types
localparam NOPARITY = 2'b00, 2'b11,
           ODD      = 2'b01,
           Even     = 2'b10;

//  Parity type
always @(negedge ResetN, parity_type, reg_data)
begin
    if(~reset_n)
    begin
      //  No parity bit
      ParityOut <= (^reg_data)? 1'b0 : 1'b1;
    end
    else
    begin
      case (parity_type)
      NOPARITY:
      begin
        //  No parity bit
        parity_bit <= (^reg_data)? 1'b0 : 1'b1;
      end
      ODD:
      begin
        //  Odd Parity
        parity_bit <= (^reg_data)? 1'b0 : 1'b1;
      end
      Even: 
      begin
        //  Even parity
        parity_bit <= (^reg_data)? 1'b1 : 1'b0;    
      end
      default:
      begin
        //  No parity
        parity_bit <= (^reg_data)? 1'b0 : 1'b1;
      end  
      endcase
    end
end

endmodule