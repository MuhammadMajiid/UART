//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  An RTL design module code for a Serial-In-Parallel-Out shift register,
//  controlled by an FSM to satisfy the UART-Rx protocol.
//  Stores the data recieved at the positive-clock-edge [BaudRate], then
//  pass the data frame to the DeFrame unit.

module SIPO(
    input ResetN,   //  Active low reset.
    input DataTx,   //  Serial Data recieved from the transmitter.
    input BaudOut,  //  The clocking input comes from the sampling unit.

    output reg RecievedFlag,     //  outputs a signal enables the deframe unit. 
    output reg [10:0] DataParl   //  outputs the 11-bit parallel frame.
);
//  Internal
reg [10:0] Shifter;
reg [3:0]  FrameCounter;
reg [3:0]  StopCount;
reg [1:0]  NextState;

//  Encoding the states of the reciever
//  Every State captures the corresponding bit from the frame
localparam IDLE      = 2'b00,
           Center    = 2'b01,
           FrameTime = 2'b10;

//  Shifting data logic part
always @(posedge BaudOut, negedge ResetN) 
begin
    if(~ResetN)
    begin
      Shifter      <= {11{1'b1}};
      StopCount    <= 4'd0;
      FrameCounter <= 4'd0;
      NextState    <= IDLE;
    end
    else 
    begin
      case (NextState)

        //  Idle case waits untill start bit
        IDLE : 
        begin
          Shifter      <= {11{1'b1}};
          StopCount    <= 4'd0;
          FrameCounter <= 4'd0;
          //  waits till sensing the start bit which is low
          if(~DataTx)
          begin
            NextState <= Center;
          end
          else
          begin
            NextState <= IDLE;
          end
        end

        //  shifts the sampling to the center of the recieved bit
        //  due to the protocol, thus the bit is stable.
        Center : 
        begin
          if(StopCount == 4'd7)
          begin
            Shifter   <= {Shifter,DataTx};
            StopCount <= 4'd0;
            NextState <= FrameTime;
          end
          else
          begin
            StopCount <= StopCount + 1;
            NextState <= Center;
          end
        end

        //  shifts the remaining 10-bits of the frame,
        //  then returns to the idle case.
        FrameTime :
        begin
          if(FrameCounter == 4'd10)
          begin
            FrameCounter <= 4'd0;
            NextState    <= IDLE;
          end
          else
          begin
            if(StopCount == 4'd15)
            begin
              Shifter   <= {Shifter,DataTx};
              FrameCounter <= FrameCounter + 1;
              StopCount <= 4'd0; 
              NextState <= FrameTime;
            end
            else 
            begin
              StopCount <= StopCount + 1;
              NextState <= FrameTime;
            end
          end
        end

        default : 
        begin
          NextState <= IDLE;
        end
      endcase
    end
end

//  Output logic
always @(*) 
begin
  //  Output Data
  DataParl <= Shifter;

  //  RecievedFlag assignment
  RecievedFlag <= (FrameCounter == 4'd10);
end

endmodule