//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  Simple-parity-check unit uses Odd, Even and no parity methods.



module ParityUnit(
    input   [7:0]    DataIn,
    input   Reset,
    input   [1:0]   ParityType,
    output reg  ParityOut
);
reg ParityCheck;

//Parity type
always @(negedge Reset, ParityType, DataIn) begin
    ParityCheck  =   ^DataIn;
    if(~Reset)begin
      ParityType    =   2'b00;        //No parity
    end
    else begin
      case (ParityType)
      2'b00  : ParityOut   =   1'b1;    //No parity
      2'b01  : begin                   //Odd Parity
        if (ParityCheck)
            ParityOut   =   1'b0;
        else 
            ParityOut   =   1'b1;
      end
      2'b10  : begin                   //Even parity
        if (ParityCheck)
            ParityOut   =   1'b1;
        else
            ParityOut   =   1'b0;    
      end
      2'b11  : ParityOut   =   1'b1;     //No parity
      endcase
    end
end

endmodule