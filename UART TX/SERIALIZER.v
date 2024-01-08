module SERIALIZER#(parameter DATA_WIDTH=8)
(input wire [DATA_WIDTH-1:0] P_DATA,
input  wire Ser_En,
input  wire CLK,
input  wire RST,
output reg  Ser_Data,
output reg  Ser_Done);
 
 integer  Count=0; 
 always @(posedge CLK or negedge RST)
 begin		
	Ser_Data<=1'b1;
	Ser_Done<=1'b0;
 	if(!RST)
	 begin
		Ser_Data<=1'b1;
		Ser_Done<=1'b0;
	 end
	else if(Ser_En)
	 begin
		if(Count ==DATA_WIDTH-1)
		 begin
			 Ser_Data<=P_DATA[Count];
			 Ser_Done<=1;
			 Count<=0;
		 end
		else
		 begin
			 Ser_Data<=P_DATA[Count];
			 Ser_Done<=0;
			 Count<=Count+1;
		 end
	 end
 end 
endmodule 
