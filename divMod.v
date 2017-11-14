module divMod(clk,reset_,digOra,digMinut,dig0,dig1,dig2,dig3);



//------------input signals-------------
input clk;
input reset_;
input [4:0]digOra;
input [5:0]digMinut;

//------------ouput signals-------------
output [3:0]dig0;
output [3:0]dig1;
output [3:0]dig2;
output [3:0]dig3;

reg [3:0] dig00_ff, dig00_nxt;
reg [3:0] dig11_ff, dig11_nxt;
reg [3:0] dig22_ff, dig22_nxt;
reg [3:0] dig33_ff, dig33_nxt;


assign dig0=dig00_ff;
assign dig1=dig11_ff;
assign dig2=dig22_ff;
assign dig3=dig33_ff;



always @(*)  
	begin
	 dig00_nxt = dig00_ff;
	 dig11_nxt = dig11_ff;
	 dig22_nxt = dig22_ff;
	 dig33_nxt = dig33_ff;


		dig00_nxt = digMinut % 10;
		dig11_nxt = digMinut / 10;
		dig22_nxt = digOra % 10;
		dig33_nxt = digOra / 10;
	end
		

always@(posedge clk or negedge reset_)
	begin
		if(~reset_)
			begin
				dig00_ff <= 4'b0;
				dig11_ff <= 4'b0;
				dig22_ff <= 4'b0;
				dig33_ff <= 4'b0;
			end
		else
			begin
				dig00_ff <= dig00_nxt;
			    dig11_ff <= dig11_nxt;
			    dig22_ff <= dig22_nxt;
			    dig33_ff <= dig33_nxt;
			end
	
	end



endmodule

