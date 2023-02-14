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
    input wire          reset_n,        //  Active low reset.
    input wire          recieved_flag,  //  enable indicates when data is in progress.
    input wire  [10:0]  data_parll,     //  Data frame passed from the sipo unit.

    output reg          parity_bit,     //  The parity bit separated from the data frame.
    output reg          start_bit,      //  The Start bit separated from the data frame.
    output reg          stop_bit,       //  The Stop bit separated from the data frame.
    output reg          done_flag,      //  Indicates that the data is recieved and ready for another data packet.
    output reg  [7:0]   raw_data        //  The 8-bits data separated from the data frame.
);

//  Deframing 
always @(*) 
begin
  if (!reset_n || !recieved_flag) 
  begin
    raw_data[7:0]     = {8{1'b1}};
    parity_bit        = 1'b1;
    start_bit         = 1'b0;
    stop_bit          = 1'b1;
    done_flag         = 1'b0;
  end
  else begin
      start_bit       = data_parll[10];
      raw_data[7:4]   = {data_parll[2],data_parll[3],data_parll[4],data_parll[5]};
      raw_data[3:0]   = {data_parll[6],data_parll[7],data_parll[8],data_parll[9]};
      parity_bit      = data_parll[1];
      stop_bit        = data_parll[0];
      done_flag       = 1'b1;
  end
end

endmodule