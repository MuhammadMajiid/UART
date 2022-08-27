//  This module is created by Mohamed Maged.
//  Undergraduate ECE student, Alexandria university.
//  This is an RTL design module code for Rx Baud Generator,
//  to create different baud rates corresponding to the transmitter's.

module BaudGen(
    input ResetN,           //  Active low reset.
    input Clock,            //  The System's main clock.
    input [1:0] BaudRate,   //  Baud Rate agreed upon by the Tx and Rx units.

    output reg BaudOut      //  Clocking output for the other modules.
);

//  Internal declarations
reg [9:0]  FinalValue;  //  Holds the number of ticks for each BaudRate.
reg [9:0]  ClockTicks;  //  Counts untill it equals FinalValue, Timer principle.

//  Encoding the different Baud Rates
localparam Rate_2400      = 2'b00,
           Rate_4800      = 2'b01,
           Rate_9600      = 2'b10,
           Rate_19200     = 2'b11;

//  BaudRate 4-1 Mux
always @(BaudRate) 
begin
    case (BaudRate)
        Rate_2400   : FinalValue = 651;      //  16 * 2400 BaudRate.
        Rate_4800   : FinalValue = 326;      //  16 * 4800 BaudRate.
        Rate_9600   : FinalValue = 163;      //  16 * 9600 BaudRate.
        Rate_19200  : FinalValue = 81;       //  16 * 19200 BaudRate.
        default     : FinalValue = 0;        //  The system's original Clock.
    endcase
end

//  Baud CLocking logic
always @(negedge ResetN, posedge Clock) 
begin
  if(~ResetN) 
  begin
    ClockTicks   <= 0;
    BaudOut      <= 0;
  end
  else 
  begin
    if(ClockTicks == FinalValue)
    begin
      BaudOut      <= ~BaudOut;
      ClockTicks   <= 0;
    end
    else 
    begin
      ClockTicks   <= ClockTicks + 1;
      BaudOut      <= BaudOut;
    end
  end
end
endmodule