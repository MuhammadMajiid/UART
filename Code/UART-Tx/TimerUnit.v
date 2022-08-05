//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  This is an RTL module for a modular timer

module TimerUnit
    #(parameter CountBits = 5)(
    input   ResetN, clk,enable,
    input   [CountBits - 1 : 0] FinalValue,
    output  Tick
);
//Internal declarations
reg [CountBits - 1 : 0] Qnext, Qreg;
wire Done;

//counter logic
always @(negedge ResetN, posedge clk) begin
    if (~ResetN) begin
        Qreg <= 'b0;
    end
    else if (enable) begin
        Qreg <= Qnext;
    end 
    else begin
      Qreg <= Qreg;
    end
end

//Next state logic
assign Done = Qreg == FinalValue;
always @(*) begin
    Qnext <= Done? 'b0 : Qreg + 1;
end

//Output
assign Tick = Qreg;
endmodule