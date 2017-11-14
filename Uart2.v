`define ceasAlarma 2
`define setOraC 3
`define setMinC 4
`define setOraA 5
`define setMinA 6
`define Error 7
`define Program1 8
`define Program2 9 

module Uart2(clk,bite,use_byte,reset_,Ora,Minute,LD1,LD2,LED1,LED2);

// ----------- Input ------
input clk;
input [7:0] bite;
input use_byte;
input reset_;

// ----------- Output ------
output [4:0] Ora;
output [5:0] Minute;

output LD1;
output LD2;
output LED1;
output LED2;

// --------- Variabile interne ---

reg [3:0] state_ff, state_next;
reg [3:0] zeroDig_ff, zeroDig_next, unuDig_ff, unuDig_next, treiDig_ff, treiDig_next, doiDig_ff, doiDig_next;
reg [1:0] led1_ff, led1_next, led2_ff, led2_next, load1_ff, load1_next, load2_ff, load2_next;
reg [7:0] cOra_ff, cOra_next, aOra_ff, aOra_next;
reg [7:0] cMin_ff, cMin_next, aMin_ff, aMin_next;
reg [16:0] numEroare_ff, numEroare_next; // 16
reg [15:0] numLed_ff, numLed_next; // 15
reg [4:0] ore_ff, ore_nxt;
reg [5:0] min_ff, min_nxt;

assign Ora = ore_ff;
assign Minute = min_ff;
assign LD1 = load1_ff;
assign LD2 = load2_ff;
assign LED1 = led1_ff;
assign LED2 = led2_ff;


// -------- Proces combinational, pregatim starea de NEXT

always @*
	begin
		state_next = state_ff;
		numLed_next = numLed_ff;
		numEroare_next = numEroare_ff;
		zeroDig_next = zeroDig_ff;
		unuDig_next = unuDig_ff;
		doiDig_next = doiDig_ff;
		treiDig_next = treiDig_ff;
		led1_next = led1_ff;
		led2_next = led2_ff;
		load1_next = load1_ff;
		load2_next = load2_ff;
		aMin_next = aMin_ff;
		aOra_next = aOra_ff;
		cOra_next = cOra_ff;
		cMin_next = cMin_ff;
		ore_nxt = ore_ff;
		min_nxt = min_ff;
	
	case(state_ff)
		

			
		`ceasAlarma:
		begin
			if(numLed_ff == 16'b10010110000000000) // 16'b10010110000000000
				begin
					led1_next = 1'b0;
					led2_next = 1'b0;
					numLed_next = 16'b0; // 16
				end
			else
				begin
					numLed_next = numLed_ff + 1;
				end
				
		load1_next = 0;
		load2_next = 0;		
			if(use_byte==1'b1)
				begin
					if(bite==1'b1)
						begin
							state_next = `setOraC;
						end
					else 
						begin
							if(bite==2'b10)
								begin
									state_next = `setOraA;
								end
							else
								begin
									state_next = `Error;
								end
						end
				numLed_next = 16'b0;	// 16
				end
				
		end
		
		`setOraC:
			begin
				if(use_byte==1'b1)
					begin
						if(bite <= 5'b10111) // 23 ore
							begin
								cOra_next = bite;		
								state_next = `setMinC;
							end
						else
							begin
								state_next = `Error;
							end
					end
									
			end
			
		`setMinC:
			begin
				if(use_byte==1'b1)
					begin
						if(bite <= 6'b111011) // 59 minute
							begin
								cMin_next = bite; 
								state_next = `Program1;
							end
						else
							begin
								state_next = `Error;
							end
					end
			end
			
		`setOraA:
			begin
				if(use_byte == 1'b1)
					begin
						if(bite <= 5'b10111) // 23 ore
							begin
								aOra_next = bite; 
								state_next = `setMinA;
							end
						else
							begin
								state_next = `Error;
							end							
					end
			
			
			end
			
		`setMinA:
		
			begin
				if(use_byte == 1'b1)
					begin
						
						if(bite <= 6'b111011) // 59 min
							begin
								aMin_next = bite;   // bite pe 8 biti iar  cOra pe 4 biti ???
								state_next = `Program2;
							end
						else
							begin
								state_next = `Error;
							end
					end
			end	
		
			
			
		`Error:
			begin
				if(numEroare_ff == 17'b100101100000000000) ///  100 ns?  17'b100101100000000000   7'b1100100
					begin
						state_next = `ceasAlarma;
					end
				else
					begin
						numEroare_next = numEroare_ff + 1;
						led1_next = 1'b1;
						led2_next = 1'b0;
					end			
			end
			
		`Program1:
			begin
				
				min_nxt = cMin_ff;
				ore_nxt = cOra_ff;
				
						
				
				
				led1_next = 1'b1;
				led2_next = 1'b1;
				
				load1_next = 1'b1;
				state_next = `ceasAlarma;
			
			end
			
		`Program2:
			begin
				
				
				min_nxt = aMin_ff;
				ore_nxt = aOra_ff;
			
				
				led1_next = 1'b1;
				led2_next = 1'b1;
				
				load2_next = 1'b1;
				state_next = `ceasAlarma;
			
			end
			
		
	
	
	
	endcase
	
end




// ---- process clock ----
always @(posedge clk or negedge reset_)
	begin
	if(~reset_)
		begin
		state_ff <= `ceasAlarma;
		numLed_ff <= 0;
		numEroare_ff <= 0;
		zeroDig_ff <= 0;
		unuDig_ff <= 0;
		doiDig_ff <= 0;
		treiDig_ff <= 0;
		led1_ff <= 0;
		led2_ff <= 0;
		load1_ff <= 0;
		load2_ff <= 0;
		aMin_ff <= 0;
		aOra_ff <= 0;
		cOra_ff <= 0;
		cMin_ff <= 0;	
		min_ff <= 0;
		ore_ff <= 0;
		end
	else
		begin
		state_ff <= state_next;
		numLed_ff <= numLed_next;
		numEroare_ff <= numEroare_next;
		zeroDig_ff <= zeroDig_next;
		unuDig_ff <= unuDig_next;
		doiDig_ff <= doiDig_next;
		treiDig_ff <= treiDig_next;
		led1_ff <= led1_next;
		led2_ff <= led2_next;
		load1_ff <= load1_next;
		load2_ff <= load2_next;
		aMin_ff <= aMin_next;
		aOra_ff <= aOra_next;
		cOra_ff <= cOra_next;
		cMin_ff <= cMin_next;
		min_ff <= min_nxt;
		ore_ff <= ore_nxt;
		
		end
	
	
	
	end




endmodule