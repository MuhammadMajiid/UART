

module Dummy(
    input ResetN,
    input Clock,
    input DataTx,
    input [1:0] BaudRate,

    output reg BaudOut
);

//  Internal declarations
reg [10:0] ClockTicks, FinalValue;
reg [2:0]  StopCount;
reg [3:0]  NextState;

//  Encoding the states of the reciever
//  Every State captures the corresponding bit from the frame
localparam IDLE      = 4'b0000,
           StartBit  = 4'b0001,
           Data1     = 4'b0010,
           Data2     = 4'b0011,
           Data3     = 4'b0100,
           Data4     = 4'b0101,
           Data5     = 4'b0110,
           Data6     = 4'b0111,
           Data7     = 4'b1000,
           ParityBit = 4'b1001,
           StopBit   = 4'b1010;
          
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
        ClockTicks <= 0; 
        BaudOut    <= 0;
        StopCount  <= 0;
        NextState  <= IDLE;
    end
    else begin
      case (NextState)

        IDLE : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin      //  Condition equivalent to StopCount == 3'd4
            BaudOut   <= ~BaudOut;
            StopCount <= 3'd0;
            if(~DataTx) begin
              NextState <= StartBit;
            end
            else begin
              NextState <= IDLE;
            end
          end
          else begin
              NextState <= IDLE;
          end
        end

        StartBit : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[1] && (~StopCount[0])) begin     //  Condition equivalent to StopCount == 3'd2
            BaudOut   <= ~BaudOut;
            NextState <= Data1;
            StopCount <= 4'd0;
          end
          else begin
            NextState <= StartBit;
          end
        end

        Data1 : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin
            BaudOut   <= ~BaudOut;
            NextState <= Data2;
            StopCount <= 4'd0;
          end
          else begin
            NextState <= Data1;
          end 
        end

        Data2 : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin
            BaudOut   <= ~BaudOut;
            NextState <= Data3;
            StopCount <= 4'd0;
          end
          else begin
            NextState <= Data2;
          end 
        end

        Data3 : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin
            BaudOut   <= ~BaudOut;
            NextState <= Data4;
            StopCount <= 4'd0;
          end
          else begin
            NextState <= Data3;
          end
        end

        Data4 : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin
            BaudOut   <= ~BaudOut;
            NextState <= Data5;
            StopCount <= 4'd0;
          end
          else begin
            NextState <= Data4;
          end
        end

        Data5 : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin
            BaudOut   <= ~BaudOut;
            NextState <= Data6;
            StopCount <= 4'd0;
          end
          else begin
            NextState <= Data5;
          end
        end

        Data6 : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin
            BaudOut   <= ~BaudOut;
            NextState <= Data7;
            StopCount <= 4'd0;
          end
          else begin
            NextState <= Data6;
          end
        end

        Data7 : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin
            BaudOut   <= ~BaudOut;
            NextState <= ParityBit;
            StopCount <= 4'd0;
          end
          else begin
            NextState <= Data7;
          end
        end

        ParityBit : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin
            BaudOut   <= ~BaudOut;
            NextState <= StopBit;
            StopCount <= 4'd0;
          end
          else begin
            NextState <= ParityBit;
          end
        end

        StopBit : begin
          if(ClockTicks == FinalValue) begin
            StopCount <= StopCount + 1;
          end
          else begin
            ClockTicks <= ClockTicks +1;
          end
          if(StopCount[2]) begin
            BaudOut   <= ~BaudOut;
            NextState <= IDLE;
            StopCount <= 4'd0;
          end
          else begin
            NextState <= StopBit;
          end
        end

        default: begin
          NextState <= IDLE;
        end
      endcase
    end
end
endmodule