`define Idle 1
`define Suna 2
`define Taci 3
`define Numara 5
`define Asteapta 4


module AlarmaBuzzer(clk,reset_,STOP,Snooze,Trigger,buzz,feedback);

input clk;
input reset_;
input STOP;
input Snooze;
input Trigger;

output buzz;
output feedback;

reg [3:0] nrTaci_ff, nrTaci_next,state_ff, state_next;
reg buzz_ff, buzz_next, feed_ff, feed_next, triggNr_ff, triggNr_next;
reg [12:0] nrFeed_ff, nrFeed_next;  // 12
reg [2:0] stare_next, stare_ff;

assign feedback = feed_ff;
assign buzz = buzz_ff;


always @(*)
	begin
	stare_next = stare_ff;
	nrFeed_next = nrFeed_ff;
	feed_next = feed_ff;
		
		case(stare_ff)
		
	`Asteapta:
		begin
		nrFeed_next= 12'b0;
		feed_next = 1'b0;
		 if(triggNr_ff==1'b1)
			begin
				stare_next = `Numara;
				feed_next=1'b1;
			end
		end
	`Numara:
		begin
			feed_next = 1'b1;
			nrFeed_next = nrFeed_ff + 1'b1;
			if(nrFeed_ff == 13'b1011101110000) // numara 1 minut, atat sunt digitii egali 13'b1011101110000
				begin
					stare_next = `Asteapta;
					feed_next = 1'b0;
				end
		end

	endcase			
end

// proces combinational
always@(*)
	begin
		state_next = state_ff;
		nrTaci_next = nrTaci_ff;
		buzz_next = buzz_ff;
		
		
		triggNr_next = triggNr_ff;
	

case(state_ff)
		`Idle:
			begin
			nrTaci_next = 4'b0;
				if(Trigger)
					begin
						state_next = `Suna;
						triggNr_next = 1'b1;
					end
			end
		`Suna:
			begin
				triggNr_next = 1'b0;
				nrTaci_next = 4'b0;
				buzz_next = 1'b1;
					if(Snooze)
						begin
							state_next = `Taci;
						end
					if(STOP)
						begin
							buzz_next = 1'b0;
							state_next = `Idle;
						end	
			end
		`Taci:
			begin
				nrTaci_next = nrTaci_ff + 1'b1;
				buzz_next = 1'b0;
				if(nrTaci_ff == 14'b10011100010000) // 14'b10011100010000 10 secunde
					begin
						state_next=`Suna;
					end
				if(STOP == 1'b1)
					begin
						state_next = `Idle;
					end
			end
	
	
	
	endcase

end





// -------- proces de CLK ----------
always @(posedge clk or negedge reset_)
	begin
		if(~reset_)
			begin
			stare_ff <= `Asteapta;
			state_ff <= `Idle;
			nrTaci_ff <= 0;
			buzz_ff <= 0;
			feed_ff <=0;
			nrFeed_ff <= 0;
			triggNr_ff <= 0;
			end
		else
			begin
			stare_ff <= stare_next;
			state_ff <= state_next;
			nrTaci_ff <= nrTaci_next;
			buzz_ff <= buzz_next;
			feed_ff <= feed_next;
			nrFeed_ff <= nrFeed_next;
			triggNr_ff <= triggNr_next;
			
			end
	
	end
	
endmodule