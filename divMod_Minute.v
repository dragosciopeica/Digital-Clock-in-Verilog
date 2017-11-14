module divMod(clk,reset_,digMinut,dig0,dig1);



//------------input signals-------------
input clk;
input reset_;

input [5:0]digMinut;

//------------ouput signals-------------
output [3:0]dig0;
output [3:0]dig1;


reg [3:0] dig00_ff, dig00_nxt;
reg [3:0] dig11_ff, dig11_nxt;



assign dig0=dig00_ff;
assign dig1=dig11_ff;




always @(*)  
	begin
	 dig00_nxt = dig00_ff;
	 dig11_nxt = dig11_ff;



	 
	 if(digMinut <= 9) //  | digOra <= 9
		begin
			dig00_nxt = digMinut;
			dig11_nxt = 0;
		end
			else
				if((10 <= digMinut) & (digMinut <= 19)) // | 10 <= digOra <= 19
					begin
						dig00_nxt = digMinut - 10;
						dig11_nxt = 1;
					end
					else
						if ((20 <= digMinut) & (digMinut <= 29)) //  | 20 <= digOra <= 29 
							begin
								dig00_nxt = digMinut - 20;
								dig11_nxt = 2;
							end
						else
							if ((30 <= digMinut) & (digMinut <= 39))
								begin
									dig11_nxt = 3;
									dig00_nxt = digMinut - 30;
								end
							else
								if ((40 <= digMinut) & (digMinut <= 49))
									begin
										dig11_nxt = 4;
										dig00_nxt = digMinut - 40;
									end
								else
									if ((50 <= digMinut) & (digMinut <= 59))
										begin
											dig11_nxt = 5;
											dig00_nxt = digMinut - 50;
										end
						
	 
	 
	 

	
	end
		

always@(posedge clk or negedge reset_)
	begin
		if(~reset_)
			begin
				dig00_ff <= 4'b0;
				dig11_ff <= 4'b0;
			
			end
		else
			begin
				dig00_ff <= dig00_nxt;
			    dig11_ff <= dig11_nxt;
			   
			end
	
	end



endmodule

