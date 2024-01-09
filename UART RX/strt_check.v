module strt_check #(parameter PRESCALE_BITS=5)(
input  wire sampled_bit,
input  wire [PRESCALE_BITS-1:0] edge_cnt,
input  wire [PRESCALE_BITS-1:0] Prescale,
input  wire strt_chk_en,
input  wire CLK,
input  wire RST,
output reg strt_glitch);

 always @(posedge CLK or negedge RST)
  begin
   if(!RST)
    begin
     	strt_glitch<=1'b0;
    end
   else if(strt_chk_en && edge_cnt==Prescale-1)
    begin
	   if(sampled_bit)
   	    begin
		strt_glitch<=1'b1;
    	    end
   	   else
   	    begin
		strt_glitch<=1'b0;	
   	    end

    end
   else
    begin
		strt_glitch<=1'b0;
    end
  end
endmodule

