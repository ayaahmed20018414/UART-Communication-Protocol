module UART_RX_TOP #(parameter DATA_WIDTH=8,PRESCALE_BITS=5,TX_BITS=4)(
input  wire RX_IN,
input  wire [PRESCALE_BITS-1:0] Prescale,
input  wire PAR_EN,
input  wire PAR_TYP,
input  wire CLK,
input  wire RST,
output wire [DATA_WIDTH-1:0] P_DATA,
output wire DATA_VALID);
 wire sampled_bit;
 wire strt_chk_en;
 wire strt_glitch;
 wire par_chk_en;
 wire par_err;
 wire stp_chk_en;
 wire stp_err;
 wire [TX_BITS-1:0]bit_cnt;
 wire [PRESCALE_BITS-1:0]edge_cnt;
 wire data_samp_en;
 wire enable;
 wire deser_en;
 strt_check #(.PRESCALE_BITS(PRESCALE_BITS)) U_strt_check  (.sampled_bit(sampled_bit),.Prescale(Prescale),.edge_cnt(edge_cnt),.strt_chk_en(strt_chk_en),.CLK(CLK),
.RST(RST),.strt_glitch(strt_glitch));


parity_check #(.DATA_WIDTH(DATA_WIDTH),.PRESCALE_BITS(PRESCALE_BITS)) U_parity_check (.Prescale(Prescale),.edge_cnt(edge_cnt),.sampled_bit(sampled_bit),.P_DATA(P_DATA),.par_chk_en(par_chk_en),
.PAR_TYP(PAR_TYP),.CLK(CLK),.RST(RST),.par_err(par_err));


stop_check #(.PRESCALE_BITS(PRESCALE_BITS)) U_stop_check (.sampled_bit(sampled_bit),.stp_chk_en(stp_chk_en),.Prescale(Prescale),.edge_cnt(edge_cnt),.CLK(CLK),.RST(RST),.stp_err(stp_err));


UART_RX_FSM #(.DATA_WIDTH(DATA_WIDTH),.PRESCALE_BITS(PRESCALE_BITS),.TX_BITS(TX_BITS)) U_UART_RX_FSM 
(.RX_IN(RX_IN),.bit_cnt(bit_cnt),.edge_cnt(edge_cnt),.Prescale(Prescale),.PAR_EN(PAR_EN),.par_err(par_err),
 .strt_glitch(strt_glitch),.stp_err(stp_err),.CLK(CLK),.RST(RST),.data_samp_en(data_samp_en),
 .enable(enable),.strt_chk_en(strt_chk_en),.par_chk_en(par_chk_en),.stp_chk_en(stp_chk_en),
 .deser_en(deser_en),.DATA_VALID(DATA_VALID));


data_sampling #(.PRESCALE_BITS(PRESCALE_BITS)) U_data_sampling (.RX_IN(RX_IN),.Prescale(Prescale),.data_samp_en(data_samp_en),
.edge_cnt(edge_cnt),.CLK(CLK),.RST(RST),.sampled_bit(sampled_bit));


edge_bit_counter #(.DATA_WIDTH(DATA_WIDTH),.PRESCALE_BITS(PRESCALE_BITS),.TX_BITS(TX_BITS)) U_edge_bit_counter(
.Enable(enable),.CLK(CLK),.RST(RST),.prescale(Prescale),.bit_cnt(bit_cnt),.edge_cnt(edge_cnt));


deserializer #(.DATA_WIDTH(DATA_WIDTH),.PRESCALE_BITS(PRESCALE_BITS),.TX_BITS(TX_BITS)) U_deserializer (.deser_en(deser_en),.edge_cnt(edge_cnt),
.Prescale(Prescale),.sampled_bit(sampled_bit),.bit_cnt(bit_cnt),
.CLK(CLK),.RST(RST),.P_DATA(P_DATA));
 
endmodule
