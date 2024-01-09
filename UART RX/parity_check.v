module parity_check #(parameter DATA_WIDTH=8, PRESCALE_BITS=5)(
input  wire sampled_bit,
input  wire [DATA_WIDTH-1:0] P_DATA,
input  wire par_chk_en,
input  wire PAR_TYP,
input  wire [PRESCALE_BITS-1:0] edge_cnt,
input  wire [PRESCALE_BITS-1:0] Prescale,
input  wire CLK,
input  wire RST,
output reg  par_err);
 reg  par_result;
 always @(posedge CLK or negedge RST)
  begin 
 	if(!RST)
	 begin
		par_result<=1'b0;
		par_err<=1'b0;
	 end
	else if(par_chk_en && edge_cnt==Prescale-1)
	 begin
		if(PAR_TYP)
		 begin
			par_result<=~^P_DATA;
			par_err<=par_result ^ sampled_bit;
		 end
		else
		 begin
			par_result<=^P_DATA;
			par_err<=par_result ^ sampled_bit;			
		 end


	 end
	else
	 begin
			par_err<=1'b0;
			par_result<=1'b0;
	 end 
		
  end
 

endmodule
