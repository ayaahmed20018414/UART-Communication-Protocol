module deserializer #(parameter DATA_WIDTH=8,PRESCALE_BITS=5, TX_BITS=4)(
input  wire deser_en,
input  wire sampled_bit,
input  wire CLK,
input  wire RST,
input  wire [TX_BITS-1:0] bit_cnt,
input  wire [PRESCALE_BITS-1:0] edge_cnt,
input  wire [PRESCALE_BITS-1:0] Prescale,
output reg  [DATA_WIDTH-1:0] P_DATA);

reg [3:0] Count;

 always @(posedge CLK or negedge RST)
  begin
	if(!RST)
	 begin
		P_DATA<='b0;
		Count<='b0;
	 end
	else if(deser_en && edge_cnt==Prescale-1)
	 begin
		if(Count!=DATA_WIDTH)
		 begin
			P_DATA[Count]<=sampled_bit;
			Count<=Count+1;
		 end
		else
		 begin
			Count<=0;
			P_DATA<='b0;
		 end
	 end
	else if(bit_cnt=='b0)
	 begin
			Count<=0;
			P_DATA<='b0;			
	 end
  end





endmodule 
