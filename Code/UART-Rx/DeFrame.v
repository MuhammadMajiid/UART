//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  This module is resbosible for separating the frame into Data bits and Parity bit and truncates Start and Stop bits

module DeFrame(
    input ResetN, RecievedFlag, DataLength,
    input [1:0] ParityType,
    input [10:0] DataParl,

    output reg ParityBit,
    //For output we have two options either 8-bits data or 7-bits data
    output reg [7:0] RawData,
);
//Internals
reg [8:0] DataHolder;                       //Holds the data plus the parity bit

always @(negedge ResetN, DataParl) begin
    if(~ResetN)begin
      DataHolder <= 8'b1;
    end
    else if(RecievedFlag) begin
      DataHolder <= DataParl[9:1];           //Truncates the Start and Stop bits
    end
    else begin
      DataHolder <= DataHolder;
    end
end

//Output Parity logic
always @(*) begin
    if((ParityType == 2'b00) || (ParityType == 2'b11))begin
      ParityBit <= 1'b0;                    //will not be used in error check unit
    end
    else begin
      ParityBit <= DataHolder[8];
    end
end

//Output Data logic
always @(*) begin
    if (DataLength) begin
        RawData = DataHolder[7:0];
    end
    else begin
        RawData = {1'b0, DataHolder[6:0]};
    end
end



endmodule