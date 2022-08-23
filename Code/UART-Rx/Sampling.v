//  This module is created by Mohamed Maged.
//  Undergraduate ECE student, Alexandria university.
//  This is an RTL design module code uses FSM methodology
//  to create different baud rates corresponding to the transmitter's.

module Sampling(
    input ResetN,           //  Active low reset.
    input Clock,            //  The System's main clock.
    input DataTx,           //  For sensing the Start bit.
    input [1:0] BaudRate,   //  Baud Rate agreed upon by the Tx and Rx units.

    output reg BaudOut      //Clocking output for the other modules.
);

//  Internal declarations
reg [10:0] ClockTicks, FinalValue;
reg [3:0]  FrameCounter;
reg [2:0]  StopCount;
reg [1:0]  NextState;


//  Encoding the states of the reciever
//  Every State captures the corresponding bit from the frame
localparam IDLE      = 2'b00,
           Center    = 2'b01,
           FrameTime = 2'b10;
          
//  Encoding the differemt Baud Rates
localparam Rate2400      = 2'b00,
           Rate4800      = 2'b01,
           Rate9600      = 2'b10,
           Rate19200     = 2'b11;

//  BaudRate 4-1 Mux
always @(BaudRate) begin
    case (BaudRate)
        Rate2400   : FinalValue = 1302;      //8 * 2400 BaudRate.
        Rate4800   : FinalValue = 651;       //8 * 4800 BaudRate.
        Rate9600   : FinalValue = 326;       //8 * 9600 BaudRate.
        Rate19200  : FinalValue = 163;       //8 * 19200 BaudRate.
        default    : FinalValue = 0;         //The systems original Clock.
    endcase
end

//  States logic Part
always @(negedge ResetN, posedge Clock) begin
    if(~ResetN) begin
        ClockTicks   <= 0; 
        BaudOut      <= 0;
        StopCount    <= 0;
        FrameCounter <= 0;
        NextState    <= IDLE;
    end
    else begin
      case (NextState)

//  The Idle state keeps the outputing the 16*BaudRate clock
//  untill sensing the start bit
        IDLE : begin
          FrameCounter <= 0;
          if(ClockTicks == FinalValue) begin
            StopCount  <= StopCount + 1;
            ClockTicks <= 0;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin      
            //  Condition equivalent to StopCount == 3'd4 == 3'b0(1)00
            //  For simplicity of the hardware instead of comparator
            BaudOut   <= ~BaudOut;
            StopCount <= 3'd0;
            if(~DataTx) begin
              NextState <= Center;
            end
            else begin
              NextState <= IDLE;
            end
          end
          else begin
            NextState <= IDLE;
          end
        end

//  The Center state captures the start bit in its half duration 8*Baudrate clock
//  thus centring the baudout signal
        Center : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
            ClockTicks <= 0;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[1] && (~StopCount[0])) begin     
            //  Condition equivalent to StopCount == 3'd2 ==3'b0(10)
            //  For simplicity of the hardware instead of comparator
            BaudOut   <= ~BaudOut;
            NextState <= FrameTime;
            StopCount <= 4'd0;
          end
          else begin
            NextState <= Center;
          end
        end

//  The FrameTime state repeats itself 10 times
//  to capture the remaining 10 bits of the data frame
//  outputing 16*BaudRate clock
        FrameTime : begin
          if(ClockTicks == FinalValue) begin
            StopCount  <= StopCount + 1;
            ClockTicks <= 0;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin
            BaudOut      <= ~BaudOut;
            FrameCounter <= FrameCounter + 1;
            StopCount    <= 4'd0;
            if(FrameCounter[3] && (FrameCounter[1])) begin        
              //  Condition equivalent to FrameCounter == 4'd10 == 4'b(1)0(1)0
              //  For simplicity of the hardware instead of comparator
              NextState <= IDLE;
            end
            else begin
              NextState <= FrameTime;
            end
          end
          else begin
            NextState <= FrameTime;
          end
        end

        default : begin
          NextState <= IDLE;
        end

    endcase
    end
end
endmodule