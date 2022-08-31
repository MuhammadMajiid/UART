//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: SIPO.v
//  TYPE: module.
//  DATE: 31/8/2022
//  KEYWORDS: SIPO, Shift register, Reciever.
//  PURPOSE: An RTL modelling for a Serial-In-Parallel-Out shift register,
//  controlled by an FSM to satisfy the UART-Rx protocol.
//  Stores the data recieved at the positive-clock-edges [BaudRate], then
//  pass the data frame to the DeFrame unit. 

module SIPO(
    input reset_n,   //  Active low reset.
    input data_tx,   //  Serial Data recieved from the transmitter.
    input baud_clk,  //  The clocking input comes from the sampling unit.

    output reg active_flag,        //  outputs logic 1 when data is in progress.
    output reg recieved_flag,      //  outputs a signal enables the deframe unit. 
    output reg [10:0] data_parll   //  outputs the 11-bit parallel frame.
);
//  Internal
reg [3:0]  frame_counter;
reg [3:0]  stop_count;
reg [1:0]  next_state;

//  Encoding the states of the reciever
//  Every State captures the corresponding bit from the frame
localparam IDLE   = 2'b00,
           CENTER = 2'b01,
           FRAME  = 2'b10,
           HOLD   = 2'b11;

//  Asynchronous Reset logic
always @(negedge reset_n) 
begin
    if(~reset_n)
    begin
      data_parll    <= {11{1'b1}};
      stop_count    <= 4'd0;
      frame_counter <= 4'd0;
      active_flag   <= 1'b0;
      recieved_flag <= 1'b0;
      next_state    <= IDLE;
    end
    else 
    begin
      data_parll    <= data_parll;
      stop_count    <= stop_count;
      frame_counter <= frame_counter;
      active_flag   <= active_flag;
      recieved_flag <= recieved_flag;
      next_state    <= next_state;
    end
end

//  FSM logic
always @(posedge baud_clk) begin
  case (next_state)
      //  Idle case waits untill start bit
      IDLE : 
      begin
        data_parll    <= {11{1'b1}};
        stop_count    <= 4'd0;
        frame_counter <= 4'd0;
        recieved_flag <= 1'b0;
        //  waits till sensing the start bit which is low
        if(~data_tx)
        begin
          next_state  <= CENTER;
          active_flag <= 1'b1;
        end
        else
        begin
          next_state  <= IDLE;
          active_flag <= 1'b0;
        end
      end

      //  shifts the sampling to the Center of the recieved bit
      //  due to the protocol, thus the bit is stable.
      CENTER : 
      begin
        if(&stop_count[2:0])
        //  This is an equivalent condition to (stop_count == 7)
        //  in order to avoid comparators/xors
        begin
          data_parll  <= {data_parll,data_tx};
          stop_count  <= 4'd0;
          next_state  <= FRAME;
        end
        else
        begin
          stop_count <= stop_count + 1;
          next_state <= CENTER;
        end
      end

      //  shifts the remaining 10-bits of the frame,
      //  then returns to the idle case.
      FRAME :
      begin
        if(frame_counter[1] && frame_counter[3])
        //  This is an equivalent condition to (frame_counter == 4'd10)
        //  in order to avoid comparators/xors
        begin
          frame_counter <= 4'd0;
          recieved_flag <= 1'b1;
          next_state    <= HOLD;
        end
        else
        begin
          if(&stop_count[3:0])
          //  This is an equivalent condition to (stop_count == 4'd15)
          //  in order to avoid comparators/xors
          begin
            data_parll    <= {data_parll,data_tx};
            frame_counter <= frame_counter + 1;
            stop_count    <= 4'd0; 
            next_state    <= FRAME;
          end
          else 
          begin
            stop_count <= stop_count + 1;
            next_state <= FRAME;
          end
        end
      end

      //  Holds the data recieved for a 16 baud cycles
      HOLD :
      begin
        recieved_flag <= 1'b1;
        if(&stop_count[3:0])
          //  This is an equivalent condition to (stop_count == 4'd15)
          //  in order to avoid comparators/xors
          begin
            data_parll    <= data_parll;
            frame_counter <= 4'd0;
            stop_count    <= 4'd0; 
            next_state    <= IDLE;
          end
          else 
          begin
            stop_count <= stop_count + 1;
            next_state <= HOLD;
          end
      end

      //  Automatically directs to the IDLE state
      default : 
      begin
        next_state <= IDLE;
      end
    endcase
end

endmodule