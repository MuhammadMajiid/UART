//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  This module holds the Data input untill the transimmition is done 

module InReg(
    input   DoneFlag, ResetN
    input   [7:0] DataIn,
    output  [7:0] RegIn
);
reg [7:0] Holder;

always @(posedge DoneFlag, negedge ResetN) begin
    if (~ResetN) begin
    Holder <= 8'b0;
    end
    else if (DoneFlag) begin
    Holder <= DataIn;
    end
    else begin
    Holder <= Holder;
    end
end

assign RegIn = Holder;

endmodule