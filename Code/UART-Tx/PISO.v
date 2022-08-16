//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.


module PISO(
    input [1:0]   ParityType, 
	input 		  StopBits, 	//low when using 1 stop bit, high when using two stop bits.
    input 		  DataLength, 	//low when using 7 data bits, high when using 8.
    input         Send, ResetN,  
    input         BaudOut, ParityOut,  
    input [10:0]  FrameOut,
  
    output reg 	DataOut, 		//Serial data_out
	output reg 	ParallParOut, 	//parallel odd parity output, low when using the frame parity.
	output reg 	ActiveFlag, 	//high when Tx is transmitting, low when idle.
	output reg 	DoneFlag 		//high when transmission is done, low when not.
);

//Internal declarations
integer   SerialPos = 0;

//This part handles the outputs
always @(negedge ResetN, posedge BaudOut) begin
    
    if (~ResetN) begin
    DataOut         = 1'b1;
    ParallParOut    = 1'b0;
    ActiveFlag      = 1'b0;
    DoneFlag        = 1'b1;
    SerialPos       =    0;
    end
    else begin
        if (Send) begin                            //Works as an enable
            if (SerialPos == 'd10) begin
                DoneFlag    = 1'b1;
                ActiveFlag  = 1'b0;
                SerialPos   =    0;
            end
            else begin
                DataOut     = FrameOut[SerialPos];
                SerialPos   = SerialPos + 1;
                DoneFlag    = 1'b0;
                ActiveFlag  = 1'b1;
            end
            if (ParityType  == 2'b00 || ParityType == 2'b11 ) begin
                ParallParOut = ParityOut;
            end
            else begin
                ParallParOut = 1'b0;
            end
        end
        else begin
        DataOut          = 1'b1;
        ParallParOut     = 1'b0;
        DoneFlag         = 1'b1;
        ActiveFlag       = 1'b0;
        SerialPos        =    0;
        end
    end  
end

endmodule