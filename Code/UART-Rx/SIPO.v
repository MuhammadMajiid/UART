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
    input  wire         reset_n,        //  Active low reset.
    input  wire         data_tx,        //  Serial Data recieved from the transmitter.
    input  wire         baud_clk,       //  The clocking input comes from the sampling unit.

    output wire         active_flag,    //  outputs logic 1 when data is in progress.
    output wire         recieved_flag,  //  outputs a signal enables the deframe unit. 
    output reg  [10:0]  data_parll      //  outputs the 11-bit parallel frame.
);
//  Internal
reg [10:0] temp;
reg [3:0]  frame_counter;
reg [3:0]  stop_count;
reg [1:0]  next_state;

//  Encoding the states of the reciever
localparam IDLE   = 2'b00,
           CENTER = 2'b01,
           FRAME  = 2'b11,
           GET    = 2'b10;

//  Recieving logic FSM
always @(posedge baud_clk, negedge reset_n) begin
  if (!reset_n) begin
    next_state    <= IDLE;
    stop_count    <= 4'd0;
    frame_counter <= 4'd0;
    temp          <= {11{1'b1}};
  end
  else begin
    case (next_state)
      IDLE : 
      begin
        temp          <= {11{1'b1}};
        stop_count    <= 4'd0;
        frame_counter <= 4'd0;
        if(~data_tx) begin
          next_state  <= CENTER;
        end
        else begin
          next_state  <= IDLE;
        end
      end

      CENTER : 
      begin
        if(stop_count == 4'd6) begin
          stop_count     <= 4'd0;
          next_state     <= GET;
        end
        else begin
          stop_count  <= stop_count + 4'b1;
          next_state  <= CENTER;
        end
      end

      FRAME :
      begin
        temp <= data_parll;
        if(frame_counter == 4'd10) begin
          frame_counter <= 4'd0;
          next_state    <= IDLE;
        end
        else begin
          if(stop_count == 4'd14) begin
            frame_counter  <= frame_counter + 4'b1;
            stop_count     <= 4'd0; 
            next_state     <= GET;
          end
          else begin
            frame_counter  <= frame_counter;
            stop_count     <= stop_count + 4'b1;
            next_state     <= FRAME;
          end
        end
      end

      GET : begin 
        next_state     <= FRAME;
        temp           <= data_parll;
      end
    endcase
  end
end

always @(*) begin
  case (next_state)
    IDLE, CENTER, FRAME: data_parll  = temp;

    GET : begin
      data_parll    = temp << 1;
      data_parll[0] = data_tx;
    end
  endcase
end

assign recieved_flag = (frame_counter == 4'd10);
assign active_flag   = !recieved_flag;

endmodule