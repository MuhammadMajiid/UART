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
wire [10:0] DataP;
wire RFlag;
wire BaudSig;
wire DeParBit;

//  Clocking Unit Instance
Sampling Unit1(
    //  Inputs
    .ResetN(ResetN), .Clock(Clock), .DataTx(DataTx), .BaudRate(BaudRate),
    //  Output
    .BaudOut(BaudSig)
);

//  Shift Register Unit Instance
SIPO Unit2(
    //  Inputs
    .ResetN(ResetN), .DataTx(DataTx), .BaudOut(BaudSig),
    //  Outputs
    .RecievedFlag(RFlag), .DataParl(DataP)
);

//  DeFramer Unit Instance
DeFrame Unit3(
    //  Inputs
    .ResetN(ResetN), .RecievedFlag(RFlag), .ParityType(ParityType), .DataParl(DataP),
    //  Outputs
    .ParityBit(DeParBit), .RawData(Data)
);

//  Error Checking Unit Instance
ErrorCheck Unit4(
    //  Inputs
    .ResetN(ResetN), .ParityBit(DeParBit), .ParityType(ParityType), .RawData(Data),
    //  Output
    .ErrorFlag(ErrorFlag)
);

endmodule