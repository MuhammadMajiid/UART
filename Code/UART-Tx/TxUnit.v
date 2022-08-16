//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  This is the top module for the UART-Tx Unit.

module TxUnit(
    input   ResetN, StopBits, DataLength, Send, Clock,
    input   [1:0]   ParityType, BaudRate,
    input   [7:0]  DataIn,

    output  DataOut, ParallParOut, ActiveFlag , DoneFlag
);

//interconnection 
wire    ParOutUnit, BaudOutUnit;
wire    [7:0]   RegOutUnit;
wire    [10:0]  FramOutUnit;

//Register Unit
InReg Unit1(
    .ResetN(ResetN), .DataIn(DataIn), .DoneFlag(DoneFlag),        //inputs

    .RegOut(RegOutUnit)              //output
);

//Parity unit instantiation 
Parity Unit2(
    .ResetN(ResetN), .RegOut(RegOutUnit), .ParityType(ParityType),    //inputs
    
    .ParityOut(ParOutUnit)     //output
);

//Frame generator unit instantiation
FrameGenerator Unit3(
    .ResetN(ResetN), .RegOut(RegOutUnit), .ParityType(ParityType), .StopBits(StopBits), .DataLength(DataLength),
    .ParityOut(ParOutUnit),    //inputs
    
    .FrameOut(FramOutUnit)     //output
);

//Baud generator unit instantiation
BaudRateGen Unit4(
    .BaudRate(BaudRate), .Clock(Clock), .ResetN(ResetN),        //inputs
    
    .BaudOut(BaudOutUnit)      //output
);

//PISO shift register unit instantiation
PISO Unit5(
    .ParityType(ParityType), .ResetN(ResetN), .StopBits(StopBits), .DataLength(DataLength), .Send(Send),
    .FrameOut(FramOutUnit), .BaudOut(BaudOutUnit), .ParityOut(ParOutUnit),          //inputs

    .DataOut(DataOut), .ParallParOut(ParallParOut), .ActiveFlag(ActiveFlag), .DoneFlag(DoneFlag)      //outputs
);

endmodule