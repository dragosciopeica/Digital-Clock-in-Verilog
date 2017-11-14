module Mux2(clk, reset_, sel,In1,In2,Out);

input clk;
input reset_;
input sel;
input In1, In2;
output Out;




reg iesire_ff, iesire_nxt;

assign Out = iesire_ff;


always @(*)
	begin
		iesire_nxt = iesire_ff;
	
		if(sel==1'b1)
			begin
				iesire_nxt = In1;
			end
		if(sel == 1'b0)
			begin
				iesire_nxt = In2;
			end
	end
	
always@(posedge clk or negedge reset_)
	begin
		if(~reset_)
			begin
				iesire_ff <= 0;
			end
		else
			begin
				iesire_ff <= iesire_nxt;
			end
	end



endmodule