module AlarmaComp(clk,reset_,Dig0,Dig1,Dig2,Dig3,DigN0,DigN1,DigN2,DigN3,feedback,EN,Trigger);

input clk;
input reset_;
input [3:0] Dig0;
input [3:0] Dig1;
input [3:0] Dig2;
input [3:0] Dig3;
input [3:0] DigN0;
input [3:0] DigN1;
input [3:0] DigN2;
input [3:0] DigN3;
input feedback;
input EN;

output Trigger;

reg Trig_ff, Trig_nxt;

assign Trigger = Trig_ff;

always@(*)
	begin
	Trig_nxt = Trig_ff;
		if(EN)
			begin
				if(Dig0==DigN0 && Dig1==DigN1 & Dig1==DigN1 & Dig1==DigN1 && feedback==1'b0) //  
					begin		
						Trig_nxt = 1'b1;
					end
				else
					begin
						Trig_nxt = 1'b0;
					end	
			end
	end


always@(posedge clk or negedge reset_)
	begin
		if(~reset_)
			begin
				Trig_ff <= 1'b0;
			end
		else
			begin
				Trig_ff <= Trig_nxt;
			end
	end
	

endmodule

	