module divMod_O(clk,reset_,digOra,dig2,dig3);



//------------input signals-------------
input clk;
input reset_;

input [4:0]digOra;

//------------ouput signals-------------
output [3:0]dig2;
output [3:0]dig3;


reg [3:0] dig22_ff, dig22_nxt;
reg [3:0] dig33_ff, dig33_nxt;



assign dig2=dig22_ff;
assign dig3=dig33_ff;




always @(*)  
	begin
	dig22_nxt = dig22_ff;
	dig33_nxt = dig33_ff;
 
	if(digOra <= 9) //  | digOra <= 9
		begin
			dig22_nxt = digOra;
			dig33_nxt = 0;
		end
	else if((10 <= digOra) && (digOra <= 19)) // | 10 <= digOra <= 19
		begin
			dig22_nxt = digOra - 10;
			dig33_nxt = 1;
		end
	else if ((20 <= digOra) && (digOra <= 29)) //  | 20 <= digOra <= 29 
		begin
			dig22_nxt = digOra - 20;
			dig33_nxt = 2;
		end
	end
		

always@(posedge clk or negedge reset_)
	begin
		if(~reset_)
			begin
				dig22_ff <= 4'b0;
				dig33_ff <= 4'b0;
			
			end
		else
			begin
				dig22_ff <= dig22_nxt;
			    dig33_ff <= dig33_nxt;
			   
			end
	
	end



endmodule

