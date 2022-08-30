//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: ErrorCheck.v
//  TYPE: module.
//  DATE: 31/8/2022
//  KEYWORDS: Parity, Error.
//  PURPOSE: An RTL modelling for checking if the data are transmitted correctly,
//  checks the whole package including the start and stop bits.

module ErrorCheck(
    input reset_n,             //  Active low reset.
    input parity_bit,          //  The parity bit from the frame for comparison.
    input start_bit,           //  The Start bit from the frame for comparison.
    input stop_bit,            //  The Stop bit from the frame for comparison.
    input [1:0] parity_type,   //  Parity type agreed upon by the Tx and Rx units.
    input [7:0] raw_data,      //  The 8-bits data separated from the data frame.

    //  bus of three bits, each bit is a flag for an error
    //  error_flag[0] ParityError flag, error_flag[1] StartError flag,
    //  error_flag[2] StopError flag.
    output reg [2:0] error_flag
);

//  Internal
reg error_parity;

//  Encoding for the 4 types of the parity
localparam ODD       = 2'b01,
           EVEN      = 2'b10,
           NOPARITY  = 2'b00, 2'b11;

//  Parity Check logic
always @(negedge reset_n, raw_data, parity_bit, parity_type)
begin
    if(~reset_n)
    begin
        error_flag   <= {3{1'b0}};
        error_parity <= 1'b1;
    end
    else
    begin
      if ((parity_type == NoParity1) || (parity_type == Noparity2))
      begin
        error_parity <= 1'b1;
        //  No parity, reset to 0 to not meet the condition of the error flag
        //  because in these cases and the reset case 
        //  the parity bit will be recieved as "1"
      end
      else
      begin
        case (parity_type)
           NOPARITY:
           begin
            error_parity <= 1'b0;      
            //  No Parity
           end
           ODD: 
           begin
             error_parity <= (^raw_data)? 1'b0 : 1'b1;
           end

           EVEN: 
           begin
             error_parity <= (^raw_data)? 1'b1 : 1'b0;
           end

            default: 
            begin
              error_parity <= 1'b0;      
              //  No Parity
            end
        endcase
      end
    end 
end

//  Output logic
always @(*) 
begin
  error_flag[0] <= (error_parity != parity_bit);
  error_flag[1] <= (start_bit != 1'b0);
  error_flag[2] <= (stop_bit != 1'b1);
end

endmodule