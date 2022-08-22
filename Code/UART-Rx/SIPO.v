module SIPO(
    input DataTx, ResetN, BaudOut,
    
    output RecievedFlag,
    output [10:0] DataParl
);
//Internal
reg [10:0] Shifter;
reg [3:0]  Count;

always @(posedge BaudOut, negedge ResetN) begin
    if(~ResetN)begin
      Shifter <= {11{1'b1}};
      Count   <= 4'd0;
    end
    else begin
      Shifter <= {Shifter, DataTx};
      Count   <= Count + 1'd1;
  end
end

//DoneFlag assignment
assign RecievedFlag = (Count == 4'd11);

//Output
assign DataParl = Shifter;
endmodule