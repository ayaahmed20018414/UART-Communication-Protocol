module UART_FSM(input wire Data_Valid,
input  wire Ser_Done,
input  wire Parity_En,
input  wire CLK,
input  wire RST,
output reg [1:0] MUX_Sel,
output reg busy,
output reg Ser_EN);
reg [2:0] Present_state,next_state;
localparam S0=3'b000,            //Ideal State
           S1=3'b001,           //Start bit State 
	   S2=3'b010,          //Serial Data State
	   S3=3'b011,         //Parity bit state
	   S4=3'b100;        //Stop bit State
always @(posedge CLK or negedge RST)
 begin
	if(!RST)
 	 begin
		Present_state<=S0;
	 end
	else
	 begin
		Present_state<=next_state;
	 end
 end 
always @(*)
 begin 
 case(Present_state)
   S0:begin
       if(Data_Valid)
        begin
	next_state=S1;	
        end 
       else
        begin
	next_state=S0;	
        end
      end
   S1:begin
	next_state=S2;
       end
   S2:begin
       if(!Ser_Done)
	begin
        	next_state=S2;
        end
       else if(Parity_En)
	begin
        	next_state=S3;
        end
       else
	begin
        	next_state=S4;
        end	
       end 
   S3:begin
        next_state=S4;
      end
   S4:begin
       if(Data_Valid)
        begin
	next_state=S1;	
        end 
       else
        begin
	next_state=S0;	
        end	
       end 
   default:begin
	next_state=S0;        
	   end
endcase
 end
always @(*)
 begin
  MUX_Sel=2'b01; 
  busy=1'b0;
  Ser_EN=1'b0;
 case (Present_state)
  S0:begin
     MUX_Sel=2'b01; 
     busy=1'b0;
     Ser_EN=1'b0;
     end 
  S1:begin
     MUX_Sel=2'b00; 
     busy=1'b1;
     Ser_EN=1'b1;
     end 
  S2:begin
     MUX_Sel=2'b01; 
     busy=1'b1;
     Ser_EN=1'b1;
     if(Ser_Done)
	begin
		Ser_EN=1'b0;
	end
     else
	begin
		Ser_EN=1'b1;
	end
     end
  S3:begin
     MUX_Sel=2'b10; 
     busy=1'b1;
     Ser_EN=1'b0;
      end 
  S4:begin
     MUX_Sel=2'b11; 
     busy=1'b1;
     Ser_EN=1'b0;
     end 
  default:begin
     MUX_Sel=2'b01; 
     busy=1'b0;
     Ser_EN=1'b0;
     end  
 endcase
 end
endmodule 
