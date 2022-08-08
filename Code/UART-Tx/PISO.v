//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.


module PISO
    #(parameter Bits = 11)(
    input [1:0]   parity_type, 
	input 		  stop_bits, 	//low when using 1 stop bit, high when using two stop bits.
    input 		  data_length, 	//low when using 7 data bits, high when using 8.
    input         send, rst,  
    input         BaudOut,    
    input [Bits - 1:0]  FrameOut,
  
    output reg 	data_out, 		//Serial data_out
	output reg 	p_parity_out, 	//parallel odd parity output, low when using the frame parity.
	output reg 	tx_active, 		//high when Tx is transmitting, low when idle.
	output reg 	tx_done 		//high when transmission is done, low when not.
);

//Internal declarations  
reg       ParHolder;
reg [7:0] DataIn;
integer   SerialPos    = 0;


//This part handles the odd parity check for the output p_parity_out
always @(data_length, FrameOut) begin

    DataIn = data_length? FrameOut[8:1] : {1'b0, FrameOut[7:1]};
    //Parallel Odd parity
    ParHolder = (^DataIn)? 1'b0 : 1'b1;

end


//This part handles the outputs
always @(negedge rst, posedge BaudOut) begin
    
    if (~rst) begin
    data_out        = 'b1;
    p_parity_out    = 'b0;
    tx_active       = 'b0;
    tx_done         = 'b1;
    end
    else begin
        if (send) begin
            if (SerialPos == (Bits - 1)) begin
                tx_done   = 1'b1;
                tx_active = 1'b0;
                SerialPos = 0;
                //data_out  = 'b1;
            end
            else begin
                data_out  = FrameOut[SerialPos];
                SerialPos = SerialPos + 1;
                tx_done   = 1'b0;
                tx_active = 1'b1;
            end
            if (parity_type  == 'b00 || parity_type == 'b11 ) begin
                p_parity_out = ParHolder;
            end
            else begin
                p_parity_out = 'b0;
            end
        end
        else begin
        data_out        = 'b1;
        p_parity_out    = 'b0;
        tx_done         = 1'b1;
        tx_active       = 1'b0;
        end
    end  
end

endmodule