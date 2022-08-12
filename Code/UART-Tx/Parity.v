//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  Simple-parity-check unit uses Odd, Even and no parity methods.

module Parity(
    input   [7:0]    DataIn,
    input   ResetN,
    input   [1:0]   ParityType,
    output reg  ParityOut
);

//Parity type
always @(negedge ResetN, ParityType, DataIn) begin
    if(~ResetN)begin
      ParityOut = (^DataIn)? 1'b0 : 1'b1;        //No parity, Parallel Odd Parity
    end
    else begin
      case (ParityType)
      2'b00  : begin                   //No parity, Parallel Odd Parity
        //Parallel Odd parity
        ParityOut = (^DataIn)? 1'b0 : 1'b1;
      end
      2'b01  : begin                   //Odd Parity
        ParityOut = (^DataIn)? 1'b0 : 1'b1;
      end
      2'b10  : begin                   //Even parity
        ParityOut = (^DataIn)? 1'b1 : 1'b0;    
      end
      2'b11  : begin                  //No parity, Parallel Odd Parity
        //Parallel Odd parity
        ParityOut = (^DataIn)? 1'b0 : 1'b1;
      end    
      endcase
    end
end

endmodule