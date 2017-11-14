module Mux(clk, reset_,sel,dig0,dig1,dig2,dig3,digB0,digB1,digB2,digB3,o_dig0,o_dig1,o_dig2,o_dig3);


// ***** Intrari
input clk;
input reset_;
input sel;
input [3:0] dig0;
input [3:0] dig1;
input [3:0] dig2;
input [3:0] dig3;
input [3:0] digB0;
input [3:0] digB1;
input [3:0] digB2;
input [3:0] digB3;

// ** Iesiri

output [3:0] o_dig0;
output [3:0] o_dig1;
output [3:0] o_dig2;
output [3:0] o_dig3;


reg [3:0] r_dig0_ff, r_dig0_nxt;
reg [3:0] r_dig1_ff, r_dig1_nxt;
reg [3:0] r_dig2_ff, r_dig2_nxt;
reg [3:0] r_dig3_ff, r_dig3_nxt;


assign o_dig0 = r_dig0_ff;
assign o_dig1 = r_dig1_ff;
assign o_dig2 = r_dig2_ff;
assign o_dig3 = r_dig3_ff;


always@(*)
	begin
		r_dig0_nxt = r_dig0_ff;
	    r_dig1_nxt = r_dig1_ff;
	    r_dig2_nxt = r_dig2_ff;
	    r_dig3_nxt = r_dig3_ff;
		
		if(sel)
			begin
				r_dig0_nxt = digB0;
			    r_dig1_nxt = digB1;
			    r_dig2_nxt = digB2;
			    r_dig3_nxt = digB3;
			end
			
		else
			begin
				r_dig0_nxt = dig0;
			    r_dig1_nxt = dig1;
			    r_dig2_nxt = dig2;
			    r_dig3_nxt = dig3;
			
			
			end
		
	end
	
always@(posedge clk or negedge reset_)
	begin
		if(~reset_)
			begin
				r_dig0_ff <= 4'b0;
			    r_dig1_ff <= 4'b0;
			    r_dig2_ff <= 4'b0;
			    r_dig3_ff <= 4'b0;
			end
		else
			begin
				r_dig0_ff <= r_dig0_nxt;
			    r_dig1_ff <= r_dig1_nxt;
			    r_dig2_ff <= r_dig2_nxt;
			    r_dig3_ff <= r_dig3_nxt;
			end
	end






endmodule