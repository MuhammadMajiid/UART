//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.


module Sampling(
    input ResetN, Clock, OverSel,       //OverSel = 0 8*BaudRate, OverSel = 1 16*BaudRate
    input [1:0] BaudRate,

    output reg BaudOut
);
//Internal declarations
reg [17:0] ClockTicks, FinalValue;

//BaudRate 4-1 Mux
always @({OverSel,BaudRate}) begin
    case (BaudRate)
        3'b000 : FinalValue = 83334;       //8 * 2400 BaudRate.
        3'b001 : FinalValue = 41667;       //8 * 4800 BaudRate.
        3'b010 : FinalValue = 20834;       //8 * 9600 BaudRate.
        3'b011 : FinalValue = 10417;       //8 * 19200 BaudRate.
        3'b100 : FinalValue = 166667;      //16 * 2400 BaudRate.
        3'b101 : FinalValue = 83334;       //16 * 4800 BaudRate.
        3'b110 : FinalValue = 41667;       //16 * 9600 BaudRate.
        3'b111 : FinalValue = 20834;       //16 * 19200 BaudRate.
        default: FinalValue = 0;           //The systems original Clock
    endcase
end

//Baud Out Part
always @(negedge ResetN, posedge Clock) begin
    if(~ResetN) begin
        ClockTicks <= 0; 
        BaudOut    <= 0; 
    end
    else begin
        if (ClockTicks == FinalValue) begin
            ClockTicks <= 0; 
            BaudOut    <= ~BaudOut; 
        end 
        else begin
            ClockTicks <= ClockTicks + 1;
            BaudOut    <= BaudOut;
        end
    end 
end
endmodule