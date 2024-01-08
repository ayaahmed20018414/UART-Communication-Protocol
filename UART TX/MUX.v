module MUX (input wire [1:0] MUX_Sel,
input  wire Start_bit,
input  wire CLK,
input  wire RST,
input  wire Ser_Data,
input  wire Stop_bit,
input  wire PAR_bit,
output reg TX_out);
 always@(posedge CLK or negedge RST)
 begin
 TX_out<=1'b1;
  if(!RST)
   begin
	TX_out<=1'b1;
   end	
  else
   begin
    case(MUX_Sel)
   	2'b00:begin
		TX_out<=Start_bit;
	      end
  	 2'b01:begin
		TX_out<=Ser_Data;
	       end
   	2'b10:begin
		TX_out<=PAR_bit;
              end
   	2'b11:begin
		TX_out<=Stop_bit;
	      end		
   
    endcase
   end
 end















endmodule
