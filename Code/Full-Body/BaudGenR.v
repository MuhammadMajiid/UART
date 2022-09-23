//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: BaudGen.v
//  TYPE: module.
//  DATE: 31/8/2022
//  KEYWORDS: Baud Rate, Clock Generator.
//  PURPOSE: An RTL modelling for a 50MHz-clock gating which generates
//  Rx clock rates corresponding to the transmitter's.

module BaudGen(
    input wire         reset_n,     //  Active low reset.
    input wire         clock,       //  The System's main clock.
    input wire  [1:0]  baud_rate,   //  Baud Rate agreed upon by the Tx and Rx units.

    output reg         baud_clk     //  Clocking output for the other modules.
);

//  Internal declarations
reg [9:0]  final_value;  //  Holds the number of ticks for each BaudRate.
reg [9:0]  clock_ticks;  //  Counts untill it equals final_value, Timer principle.

//  Encoding the different Baud Rates
localparam BAUD24      = 2'b00,
           BAUD48      = 2'b01,
           BAUD96      = 2'b10,
           BAUD192     = 2'b11;

//  BaudRate 4-1 Mux
always @(*) 
begin
    case (baud_rate)
      //  All these ratio ticks are calculated for 50MHz Clock,
      //  The values shall change with the change of the clock frequency.
      BAUD24: final_value  = 10'd651;     //  16 * 2400 BaudRate.
      BAUD48: final_value  = 10'd326;     //  16 * 4800 BaudRate.
      BAUD96: final_value  = 10'd163;     //  16 * 9600 BaudRate.
      BAUD192: final_value = 10'd81;      //  16 * 19200 BaudRate.
      default: final_value = 10'd163;     //  16 * 9600 BaudRate.
    endcase
end

//  Timer logic
always @(negedge reset_n, posedge clock) 
begin
  if(~reset_n) 
  begin
    clock_ticks   <= 10'd0;
    baud_clk      <= 1'b0;
  end
  else 
  begin
    //  Ticks whenever reaches its final value,
    //  Then resets and starts all over again.
    if(clock_ticks == final_value)
    begin
      baud_clk      <= ~baud_clk;
      clock_ticks   <= 10'd0;
    end
    else 
    begin
      clock_ticks   <= clock_ticks + 1'd1;
      baud_clk      <= baud_clk;
    end
  end
end

endmodule