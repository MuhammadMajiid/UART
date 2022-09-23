//  AUTHOR: Mohamed Maged Elkholy.
//  INFO.: Undergraduate ECE student, Alexandria university, Egypt.
//  AUTHOR'S EMAIL: majiidd17@icloud.com
//  FILE NAME: PISO.v
//  TYPE: module.
//  DATE: 30/8/2022
//  KEYWORDS: Frame, Data-Tx, PISO, shift register.
//  PURPOSE: An RTL modelling for the transmitter's frame generator,
//  and shift register to send data serially in 11 baud_clk cycles.

module PISO(
    input wire           reset_n,            //  Active low reset.
    input wire           send,               //  An enable to start sending data.
    input wire           baud_clk,           //  Clocking signal from the BaudGen unit.
    input wire           parity_bit,         //  The parity bit from the Parity unit.
    input wire [1:0]     parity_type,        //  Parity type agreed upon by the Tx and Rx units.
    input wire [7:0]     data_in,            //  The data input.
  
    output reg 	         data_tx, 	         //  Serial transmitter's data out
	output reg 	         active_flag,        //  high when Tx is transmitting, low when idle.
	output reg  	     done_flag 	         //  high when transmission is done, low when active.
);

//  Internal declarations
reg [3:0]   stop_count;
//  an index for the bit of the frame which its turn to get transmitted.
reg [10:0]  frame;
reg [10:0]  frame_r;
//  Frame: {idle 1 if needed,stopbit,ParityBit,RegOut[MSB:LSB],Startbit}
reg [7:0]   reg_data;
//  Holds the data untill transmission is done.
reg         next_state;
//  Holds the FSM's next state.

//  Encoding the states
localparam IDLE   = 1'b0,
           ACTIVE = 1'b1;


//  Set the data and hold it in reset and IDLE case
always @(negedge next_state)
begin
    if (~next_state) 
    begin
        reg_data <= data_in;
    end
    else
    begin
        reg_data <= reg_data;
    end
end

//  Frame generation combinational logic
always @(reg_data, parity_type, parity_bit)
begin
    if ((~|parity_type) || (&parity_type))
    //  This is an equivalent condition to (parity_type == 'b00)
    //  or (parity_type == 'b11), in order to avoid comparators/xors
    begin
        //  Frame with no parity bit
        frame  = {2'b11,reg_data,1'b0};
    end
    else
    begin
        //  Frame with parity bit
        frame  = {1'b1,parity_bit,reg_data,1'b0};
    end
end

//  Transmission logic FSM with Asynchronous Reset logic
always @(posedge baud_clk, negedge reset_n)
begin
    if (~reset_n) 
    begin
       //  idle
        next_state       <= IDLE; 
    end
	else
	begin
		frame_r <= frame;
		case (next_state)

            //  waits for the send enable signal
            IDLE:
            begin
                data_tx      <= 1'b1;
                active_flag  <= 1'b0;
                done_flag    <= 1'b1;
                stop_count   <= 4'd0;

                if (send)
                //  Works as an enable
                begin
                    next_state   <= ACTIVE;
                end
                else
                begin
                    next_state   <= IDLE;
                end
            end

            //  loops 11 time at baud_clk to send all the frame serially
            ACTIVE:
            begin
                if (stop_count[3] && stop_count[1] && stop_count[0])
                //  This is an equivalent condition to (stop_count == 'd11)
                //  in order to avoid comparators/xors  
                begin
                    data_tx      <= 1'b1;
                    stop_count   <= 4'd0;
                    active_flag  <= 1'b0;
                    done_flag    <= 1'b1;
                    next_state   <= IDLE;
                end
                else
                begin
                    data_tx      <= frame_r[0];
                    frame_r      <= frame_r >> 1;
                    //  assiginning the first bit of the frame to the data_tx,
                    //  truncates the rest, then shifting the frame by 1 position
                    //  to the right to get the next data bit, and so on.
                    stop_count   <= stop_count + 1'd1;
                    active_flag  <= 1'b1;
                    done_flag    <= 1'b0;
                    next_state   <= ACTIVE;
                end
            end

            //  Automatically directs to the IDLE state
            default:
            begin
                next_state   <= IDLE;
            end
        endcase 
	end 
end
endmodule  