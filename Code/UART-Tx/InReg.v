//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: InReg.v
//  TYPE: module.
//  DATE: 30/8/2022
//  KEYWORDS: Parity, Odd, Even.
//  PURPOSE: An RTL modelling for Simple register 
//  to hold the Data input untill the transimmition is done. 

module InReg(
    input reset_n,             //  Active low reset.
    input done_flag,           //  From the PISO unit, as an enable.
    input [7:0] data_in,       //  The data input.

    output reg [7:0] reg_data  //  The data saved and sent to the other units.
);

always @(negedge reset_n, posedge done_flag)
begin
    if (~reset_n) begin
        reg_data <= {8{1'b1}};
    end
    else
    begin 
        if (done_flag)
        begin
        reg_data <= data_in;
        end
        else
        begin
        reg_data <= reg_data;
        end
    end
end

endmodule