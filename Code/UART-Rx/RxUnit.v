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

    output ErrorFlag,        //  Outputs logic high if there is an error.
    output DoneFlag,         //  Outputs logic high to recieve new frame.
    output [7:0] Data        //  The 8-bits data separated from the data frame.
);

//  Intermediate wires
wire [10:0] DataP;
wire RFlag;
wire BaudSig;
wire DeParBit;

//  Clocking Unit Instance
Sampling ForDesign(
    //  Inputs
    .ResetN(ResetN), .Clock(Clock), .DataTx(DataTx), .BaudRate(BaudRate),
    //  Output
    .BaudOut(BaudSig)
);

//  Shift Register Unit Instance
SIPO ForDesign(
    //  Inputs
    .ResetN(ResetN), .DataTx(DataTx), .Recieve(DoneFlag), .BaudOut(BaudSig),
    //  Outputs
    .RecievedFlag(RFlag), .DataParl(DataP)
);

//  DeFramer Unit Instance
DeFrame ForDesign(
    //  Inputs
    .ResetN(ResetN), .RecievedFlag(RFlag), .ParityType(ParityType), .DataParl(DataP),
    //  Outputs
    .DoneFlag(DoneFlag), .ParityBit(DeParBit), .RawData(Data)
);

//  Error Checking Unit Instance
ErrorCheck ForDesign(
    //  Inputs
    .ResetN(ResetN), .ParityBit(DeParBit), .ParityType(ParityType), .RawData(Data),
    //  Output
    .ErrorFlag(ErrorFlag)
);

endmodule