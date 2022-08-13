//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.


module PISO
    #(parameter integer Bits = 11)(
    input [1:0]   ParityType, 
	input 		  StopBits, 	//low when using 1 stop bit, high when using two stop bits.
    input 		  DataLength, 	//low when using 7 data bits, high when using 8.
    input         Send, ResetN,  
    input         BaudOut, ParityOut,  
    input [Bits - 1:0]  FrameOut,
  
    output reg 	DataOut, 		//Serial data_out
	output reg 	ParallParOut, 	//parallel odd parity output, low when using the frame parity.
	output reg 	ActiveFlag, 		//high when Tx is transmitting, low when idle.
	output reg 	DoneFlag 		//high when transmission is done, low when not.
);

//Internal declarations
integer   SerialPos    = 0;

//This part handles the outputs
always @(negedge ResetN, posedge BaudOut) begin
    
    if (~ResetN) begin
    DataOut         <= 'b1;
    ParallParOut    <= 'b0;
    ActiveFlag      <= 'b0;
    DoneFlag        <= 'b1;
    end
    else begin
        if (Send) begin
            if (SerialPos == (Bits - 1)) begin
                DoneFlag    <= 1'b1;
                ActiveFlag  <= 1'b0;
                SerialPos   <= 0;
            end
            else begin
                DataOut     <= FrameOut[SerialPos];
                SerialPos   <= SerialPos + 1;
                DoneFlag    <= 1'b0;
                ActiveFlag  <= 1'b1;
            end
            if (ParityType  == 'b00 || ParityType == 'b11 ) begin
                ParallParOut <= ParityOut;
            end
            else begin
                ParallParOut <= 'b0;
            end
        end
        else begin
        DataOut          <= 'b1;
        ParallParOut     <= 'b0;
        DoneFlag         <= 1'b1;
        ActiveFlag       <= 1'b0;
        end
    end  
end

endmodule