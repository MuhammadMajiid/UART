//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  Frame generating unit, outputs 12-bit frame
//  Data length could be 7 or 8 bits
//  Stop bits could be 1 or 2 bits

module FrameGenerator(
    input   [7:0]   DataIn,
    input   [1:0]   ParityType,
    input   ResetN, ParityOut,
    input   StopBits,                   //If Low use 1 Stop bit, else 2 Stop bits
    input   DataLength,                 //If low use 7 Data bits, else 8 Data bits
    output reg  [10:0]  FrameOut        //Frame: [{(idle 1's if needed), stopbit/s, ParityBit, DataIn[MSB:LSB], Startbit}]
);
//Internal declerations
reg  [1:0]   FrameSel;
reg  [8:0]  DataFrame;


//Options for StopBits & DataLength
always @(StopBits,DataLength) begin
    FrameSel   =    {DataLength,StopBits};
    case (FrameSel)
      2'b10  :           // 8-bits for DataLength, 1-bit for StopBits
        DataFrame   =   {1'b1, DataIn[7:0]};
      2'b01  :          // 7-bits for DataLength, 2-bits for StopBits
        DataFrame   =   {2'b11, DataIn[6:0]};
        default:        // 8-bits for DataLength, 1-bit for StopBits
        DataFrame   =   {1'b1, DataIn[7:0]};       
    endcase
end 

//Frame generating part
always @(negedge ResetN, DataIn) begin
    if (~ResetN)
        FrameOut    =   12'b1;            //idle
    else begin
      if (ParityType = 2'b00 || ParityType = 2'b11)    //Frame with no parity bit
        FrameOut    =   {1'b1, DataFrame, 1'b0};
      else begin                                       //Frame with parity
        if (FrameSel = 2'b10)     // 8-bits for DataLength == DataFrame[7:0], 1-bit for StopBits == DataFrame[8]           
            FrameOut    =   {DataFrame[8] ,ParityOut, DataFrame[7:0], 1'b0};
        else                     // 7-bits for DataLength == DataFrame[6:0], 2-bits for StopBits == DataFrame[8:7]
            FrameOut    =   {DataFrame[8:7] ,ParityOut , DataFrame[6:0], 1'b0};  
      end
    end
end

endmodule