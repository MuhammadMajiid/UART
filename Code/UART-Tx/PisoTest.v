//                       ************************************** This module is created by Mohamed Maged **************************************
//Chipions program's final project for phase(001) "verilog", UART-Tx.
//Undergraduate student, ECE department, Alexandria university.

module PisoTest;

//Test Inputs
reg TStopBits, TDataLength, Tsend,Trst, TBaudOut, TParityOut;
reg [1:0]   TParityType;
reg [10:0]  TFrameOut;

//Test outputs
wire TDataOut, TParllParity, TActive, TDone;

//Instantiation of the designed block
PISO MyTest(
    .ParityType(TParityType), .BaudOut(TBaudOut),
    .StopBits(TStopBits), .DataLength(TDataLength), .ParityOut(TParityOut),
    .Send(Tsend), .ResetN(Trst), .FrameOut(TFrameOut),

    .DataOut(TDataOut), .ParallParOut(TParllParity),
    .ActiveFlag(TActive), .DoneFlag(TDone)
);


//Monitorin the outputs and the inputs
initial begin
    $monitor($time, "   The Outputs:  DataOut = %b   ParallelParity = %b  ActiveFlag = %b   DoneFlag = %b  
                        The Inputs: StopBit = %b  DataLength = %b  Send = %b  Reset = %b   ParityType = %b ",
     TDataOut, TParllParity, TActive, TDone, TStopBits, TDataLength, Tsend, Trst, TParityType[1:0] );
end


//Set up the reset
initial begin
    Trst = 1'b0;
    #10 Trst = 1'b1;
    #200 Trst = 1'b0;
    #20  Trst = 1'b1;
end


//Set up the send signal
initial begin
    Tsend = 1'b0;
    #10 Tsend = 1'b1;
    #150 Tsend = 1'b0;
    #50  Tsend = 1'b1;
end


//Set up a clock "Baudrate"
initial begin
    TBaudOut = 1'b1;
    forever #10 TBaudOut = ~TBaudOut;
end 


//Varying the stopits, datalength, paritytype >>> 4-bits with 16 different cases with 8 ignored cases <<<
initial begin

         {TStopBits, TDataLength, TParityType[1:0]} = 4'b0100;      //1-bit stop bit, 8-bits data length, no parity
         TParityOut  =   (^(01001010))? 1'b0 : 1'b1;
    #220 {TStopBits, TDataLength, TParityType[1:0]} = 4'b0101;      //1-bit stop bit, 8-bits data length, odd parity
         TParityOut  =   (^(01001010))? 1'b0 : 1'b1;
    #220 {TStopBits, TDataLength, TParityType[1:0]} = 4'b0110;      //1-bit stop bit, 8-bits data length, even parity
         TParityOut  =   (^(01001010))? 1'b1 : 1'b0;
    #220 {TStopBits, TDataLength, TParityType[1:0]} = 4'b0111;      //1-bit stop bit, 8-bits data length, no parity
         TParityOut  =   (^(01011010))? 1'b0 : 1'b1;
    #220 {TStopBits, TDataLength, TParityType[1:0]} = 4'b1000;      //2-bits stop bit, 7-bits data length, no parity
         TParityOut  =   (^(1000010))? 1'b0 : 1'b1;
    #220 {TStopBits, TDataLength, TParityType[1:0]} = 4'b1001;      //2-bits stop bit, 7-bits data length, odd parity
         TParityOut  =   (^(1001010))? 1'b0 : 1'b1;
    #220 {TStopBits, TDataLength, TParityType[1:0]} = 4'b1010;      //2-bits stop bit, 7-bits data length, even parity
         TParityOut  =   (^(1001010))? 1'b1 : 1'b0;
    #220 {TStopBits, TDataLength, TParityType[1:0]} = 4'b1011;      //2-bits stop bit, 7-bits data length, no parity
         TParityOut  =   (^(1001000))? 1'b0 : 1'b1;
end


//various Frames 
initial begin

         TFrameOut = 11'b11010010100;         //1-bit stop bit, 8-bits data bits, no parity bit
    #220 TFrameOut = 11'b10010010100;         //1-bit stop bit, 8-bits data bits, odd parity
    #220 TFrameOut = 11'b11010010100;         //1-bit stop bit, 8-bits data bits, even parity
    #220 TFrameOut = 11'b11010110100;         //1-bit stop bit, 8-bits data bits, no parity bit
    #220 TFrameOut = 11'b11110000100;         //2-bit stop bit, 7-bits data bits, no parity bit
    #220 TFrameOut = 11'b11010010100;         //2-bit stop bit, 7-bits data bits, odd parity
    #220 TFrameOut = 11'b11010010100;         //2-bit stop bit, 7-bits data bits, even parity
    #220 TFrameOut = 11'b11110010000;         //2-bit stop bit, 7-bits data bits, no parity bit
    
end

initial begin
    #1780 $stop;
end

endmodule