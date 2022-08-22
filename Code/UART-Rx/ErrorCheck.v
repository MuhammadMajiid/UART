//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  This unit is resbonsible of checking if the data are transmitted correctly.

module ErrorCheck(
    input ParityBit, ResetN,
    input [1:0] ParityType,
    input [7:0] RawData,

    output ErrorFlag
);
//Internal
reg ErrorParity;
localparam Odd       = 2'b01,
           Even      = 2'b10,
           NoParity1 = 2'b00, 
           Noparity2 =2'b11;

always @(negedge ResetN, RawData, ParityBit, ParityType) begin
    if(~ResetN) begin
        ErrorFlag   <= 1'b0;
        ErrorParity <= 1'b0;
    end
    else begin
      if ((ParityType == NoParity1) || (ParityType == Noparity2)) begin
        ErrorParity <= 1'b1;
      end
      else begin
        case (ParityType)
           Odd : begin
             ErrorParity <= (^RawData)? 1'b0 : 1'b1;
           end
           Even : begin
             ErrorParity <= (^RawData)? 1'b1 : 1'b0;
           end
            default: begin
              ErrorParity <= 1'b1;      //NoParity
            end
        endcase
      end
    end
    
end

//ErrorFlag Assignment
assign ErrorFlag    = (ErrorParity == ParityBit);
endmodule