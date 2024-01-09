module UART_RX_FSM #(parameter DATA_WIDTH=8,PRESCALE_BITS=5,TX_BITS=4)(
input  wire RX_IN,
input  wire [TX_BITS-1:0] bit_cnt,
input  wire [PRESCALE_BITS-1:0] edge_cnt,
input  wire [PRESCALE_BITS-1:0] Prescale,
input  wire PAR_EN,
input  wire par_err,
input  wire strt_glitch,
input  wire stp_err,
input  wire CLK,
input  wire RST,
output reg  data_samp_en,
output reg  enable,
output reg  strt_chk_en, 
output reg  par_chk_en,
output reg  stp_chk_en,
output reg  deser_en,
output reg  DATA_VALID);
 reg [2:0] Present_state,next_state;
 localparam S0=3'b000,            //Ideal State
            S1=3'b001,           //Start bit State 
	    S2=3'b010,          //Serial Data State
	    S3=3'b011,         //Parity bit state
	    S4=3'b100,        //Stop bit State
	    S5=3'b101,       //ERROR check state
	    S6=3'b110;      //valid state
	    
	    
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
   S0:begin           //IDLE state
       if(!RX_IN)
        begin
	next_state=S1;	
        end 
       else
        begin
	next_state=S0;	
        end
      end
   S1:begin
	if(strt_glitch)  //start state
	 begin
		next_state=S0;
	 end
	else if(bit_cnt=='d0 && edge_cnt==Prescale-1)
	 begin
		next_state=S2;
	 end
	else
	 begin
		next_state=S1;		
	 end
       end
   S2:begin  //data state
       if(bit_cnt!=DATA_WIDTH)
	begin
        	next_state=S2;
        end
       else if(bit_cnt==DATA_WIDTH && edge_cnt==Prescale-1)
	begin
	 if(PAR_EN==1'b1)
	  begin
        	next_state=S3;
	   end
	  else
	   begin
        	next_state=S4;
           end	
	  end
       end 
   S3:begin  //parity state
	if(bit_cnt==DATA_WIDTH+'d1 && edge_cnt==Prescale-1)
	 begin
        	next_state=S4;
	 end
	else
	 begin
		next_state=S3;
	 end

      end
   S4:begin  //stop state
       if(bit_cnt==DATA_WIDTH+'d2 || bit_cnt==DATA_WIDTH+'d1 && edge_cnt==Prescale-1)
        begin
	next_state=S5;	
        end 
       else
        begin
	next_state=S4;	
        end	
       end
   S5:begin
	if(par_err | stp_err)
	 begin
		next_state=S0;
	 end
	else
	 begin
		next_state=S6;
	 end
      end
   S6:begin
	if(!RX_IN)
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
  data_samp_en=1'b0;
  enable=1'b0;
  strt_chk_en=1'b0; 
  par_chk_en=1'b0;
  stp_chk_en=1'b0;
  deser_en=1'b0;
  DATA_VALID=1'b0;
  case (Present_state)
  S0:begin
     if(!RX_IN)
      begin
     	data_samp_en=1'b1;
     	enable=1'b1;
     	strt_chk_en=1'b1; 
      end
     else
      begin
	data_samp_en=1'b0;
  	enable=1'b0;
  	strt_chk_en=1'b0; 
      end
     end 
  S1:begin
     data_samp_en=1'b1;
     enable=1'b1; 
     strt_chk_en=1'b1;     
     end 
  S2:begin
     data_samp_en=1'b1;
     enable=1'b1;   
     deser_en=1'b1;
     end
  S3:begin
     data_samp_en=1'b1;
     enable=1'b1;   
     par_chk_en=1'b1;
     end 
  S4:begin
     data_samp_en=1'b1;
     enable=1'b1;   
     stp_chk_en=1'b1;
     end
  S5:begin
     data_samp_en=1'b1;
     end
  S6:begin
     DATA_VALID=1'b1;
     enable=1'b1; 
     end
  default:begin
  	  data_samp_en=1'b0;
  	  enable=1'b0;
  	  strt_chk_en=1'b0; 
  	  par_chk_en=1'b0;
  	  stp_chk_en=1'b0;
  	  deser_en=1'b0;
  	  DATA_VALID=1'b0;
     end  
 endcase
 end


endmodule 
