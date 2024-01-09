module stop_check#(parameter PRESCALE_BITS=5)(
input  wire sampled_bit,
input  wire stp_chk_en,
input  wire [PRESCALE_BITS-1:0] edge_cnt,
input  wire [PRESCALE_BITS-1:0] Prescale,
input  wire CLK,
input  wire RST,
output reg stp_err);

 always @(posedge CLK or negedge RST)
  begin
   if(!RST)
    begin
     	stp_err<=1'b0;
    end
   else if(stp_chk_en && edge_cnt==Prescale-1)
    begin
	   if(sampled_bit)
   	    begin
		stp_err<=1'b0;
    	    end
   	   else
   	    begin
		stp_err<=1'b1;	
   	    end
    end
   else
    begin
		stp_err<=1'b0;
    end
  end
endmodule

