//  This module is created by Mohamed Maged.
//  Undergraduate ECE student, Alexandria university.
//  This is the Top module for the Reciever unit.
//  Architecture designed by Mohamed Maged.
//  Full Architecture will be provided in the ReadMe file.

module RxUnit(
    input ResetN,            //  Active low reset.
    input DataTx,            //  Serial Data recieved from the transmitter.
    input Clock,             //  The System's main clock.
    input [1:0] ParityType,  //  Parity type agreed upon by the Tx and Rx units.
    input [1:0] BaudRate,    //  Baud Rate agreed upon by the Tx and Rx units.

    output [2:0] ErrorFlag,
    //  Consits of three bits, each bit is a flag for an error
    //  ErrorFlag[0] ParityError flag, ErrorFlag[1] StartError flag,
    //  ErrorFlag[2] StopError flag.
    output [7:0] Data        //  The 8-bits data separated from the data frame.
);

//  Intermediate wires
wire BaudSig;      //  The clocking signal from the baud generator.
wire [10:0] DataP; //  Data parallel comes from the SIPO unit.
wire RFlag;        //  The Recieved-Enabling flag from SIPO unit to DeFrame unit.
wire DeParBit;     //  The Parity bit from the Deframe unit to the ErrorCheck unit.
wire DeStrtBit;    //  The Start bit from the Deframe unit to the ErrorCheck unit.
wire DeStpBit;     //  The Stop bit from the Deframe unit to the ErrorCheck unit.

//  Clocking Unit Instance
BaudGen Unit1(
    //  Inputs
    .ResetN(ResetN),
    .Clock(Clock),
    .BaudRate(BaudRate),

    //  Output
    .BaudOut(BaudSig)
);

//  Shift Register Unit Instance
SIPO Unit2(
    //  Inputs
    .ResetN(ResetN),
    .DataTx(DataTx),
    .BaudOut(BaudSig),

    //  Outputs
    .RecievedFlag(RFlag),
    .DataParl(DataP)
);

//  DeFramer Unit Instance
DeFrame Unit3(
    //  Inputs
    .ResetN(ResetN),
    .RecievedFlag(RFlag),
    .DataParl(DataP),
    
    //  Outputs
    .ParityBit(DeParBit),
    .StartBit(DeStrtBit),
    .StopBit(DeStpBit),
    .RawData(Data)
);

//  Error Checking Unit Instance
ErrorCheck Unit4(
    //  Inputs
    .ResetN(ResetN),
    .ParityBit(DeParBit),
    .StartBit(DeStrtBit),
    .StopBit(DeStpBit),
    .ParityType(ParityType),
    .RawData(Data),

    //  Output
    .ErrorFlag(ErrorFlag)
);

endmodule