//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: PISO.v
//  TYPE: module.
//  DATE: 30/8/2022
//  KEYWORDS: Frame, Data-Tx, PISO, shift register.
//  PURPOSE: An RTL modelling for the transmitter's frame generator,
//  and shift register to send data serially.

module PISO(
    input reset_n,            //  Active low reset.
    input send,               //  An enable to start sending data.
    input baud_clk,           //  Clocking signal from the BaudGen unit.
    input parity_bit,         //  The parity bit from the Parity unit.
    input [1:0] parity_type,  //  Parity type agreed upon by the Tx and Rx units.
    input [7:0] reg_data,     //  The data input from the InReg unit.
  
    output reg 	data_tx, 	  //  Serial transmitter's data out
	output reg 	active_flag,  //  high when Tx is transmitting, low when idle.
	output reg 	done_flag 	  //  high when transmission is done, low when active.
);

//  Internal declarations
reg [3:0]   serial_pos;
//  an index for the bit of the frame which its turn to get transmitted.
reg [10:0]  frame;
//  Frame: [{idle 1 if needed, stopbit, ParityBit, RegOut[MSB:LSB], Startbit}]

//  Frame generating part
always @(negedge reset_n, parity_type, reg_data)
begin
    if (~reset_n)
    begin
      //  idle
      frame  <= {11{1'b1}};
    end
    else begin
      if (parity_type == 2'b00 || parity_type == 2'b11)
      begin
        //  Frame with no parity bit
        frame  <= {2'b11,reg_data,1'b0};
      end
      else
      begin
        //  Frame with parity bit
        frame  <= {1'b1,parity_bit,reg_data,1'b0};
      end
    end
end

//  This part handles the outputs
always @(negedge reset_n, posedge baud_clk)
begin    
    if (~reset_n)
    begin
        data_tx          <= 1'b1;
        active_flag      <= 1'b0;
        done_flag        <= 1'b1;
        serial_pos       <= 4'd0;
    end
    else
    begin
        if (send)
        begin
            //  Works as an enable
            if (serial_pos == 4'd10)
            begin
                done_flag    <= 1'b1;
                active_flag  <= 1'b0;
                serial_pos   <= 4'd0;
            end
            else
            begin
                data_tx      <= frame[serial_pos];
                done_flag    <= 1'b0;
                active_flag  <= 1'b1;
                serial_pos   <= serial_pos + 1;
            end
        end
        else
        begin
            data_tx           <= 1'b1;
            done_flag         <= 1'b1;
            active_flag       <= 1'b0;
            serial_pos        <= 4'd0;
        end
    end  
end

endmodule