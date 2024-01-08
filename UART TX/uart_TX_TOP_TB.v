`timescale 1ns/1ps
module UART_TX_TOP_TB#(parameter DATA_WIDTH=8,START_BIT=1'b0,STOP_BIT=1'b1)();
reg [DATA_WIDTH-1:0] P_DATA_tb; 
reg  DATA_VALID_tb;
reg  Clock;
reg  RST;
reg  PAR_EN_tb;
reg  PAR_TYP_tb;
wire TX_OUT_tb;
wire Busy_tb;
initial
 begin
	$dumpfile("UART_TX_testbench.vcd");
	$dumpvars;
        P_DATA_tb='d255;
	DATA_VALID_tb=0;
	PAR_EN_tb=0;
	PAR_TYP_tb=0;
	Clock=0;
	RST=0;
	$display ("TEST CASE 1") ;  // test Load Function
    	repeat(2)@(posedge Clock);
	if(TX_OUT_tb==1 && Busy_tb==0)
	 begin
		$display("Test 1 case Passed");
	 end
	 else
   	  begin
		$display("Test 1 case failed");
 	  end	
	$display ("TEST CASE 2") ;  // test Load Function
    	repeat(2)@(posedge Clock);
        P_DATA_tb='d255;
	DATA_VALID_tb=1;
	PAR_EN_tb=0;
	PAR_TYP_tb=0;
	RST=0;
    	repeat(2)@(posedge Clock);
	if(TX_OUT_tb==1 && Busy_tb==0)
	 begin
		$display("Test case 2 Passed");
	 end
	 else
   	  begin
		$display("Test case 2 failed");
 	  end
	$display ("TEST CASE 3") ;  // test Load Function
    	repeat(2)@(posedge Clock);
        P_DATA_tb='d255;
	DATA_VALID_tb=0;
	PAR_EN_tb=0;
	PAR_TYP_tb=0;
	RST=1;
    	repeat(2)@(posedge Clock);
	if(TX_OUT_tb==1 && Busy_tb==0)
	 begin
		$display("Test case 3 Passed");
	 end
	else
   	 begin
		$display("Test case 3 failed");
 	 end
	$display ("TEST CASE 4") ;  // test Load Function
    	repeat(2)@(posedge Clock);
        P_DATA_tb='d225;
	DATA_VALID_tb=1;
	PAR_EN_tb=1;
	PAR_TYP_tb=0;
	RST=1;
    	repeat(11)@(posedge Clock);
	DATA_VALID_tb=0;
	$display ("TEST CASE 5") ;  // test Load Function
    	repeat(2)@(posedge Clock);
        P_DATA_tb='d255;
	DATA_VALID_tb=1;
	PAR_EN_tb=1;
	PAR_TYP_tb=1;
	RST=1;
    	repeat(11)@(posedge Clock);
	DATA_VALID_tb=0;
	$display ("TEST CASE 6") ;  // test Load Function
    	repeat(2)@(posedge Clock);
        P_DATA_tb='d255;
	DATA_VALID_tb=1;
	PAR_EN_tb=0;
	PAR_TYP_tb=0;
	RST=1;
    	repeat(11)@(posedge Clock);
	DATA_VALID_tb=0;
	$display ("TEST CASE 7") ;  // test Load Function
    	repeat(2)@(posedge Clock);
        P_DATA_tb='d128;
	DATA_VALID_tb=1;
	PAR_EN_tb=1;
	PAR_TYP_tb=0;
	RST=1;
    	repeat(11)@(posedge Clock);
	DATA_VALID_tb=0;
	$display ("TEST CASE 8") ;  // test Load Function
    	repeat(2)@(posedge Clock);
        P_DATA_tb='d128;
	DATA_VALID_tb=1;
	PAR_EN_tb=1;
	PAR_TYP_tb=1;
	RST=1;
    	repeat(11)@(posedge Clock);
	DATA_VALID_tb=0;
	$display ("TEST CASE 9") ;  // test Load Function
    	repeat(2)@(posedge Clock);
        P_DATA_tb='d128;
	DATA_VALID_tb=1;
	PAR_EN_tb=1;
	PAR_TYP_tb=1;
	RST=1;
    	repeat(11)@(posedge Clock);
	DATA_VALID_tb=0;	
	$finish;	 
 end
//clock generator
always #2.5 Clock= ~Clock; //clock frequency is 200MHz
//DUT instantiation
UART_TX_TOP #(.DATA_WIDTH(DATA_WIDTH),.START_BIT(START_BIT),.STOP_BIT(STOP_BIT)) UART_TX_TOP_DUT (.P_DATA(P_DATA_tb),
.DATA_VALID(DATA_VALID_tb),.CLK(Clock),.RST(RST),.PAR_EN(PAR_EN_tb),.PAR_TYP(PAR_TYP_tb),.TX_OUT(TX_OUT_tb),.Busy(Busy_tb));
endmodule
