module edge_bit_counter #(parameter DATA_WIDTH=8, PRESCALE_BITS=5,TX_BITS=4)(
input  wire Enable,
input  wire CLK,
input  wire RST,
input  wire [PRESCALE_BITS-1:0] prescale,
output reg  [TX_BITS-1:0] bit_cnt,
output reg  [PRESCALE_BITS-1:0] edge_cnt);


 always @(posedge CLK or negedge RST)
  begin
	if(!RST)
	 begin 
		bit_cnt='b0;
		edge_cnt='b0;
	 end
	else if(Enable)
	 begin
		if(edge_cnt==prescale-1)
	  	 begin
			bit_cnt<=bit_cnt+1'b1;
			edge_cnt<='b0;
	  	 end
		else
		 begin
			edge_cnt<=edge_cnt+1'b1;
	 	 end
	 end
	else
	 begin
		bit_cnt='b0;
		edge_cnt='b0;
	 end 
  end
  
 endmodule
