module TxUnitTest ();


//regs to derive the inputs 

reg rst ;
reg stop_bits ; 
reg data_length ; 
reg send ; 
reg clock ; 

reg [1:0] parity_type ; 
reg [1:0] baud_rate ;
reg [7:0] data_in ; 

//wires to recive the output 

wire data_out ; 
wire p_parity_out; 
wire tx_active ; 
wire tx_done; 

TxUnit TxUT(
    .rst(rst), 
    .stop_bits(stop_bits), 
    .data_length(data_length), 
    .send(send), 
    .clock(clock), 
    .parity_type(parity_type), 
    .baud_rate(baud_rate), 
    .data_in(data_in), 
    .data_out(data_out), 
    .p_parity_out(p_parity_out),
    .tx_active(tx_active), 
    .tx_done(tx_done)
);
//stop bits + data l cannot be => 00 , 11
integer  i ;
initial begin
    //reseting the system for 10ns 
    send = 0 ; 
    rst = 0 ; 
    #10 ; 
    rst = 1 ; 

    stop_bits = 0 ; // 1 stop bit 
    data_length = 1 ; // 8 bits
    parity_type = 2'b00 ; 
    baud_rate = 2'b00 ;

    data_in = 8'b10101010 ;

    for (i = 0;i < 4 ; i = i + 1) begin //testing four different speeds (baud_rate)
        baud_rate = i ; 
        parity_type = i ; 
        if (i > 1) begin
            stop_bits = 1 ; 
            data_length = 0 ; 
        end
        send = 1 ; //send data 
        #(4560000 / (i + 1)) ; 
        send = 0 ; //stop sending
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