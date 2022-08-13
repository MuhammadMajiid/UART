//  This module is created by ALi Morgan, All credits to him.



module TxTest ();


//regs to derive the inputs 

reg ResetN ;
reg StopBits ; 
reg DataLength ; 
reg Send ; 
reg clock ; 

reg [1:0] ParityType ; 
reg [1:0] BaudRate ;
reg [7:0] DataIn ; 

//wires to recive the output 

wire DataOut ; 
wire ParallParOut; 
wire ActiveFlag ; 
wire DoneFlag; 

TxUnit TxUT(
    .ResetN(ResetN), 
    .StopBits(StopBits), 
    .DataLength(DataLength), 
    .Send(Send), 
    .clock(clock), 
    .ParityType(ParityType), 
    .BaudRate(BaudRate), 
    .DataIn(DataIn), 
    .DataOut(DataOut), 
    .ParallParOut(ParallParOut),
    .ActiveFlag(ActiveFlag), 
    .DoneFlag(DoneFlag)
);
//stop bits + data l cannot be => 00 , 11
integer  i ;
initial begin
    //reseting the system for 10ns 
    Send = 0 ; 
    ResetN = 0 ; 
    #10 ; 
    ResetN = 1 ; 

    StopBits = 0 ; // 1 stop bit 
    DataLength = 1 ; // 8 bits
    ParityType = 2'b00 ; 
    BaudRate = 2'b00 ;

    DataIn = 8'b10101010 ;

    for (i = 0;i < 4 ; i = i + 1) begin //testing four different speeds (BaudRate)
        BaudRate = i ; 
        ParityType = i ; 
        if (i > 1) begin
            StopBits = 1 ; 
            DataLength = 0 ; 
        end
        Send = 1 ; //Send data 
        #(4560000 / (i + 1)) ; 
        Send = 0 ; //stop Sending
        #1000;
    end 
end
//50Mhz clock 20ns period (10ns low - 10ns high )
always begin
    clock = 0 ; 
    #10 ; 
    clock = 1 ; 
    #10 ; 
end
endmodule