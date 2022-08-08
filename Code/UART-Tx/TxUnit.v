//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  This is the top module for the UART-Tx Unit.

module TxUnit(
    input   ResetN, StopBits, DataLength, Send, Clock,
    input   [1:0]   ParityType, BaudRate,
    input   [10:0]  DataIn,

    output reg  DataOut, ParallParOut, ActiveFlag , DoneFlag
);

//interconnection 
wire    ParOutUnit, BaudOutUnit;
wire    [10:0]  FramOutUnit;


//Parity unit instantiation 
parity Unit1(
    .ResetN(ResetN), .DataIn(DataIn), .ParityType(ParityType),    //inputs
    
    .ParityOut(ParOutUnit)     //output
);

//Frame generator unit instantiation
frame_gen Unit2(
    .ResetN(ResetN), .DataIn(DataIn), .ParityType(ParityType), .StopBits(StopBits), .DataLength(DataLength), .ParityOut(ParOutUnit),     //inputs
    
    .FrameOut(FramOutUnit)     //output
);

//Baud generator unit instantiation
baud_gen Unit3(
    .BaudRate(BaudRate), .Clock(Clock), .ResetN(ResetN),        //inputs
    
    .BaudOut(BaudOutUnit)      //output
);

//PISO shift register unit instantiation
PISO Unit4(
    .ParityType(ParityType), .ResetN(ResetN), .StopBits(StopBits), .DataLength(DataLength), .Send(Send),
    .FrameOut(FramOutUnit), .BaudOut(BaudOutUnit)           //inputs

    .DataOut(DataOut), .ParallParOut(ParallParOut), .ActiveFlag(ActiveFlag), .DoneFlag(DoneFlag)      //outputs
);

endmodule