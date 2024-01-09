module data_sampling#(parameter PRESCALE_BITS=5)(
input  wire RX_IN,
input  wire [PRESCALE_BITS-1:0] Prescale,
input  wire data_samp_en,
input  wire [PRESCALE_BITS-1:0] edge_cnt,
input  wire CLK,
input  wire RST,
output reg  sampled_bit);
 reg F1,F2,F3;
 wire [4:0] p1,p2,p3;      
 always @(posedge CLK or negedge RST)
  begin 
	if(!RST)
	 begin
		sampled_bit<=1'b0;
	 	F1<=1'b0;	
		F2<=1'b0;	
		F3<=1'b0;	
	 end
	else if(data_samp_en)
	 begin
	  if(edge_cnt==p1)
	   begin
		F1<=RX_IN;
	   end
	  else if(edge_cnt==p2)
	   begin
		F2<=RX_IN;
	   end
	  else if(edge_cnt==p3)
	   begin
		F3<=RX_IN;
	   end
		case(Prescale)
	 	 5'd4:begin
		      sampled_bit<=F2;
		      end
		 5'd8:begin
			if(F1&&F2&&F3)
			  begin
				 	sampled_bit<=F1;
			  end
			else if(!(F1||F2||F3))
			 begin
					sampled_bit<=F1;
			 end
			else if(!(F1^F2^F3))
			 begin
					sampled_bit<=1'b1;
			 end
			else if(F1^F2^F3)
			 begin
					sampled_bit<=1'b0;
			 end
			else
			 begin
					sampled_bit<=1'b0;
			 end
		       end
		 5'd16:begin
			if(F1&&F2&&F3)
			  begin
				 	sampled_bit<=F1;
			  end
			else if(!(F1||F2||F3))
			 begin
					sampled_bit<=F1;
			 end
			else if(!(F1^F2^F3))
			 begin
					sampled_bit<=1'b1;
			 end
			else if(F1^F2^F3)
			 begin
					sampled_bit<=1'b0;
			 end
			else
			 begin
					sampled_bit<=1'b0;
			 end
		       end
		 5'd32:begin
			if(F1&&F2&&F3)
			  begin
				 	sampled_bit<=F1;
			  end
			else if(!(F1||F2||F3))
			 begin
					sampled_bit<=F1;
			 end
			else if(!(F1^F2^F3))
			 begin
					sampled_bit<=1'b1;
			 end
			else if(F1^F2^F3)
			 begin
					sampled_bit<=1'b0;
			 end
			else
			 begin
					sampled_bit<=1'b0;
			 end
		       end
	         default:begin
					sampled_bit<=1'b0;
			 end   
		endcase			    
	 end
  end

assign p1=(Prescale/2)-1;
assign p2=Prescale/2;
assign p3 =(Prescale/2)+1; 




endmodule
