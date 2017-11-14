module MuxLoad(clk, reset_,LDControl,LDUart,digC0,digC1,digC2,digC3,digU0,digU1,digU2,digU3,o_dig0,o_dig1,o_dig2,o_dig3,o_load);


input clk;
input reset_;
input LDControl;
input LDUart;
input [3:0] digC0;
input [3:0] digC1;
input [3:0] digC2;
input [3:0] digC3;
input [3:0] digU0;
input [3:0] digU1;
input [3:0] digU2;
input [3:0] digU3;

// ** Iesiri

output [3:0] o_dig0;
output [3:0] o_dig1;
output [3:0] o_dig2;
output [3:0] o_dig3;
output       o_load;

reg [3:0] Ro_dig0_ff, Ro_dig0_nxt;
reg [3:0] Ro_dig1_ff, Ro_dig1_nxt;
reg [3:0] Ro_dig2_ff, Ro_dig2_nxt;
reg [3:0] Ro_dig3_ff, Ro_dig3_nxt;
reg       load_nxt, load_ff;


always@(*)
	begin
		case({LDControl,LDUart})
			2'b01:
				begin
					Ro_dig0_nxt = digU0;
					Ro_dig1_nxt = digU1;
					Ro_dig2_nxt = digU2;
					Ro_dig3_nxt = digU3;	
					load_nxt    = LDUart;
				end
				
			2'b10:
				begin
					Ro_dig0_nxt = digC0;
					Ro_dig1_nxt = digC1;
					Ro_dig2_nxt = digC2;
					Ro_dig3_nxt = digC3;
					load_nxt    = LDControl;
				end
				
			2'b11:
				begin
					Ro_dig0_nxt = digC0;
					Ro_dig1_nxt = digC1;
					Ro_dig2_nxt = digC2;
					Ro_dig3_nxt = digC3;
					load_nxt    = LDControl;
				end
			
			default:
				begin
					Ro_dig0_nxt = 1'b0;
					Ro_dig1_nxt = 1'b0;
					Ro_dig2_nxt = 1'b0;
					Ro_dig3_nxt = 1'b0;	
					load_nxt    = 1'b0;
				end
		endcase
	end

always @(posedge clk or negedge reset_)
	begin
		if(~reset_)
			begin
				Ro_dig0_ff <= 3'b0;
				Ro_dig1_ff <= 3'b0;
				Ro_dig2_ff <= 3'b0;
				Ro_dig3_ff <= 3'b0;
				load_ff <= 1'b0;
			end
		else
			begin
			Ro_dig0_ff <= Ro_dig0_nxt;
			Ro_dig1_ff <= Ro_dig1_nxt;
			Ro_dig2_ff <= Ro_dig2_nxt;
			Ro_dig3_ff <= Ro_dig3_nxt;
			load_ff <= load_nxt;
			end
	end

assign o_dig0 = Ro_dig0_ff;	
assign o_dig1 = Ro_dig1_ff;	
assign o_dig2 = Ro_dig2_ff;	
assign o_dig3 = Ro_dig3_ff;
assign o_load = load_ff;	
	
	
endmodule