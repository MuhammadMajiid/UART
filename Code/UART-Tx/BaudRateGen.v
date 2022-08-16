//  This module is created by Mohamed Maged And Ali Morgan
//  Undergraduate ECE student, Alexandria university.


module BaudRateGen(
    input ResetN, Clock,
    input [1:0] BaudRate,

    output reg BaudOut
);
//Internal declarations
reg [13 : 0] ClockTicks, FinalValue; 

//BaudRate 4-1 Mux
always @(BaudRate) begin
    case (BaudRate)
        2'b00 : FinalValue = 10417;      //2400 BaudRate.
        2'b01 : FinalValue = 5208;       //4800 BaudRate.
        2'b10 : FinalValue = 2604;       //9600 BaudRate.
        2'b11 : FinalValue = 1302;       //19200 BaudRate.
        default: FinalValue = 0;           //The systems original Clock
    endcase
end

//Counter Part
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