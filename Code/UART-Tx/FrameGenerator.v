//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.


module FrameGenerator(
    input   [7:0]   RegIn,
    input   [1:0]   ParityType,
    input   ResetN, ParityOut,
    input   StopBits,                   //If Low use 1 Stop bit, else 2 Stop bits
    input   DataLength,                 //If low use 7 Data bits, else 8 Data bits
    output reg  [10:0]  FrameOut        //Frame: [{(idle 1's if needed), stopbit/s, ParityBit, RegIn[MSB:LSB], Startbit}]
);
//Internal declerations
reg  [8:0]  DataFrame;

//Options for StopBits & DataLength
always @(StopBits, DataLength, RegIn) begin
    case ({DataLength,StopBits})
      2'b10  :           // 8-bits for DataLength, 1-bit for StopBits
        DataFrame   =   {1'b1,RegIn[7:0]};
      2'b01  :          // 7-bits for DataLength, 2-bits for StopBits
        DataFrame   =   {2'b11,RegIn[6:0]};
        default:        // 8-bits for DataLength, 1-bit for StopBits
        DataFrame   =   {1'b1,RegIn[7:0]};       
    endcase
end 

//Frame generating part
always @(negedge ResetN, RegIn, ParityType, DataFrame) begin
    if (~ResetN) begin
      FrameOut    =   {11{1'b1}};            //idle
    end
    else begin
      if (ParityType == 2'b00 || ParityType == 2'b11) begin   //Frame with no parity bit
        FrameOut    =   {1'b1,DataFrame,1'b0};
      end
      else begin                                       //Frame with parity
        if ({DataLength,StopBits} == 2'b10) begin    // 8-bits for DataLength == DataFrame[7:0], 1-bit for StopBits == DataFrame[8]           
            FrameOut    =   {DataFrame[8],ParityOut,DataFrame[7:0],1'b0};
        end
        else if ({DataLength,StopBits} == 2'b01) begin     // 7-bits for DataLength == DataFrame[6:0], 2-bits for StopBits == DataFrame[8:7]
            FrameOut    =   {DataFrame[8:7],ParityOut,DataFrame[6:0],1'b0};  
        end
        else begin    // 8-bits for DataLength == DataFrame[7:0], 1-bit for StopBits == DataFrame[8] 
          FrameOut      =   {DataFrame[8],ParityOut,DataFrame[7:0],1'b0};
        end
      end
    end
end

endmodule