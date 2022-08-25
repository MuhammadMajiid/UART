//  This module is created by Mohamed Maged
//  Undergraduate ECE student, Alexandria university.
//  An RTL design module code for a Serial-In-Parallel-Out shift register,
//  stores the data recieved at the positive-clock-edge [BaudRate], then
//  pass the data frame to the DeFrame unit.

module SIPO(
    input ResetN,   //  Active low reset.
    input DataTx,   //  Serial Data recieved from the transmitter.
    input BaudOut,  //  The clocking input comes from the sampling unit.

    output reg RecievedFlag,      //  outputs a signal enables the deframe unit.
    output reg [10:0] DataParl    //  outputs the 11-bit parallel frame.
);
//  Internal
reg [10:0] Shifter;
reg [3:0]  Count;

//  Shifting data logic part
always @(posedge BaudOut, negedge ResetN) begin
    if(~ResetN)begin
      Shifter <= {11{1'b1}};
      Count   <= 4'd0;
    end
    else begin
      Shifter <= {Shifter,DataTx};
      Count   <= Count + 1'd1;
    end
end

//  Output logic
always @(*) begin

  //  Output Data
  assign DataParl = Shifter;

  //  RecievedFlag assignment
  if(Count == 4'd11) begin
    RecievedFlag = 1'b1;
    Count = 4'd0;
  end
  else begin
    RecievedFlag = 1'b0;
    Count = Count;
  end
end

endmodule