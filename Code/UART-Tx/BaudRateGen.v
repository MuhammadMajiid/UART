//  This module is created by Mohamed Maged And Ali Morgan
//  Undergraduate ECE student, Alexandria university.
//  Behavioral modelling for the Baud rate generator

module BaudRateGen
    #(parameter Width = 14;)(
    input Clk, ResetN,
    input [1:0] BaudRate,

    output BaudOut
);

reg [Width - 1 : 0] Counter ; 
reg [Width - 1 : 0] FinalValue ; 

//Counter Part
always @(negedge ResetN, posedge Clock) begin
    if(~ResetN) begin
        Counter = 0 ; 
        BaudOut = 0 ; 
    end 
    
    else begin
        if (Counter == FinalValue) begin
        Counter = 0 ; 
        BaudOut = ~BaudOut ; 
        end 
        else begin
        Counter = Counter + 'd1 ;
        end
    end 
    
end

//BaudRate 4-1 Mux
always @(BaudRate) begin
    case (BaudRate)
        2'b00 : FinalValue = 'd10417 ;      //2400 BaudRate.
        2'b01 : FinalValue = 'd5208 ;       //4800 BaudRate.
        2'b10 : FinalValue = 'd2604 ;       //9600 BaudRate.
        2'b11 : FinalValue = 'd1302 ;       //19200 BaudRate.
        default: FinalValue = 0 ;           //The systems original Clock
    endcase
end

endmodule