//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  Simple-parity-check unit uses Odd, Even and no parity methods.

module Parity(
    input   [7:0]    RegOut,
    input            ResetN,
    input   [1:0]    ParityType,
    output reg       ParityOut
);

//Parity type
always @(negedge ResetN, ParityType, RegOut) begin
    if(~ResetN)begin
      ParityOut <= (^RegOut)? 1'b0 : 1'b1;        //No parity bit, Parallel Odd Parity
    end
    else begin
      case (ParityType)
      2'b00  : begin                   //No parity bit, Parallel Odd Parity
        ParityOut <= (^RegOut)? 1'b0 : 1'b1;
      end
      2'b01  : begin                   //Odd Parity
        ParityOut <= (^RegOut)? 1'b0 : 1'b1;
      end
      2'b10  : begin                   //Even parity
        ParityOut <= (^RegOut)? 1'b1 : 1'b0;    
      end
      2'b11  : begin                  //No parity bit, Parallel Odd Parity
        ParityOut <= (^RegOut)? 1'b0 : 1'b1;
      end    
      endcase
    end
end

endmodule