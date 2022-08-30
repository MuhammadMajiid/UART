//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: DeFrame.v
//  TYPE: module.
//  DATE: 31/8/2022
//  KEYWORDS: Frame, Data.
//  PURPOSE: An RTL modelling for separating the frame
//  into Data bits, Parity bit, Start and Stop bits.

module DeFrame(
    input reset_n,             //  Active low reset.
    input recieved_flag,       //  Output from the sipo unit as an enable.
    input [10:0] data_parll,   //  Data frame passed from the sipo unit.

    output reg parity_bit,     //  The parity bit separated from the data frame.
    output reg start_bit,      //  The Start bit separated from the data frame.
    output reg stop_bit,       //  The Stop bit separated from the data frame.
    output reg [7:0] raw_data  //  The 8-bits data separated from the data frame.
);

//  -Deframing- Output Data & parity bit logic
always @(negedge reset_n, data_parll)
begin
    if(~reset_n)
    begin
      raw_data   <= {8{1'b1}};
      parity_bit <= 1'b1;
      start_bit  <= 1'b0;
      stop_bit   <= 1'b1;
    end
    else 
    begin
      if(recieved_flag)
      begin
        raw_data   <= data_parll[9:2];
        parity_bit <= data_parll[1];
        start_bit  <= data_parll[10];
        stop_bit   <= data_parll[0];
      end
      else
      begin
        raw_data   <= raw_data;
        parity_bit <= parity_bit;
        start_bit  <= start_bit;
        stop_bit   <= stop_bit;
      end
    end
end

endmodule