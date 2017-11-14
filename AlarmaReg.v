module AlarmaReg(clk, reset_,Dig0,Dig1,Dig2,Dig3,LD,Dig00,Dig11,Dig22,Dig33);

input clk;
input reset_;
input [3:0] Dig0;
input [3:0] Dig1;
input [3:0] Dig2;
input [3:0] Dig3;
input LD;

output [3:0] Dig00;
output [3:0] Dig11;
output [3:0] Dig22;
output [3:0] Dig33;

reg [3:0] Diig00_ff, Diig00_nxt;
reg [3:0] Diig11_ff, Diig11_nxt;
reg [3:0] Diig22_ff, Diig22_nxt;
reg [3:0] Diig33_ff, Diig33_nxt;


assign Dig00 = Diig00_ff;
assign Dig11 = Diig11_ff;
assign Dig22 = Diig22_ff;
assign Dig33 = Diig33_ff;

always @(*)
	begin
	
	Diig00_nxt = Diig00_ff;
	Diig11_nxt = Diig11_ff;
	Diig22_nxt = Diig22_ff;
	Diig33_nxt = Diig33_ff;
	
		if(LD)
			begin
				Diig00_nxt = Dig0;
				Diig11_nxt = Dig1;
				Diig22_nxt = Dig2;
				Diig33_nxt = Dig3;
			end
		else
			begin
			Diig00_nxt = 4'b0;
			Diig11_nxt = 4'b0;
			Diig22_nxt = 4'b0;
			Diig33_nxt = 4'b0;
			
			end
	end

always@(posedge clk or negedge reset_)
	begin
		if(~reset_)
			begin
				Diig00_ff <= 4'b0;
				Diig11_ff <= 4'b0;
				Diig22_ff <= 4'b0;
				Diig33_ff <= 4'b0;
			end
		else
			begin
			Diig00_ff <= Diig00_nxt;
			Diig11_ff <= Diig11_nxt;
			Diig22_ff <= Diig22_nxt;
			Diig33_ff <= Diig33_nxt;
			end
	end



endmodule