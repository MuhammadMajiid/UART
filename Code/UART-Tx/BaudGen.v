//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  This is an RTL module for a Baud rate generator

module BaudGen
    #(parameter integer CountBits = 'd14)(
    input   ResetN, Clock,Enable,
    input   [1:0]  BaudRate,
    output reg Tick
);
//Internal declarations
reg [CountBits - 1 : 0] Qnext, Qreg = 'b0, FinalValue;
wire Done;

//BaudRate 4-1 Mux
always @(BaudRate) begin
    case (BaudRate)
        2'b00 : FinalValue <= 'd10417 ;      //2400 BaudRate.
        2'b01 : FinalValue <= 'd5208 ;       //4800 BaudRate.
        2'b10 : FinalValue <= 'd2604 ;       //9600 BaudRate.
        2'b11 : FinalValue <= 'd1302 ;       //19200 BaudRate.
        default: FinalValue <= 0 ;           //The systems original Clock
    endcase
end

//counter logic
always @(negedge ResetN, posedge Clock) begin
    if (~ResetN) begin
        Qreg <= 'b0;
    end
    else if (Enable) begin
        Qreg <= Qnext;
    end 
    else begin
        Qreg <= Qreg;
    end
end

//Next state logic
assign Done = (Qreg == FinalValue) ;
always @(*) begin
    Qnext <= Done? 'b0 : Qreg + 1;
    Tick = Done? 1'b1 : 1'b0;
end



endmodule