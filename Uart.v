`define idle 0	// s-ar putea sa trebuiasca define
`define trstart 1
`define esantionare  2
`define formare_bit 3
`define error 4

module Uart(clk,buss,reset_,bite,use_byte);

// --- Inputs and Outputs
input clk;
input buss;
input reset_;
output [7:0] bite;
output use_byte;



// --- local parameters ---


reg [1:0] bitt_ff, bitt_next;
reg [2:0] state_ff, state_next,c_ff,c_next,c0_ff,c0_next,c1_ff,c1_next;
reg [3:0] bitNr_ff, bitNr_next;
reg [7:0] variabila_ff, variabila_next;
reg byte_ff, byte_next;
reg [6:0] CE_ff, CE_next;

assign bite = variabila_ff;	// aici vei avea date tot timpul
assign use_byte = byte_ff;	// asta iti zice cand poti sa foloses datele 

always @*
	begin
	state_next = state_ff;
	c_next = c_ff;
	variabila_next = variabila_ff;
	bitt_next = bitt_ff;
	c0_next = c0_ff;
	c1_next = c1_ff;
	CE_next = CE_ff;
	byte_next = byte_ff;
	bitNr_next = bitNr_ff;
	
	case(state_ff)
		`idle :
			begin
			byte_next = 1'b0;    // use_byte dureaza un CLK!
			if(~buss)
				begin
					state_next = `trstart;
					variabila_next = 8'b0;	// datele raman la iesire pana vine alta transmisie
					
				end
			end
		`trstart:
			if(c_ff==3'b111)
				begin
					state_next = `esantionare;
					c_next = 3'b000;
				end
			else 
				begin
					c_next = c_ff + 1'b1;
				end
		`esantionare:
			begin
				c_next = c_ff + 1'b1;
				if(c_ff == 3'b110)
					begin
						state_next = `formare_bit;
						c_next = 3'b000;				
					end
				else
					begin
					if( (3'b010 <= c_ff) & ( c_ff <= 3'b101) )
						begin
							if(buss == 1'b0)
								begin
									c0_next = c0_ff + 1;						
								end
							else
								begin
									c1_next = c1_ff + 1;
								end		
						end
					end
			end
		`formare_bit:
		
			begin
			bitNr_next = bitNr_ff + 4'b0001;
			if(c0_ff > c1_ff)
				begin // nu facem update la variabila_next pentru ca oricum e 0
					if(bitNr_ff > 4'b0111)	// daca bitul 8 sau 9 este 0 atunci ne mutam in error
						begin
							state_next = `error;
							bitNr_next = 4'b0000;
						end
					else
						begin
							state_next = `esantionare;
							c0_next = 3'b000;
							c1_next = 3'b000;
						end	
				end
			else
				begin
					if(bitNr_ff == 4'b1001)
						begin
							state_next = `idle;
							bitNr_next = 4'b0;
							c0_next = 3'b000;
							c1_next = 3'b000;
							byte_next = 1'b1;
						end
					else
						begin
							if (bitNr_ff < 4'b1000)
								begin
									variabila_next = 1'b1 << (bitNr_ff) | variabila_ff; // pui un 1 la locatia pentru bitNr variabila_next[bitNr] = 1
								end
							c0_next = 3'b000;
							c1_next = 3'b000;
							state_next = `esantionare;
						end
							
				end
			end
		`error:	
			if(CE_ff== 14'b10011100010000) // ???????????? 10 secunde ( luat de la FSM ) 
				begin
					state_next <= `idle;
				end
			else
				begin
					CE_next = CE_ff + 1;
				end
	endcase


	end


// -- PROCESUL DE CLK ------------

always @(posedge clk or negedge reset_)
	begin
	if(~reset_)
		begin
		state_ff <= `idle;
		c_ff <=0;
		c0_ff <=0;
		c1_ff <= 0;
		variabila_ff <= 8'b0;
		CE_ff <= 0;
		bitt_ff <= 0;
		bitNr_ff <= 0;
		end
	else 
		begin
			state_ff <= state_next; 
			c_ff <= c_next; 
			c0_ff <= c0_next; 
			c1_ff <= c1_next;
			variabila_ff <= variabila_next;	
			byte_ff <= byte_next; 
			CE_ff <= CE_next;
			bitt_ff <= bitt_next;
			bitNr_ff <= bitNr_next;
		end

	end
	
endmodule