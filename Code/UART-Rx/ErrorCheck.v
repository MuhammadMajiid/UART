//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  This is an RTL design module code unit,
//  resbonsible of checking if the data are transmitted correctly.

module ErrorCheck(
    input ResetN,             //  Active low reset.
    input ParityBit,          //  The parity bit from the frame for comparison.
    input [1:0] ParityType,   //  Parity type agreed upon by the Tx and Rx units.
    input [7:0] RawData,      //  The 8-bits data separated from the data frame.

    output reg ErrorFlag      //  Outputs logic high if there is an error
);

//  Internal
reg ErrorParity;

//  Encoding for the 4 types of the parity
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
        //  No parity, reset to 0 to not meet the condition of the error flag
        //  because in these cases and the reset case 
        //  the parity bit will be recieved as "1"
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
              ErrorParity <= 1'b0;      
              //  No Parity
            end
        endcase
      end
    end 
end

//ErrorFlag Assignment
always @(*) begin
  assign ErrorFlag  = (ErrorParity == ParityBit);
end
endmodule