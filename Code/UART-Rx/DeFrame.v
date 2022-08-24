//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  This is an RTL design module code resbosible for separating the frame
//  into Data bits and Parity bit and truncates Start and Stop bits.

module DeFrame(
    input ResetN,             //  Active low reset.
    input RecievedFlag,       //  Output from the sipo unit as an enable.
    input [10:0] DataParl,    //  Data frame passed from the sipo unit.

    output reg ParityBit,     //  The parity bit separated from the data frame.
    output reg StartBit,      //  The Start bit separated from the data frame.
    output reg StopBit,       //  The Stop bit separated from the data frame.
    output reg [7:0] RawData  //  The 8-bits data separated from the data frame.
);

//  -Deframing- Output Data & parity bit logic
always @(negedge ResetN, DataParl) begin
    if(~ResetN)begin
      RawData   <= 8'b1;
      ParityBit <= 1'b1;
      StartBit  <= 1'b0;
      StopBit   <= 1'b1;
    end
    else if(RecievedFlag) begin
      RawData   <= DataParl[8:1];
      ParityBit <= DataParl[9];
      StartBit  <= DataParl[0];
      StopBit   <= DataParl[10];
      //  Truncates the Start and Stop bits
    end
    else begin
      RawData   <= RawData;
      ParityBit <= ParityBit;
      StartBit  <= StartBit;
      StopBit   <= StopBit;
    end
end
endmodule