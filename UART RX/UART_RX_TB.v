`timescale 1ns/1ps
module UART_RX_TB #(parameter DATA_WIDTH=8,PRESCALE_BITS=5,TX_BITS=4,SERIAL_DATA_WIDTH=22,COUNT_BITS=5)();
reg RX_IN_tb;
reg  [4:0] Prescale_tb;
reg  PAR_EN_tb;
reg  PAR_TYP_tb;
reg  CLK;
reg  Clock;
reg  RST;
wire [DATA_WIDTH-1:0] P_DATA_tb;
wire DATA_VALID_tb;
reg  [SERIAL_DATA_WIDTH-1:0] SERIAL_DATA_IN;
reg  [COUNT_BITS-1:0] Counter;
reg  DATA_SERIAL_VALID;
localparam half_clock_period=2.5;
initial
 begin
	$dumpfile("UART_RX_testbench.vcd");
	$dumpvars;
	RX_IN_tb=1'b1; 
 	Prescale_tb='b0;
	PAR_EN_tb=1'b0;
	PAR_TYP_tb=1'b0;
	CLK=1'b1;
	Clock=1'b0;
	RST=1'b0;
	DATA_SERIAL_VALID=1'b0;
	repeat(8*2)@(posedge CLK);
	repeat(2)@(posedge Clock);
	SERIAL_DATA_IN='b10011111010_10010101010;
	Counter='b0;
	RST=1'b1;
	DATA_SERIAL_VALID=1'b1;
	Prescale_tb='d8;
	PAR_EN_tb=1'b1;
	PAR_TYP_tb=1'b0;
	repeat(SERIAL_DATA_WIDTH*3)@(posedge Clock);
	repeat(Prescale_tb*SERIAL_DATA_WIDTH*3)@(posedge CLK);
 	$stop;
 end
 always @(posedge Clock)
  begin	
	if(DATA_SERIAL_VALID && Counter<SERIAL_DATA_WIDTH)
	 begin
		RX_IN_tb<=SERIAL_DATA_IN[Counter];
		Counter<=Counter+1;
	 end
	else
	 begin
		RX_IN_tb<=1'b1;
		Counter<='b0;
	 end 
  end
 //clock generator
always #(half_clock_period) Clock= ~Clock; //clock frequency is 200MHz transmitted data clock
always #(half_clock_period/8) CLK= ~CLK;
//DUT instantiation
UART_RX_TOP #(.DATA_WIDTH(DATA_WIDTH),.PRESCALE_BITS(PRESCALE_BITS),.TX_BITS(TX_BITS)) UART_RX_TOP_DUT (
.RX_IN(RX_IN_tb),.Prescale(Prescale_tb),.PAR_EN(PAR_EN_tb),.PAR_TYP(PAR_TYP_tb),
.CLK(CLK),.RST(RST),.P_DATA(P_DATA_tb),.DATA_VALID(DATA_VALID_tb));



endmodule
