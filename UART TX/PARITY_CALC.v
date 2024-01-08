module Parity_Clac #(parameter DATA_WIDTH=8)
(input  wire [DATA_WIDTH-1:0] P_DATA,
 input  wire Parity_En,
 input  wire CLK,
 input  wire RST,
 input  wire Data_Valid, 
 input  wire PAR_TYP,
 output reg  Par_bit);

always @(posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
	Par_bit<=0;
   end 
   else if (Parity_En && Data_Valid)
    begin
	case (PAR_TYP)
	 1'b0:
	  begin
		Par_bit<=^P_DATA;//even parity
	  end
	 1'b1:
	  begin
		Par_bit<=~^P_DATA;//odd parity
	  end
        endcase
    end
   else
    begin
	Par_bit<=1'b0;
    end
	 
 end 
endmodule 
