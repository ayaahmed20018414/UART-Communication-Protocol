module UART_TX_TOP #(parameter DATA_WIDTH=8,START_BIT=1'b0,STOP_BIT=1'b1)
(input wire [DATA_WIDTH-1:0] P_DATA, 
input  wire DATA_VALID,
input  wire CLK,
input  wire RST,
input  wire PAR_EN,
input  wire PAR_TYP,
output wire TX_OUT,
output wire Busy);

wire Ser_Done,Ser_En,Ser_Data,PAR_bit;
wire [1:0] MUX_SEL;
wire Start_bit=START_BIT;
wire Stop_bit=STOP_BIT;

 SERIALIZER #(.DATA_WIDTH(DATA_WIDTH)) U_serializer (.P_DATA(P_DATA),.Ser_En(Ser_En),.CLK(CLK),.RST(RST),
 .Ser_Data(Ser_Data),.Ser_Done(Ser_Done));

 Parity_Clac #(.DATA_WIDTH(DATA_WIDTH)) U_parity_calc (.P_DATA(P_DATA),.Parity_En(PAR_EN),.Data_Valid(DATA_VALID),.PAR_TYP(PAR_TYP),.Par_bit(PAR_bit),.CLK(CLK),.RST(RST));

 UART_FSM U_uart_fsm (.Data_Valid(DATA_VALID),.Ser_Done(Ser_Done),.Parity_En(PAR_EN),.CLK(CLK),.RST(RST),.MUX_Sel(MUX_SEL),.busy(Busy),.Ser_EN(Ser_En));

 MUX U_mux (.MUX_Sel(MUX_SEL),.Start_bit(Start_bit),.CLK(CLK),.RST(RST),.Ser_Data(Ser_Data),.Stop_bit(Stop_bit),.PAR_bit(PAR_bit),.TX_out(TX_OUT));
endmodule
