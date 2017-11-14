`define Idle 1
`define bS 2
`define bL 3
`define bR 4
`define bU 5
`define bD 6

`define Normal 8
`define PSaver 9
`define Program 10 // a
`define Asteapta 11 // b
`define Numara 12 // c
`define AsteaptaZ 13 //d 
`define NumaraZ 14 // e


module ControlFSM(clk,reset_,BTNS,BTNL,BTNR,BTNU,BTND,SW0,en_alarma,STOP,Snooze,LDceas,LDalarma,Ora,Minut,en_afisaj,palpaie)
input clk, reset_;
input BTNS, BTNL, BTNR, BTNU, BTND,SW0;

// ******* IESIRI ******


output en_alarma,STOP,Snooze;
output LDceas, LDalarma;
output [5:0] Minut;
output [4:0]Ora;   // iesiri??
output en_afisaj;
output palpaie;

// ******* Variabile interne

reg [3:0] state_ff, state_next;
reg [3:0] stare_ff, stare_next;
reg [11:0] s_ff, s_next, d_ff, d_next, l_ff, l_next, u_ff, u_next, r_ff, r_next; 
reg [12:0] nrProgram_ff, nrProgram_next;
reg [14:0] nrProgramZ_ff, nrProgramZ_next;
reg [3:0] NRstare_ff, NRstare_next, NRstareZ_ff, NRstareZ_next;
reg [4:0] nrOra_ff, nrOra_next;
reg [5:0] nrMin_ff, nrMin_next;
reg enable_next, enable_ff,STOP_next, STOP_ff, Snooze_ff, Snooze_next;
reg displClipA_ff, displClipA_next;

reg clkH_ff, clkH_next, clkM_ff, clkM_next;
reg modOn_next, modOn_ff, modOn_ff2, modEco_next, modEco_ff, displayClipC_next, displayClipC_ff;
reg semnalizare_ff, semnalizare_next;
reg en_afisaj_next, en_afisaj_ff;
reg triggEco_next, triggEco_ff;
reg palpaie_ff, palpaie_next;
reg [2:0] buton_ff, buton_next;
reg LDalarma_next, LDalarma_ff, LDceas_next, LDceas_ff;
reg semnalizare_nextZ, semnalizare_ffZ;
reg semnalOn_ff, semnalOn_next;


// ****** Inceput program

assign palpaie = palpaie_ff;
assign LDceas = LDceas_ff;
assign LDalarma = LDalarma_ff;
assign STOP = STOP_ff;
assign Snooze = Snooze_ff;
assign Ora = nrOra_ff;
assign Minut = nrMin_ff;
assign en_alarma = enable_ff;
assign en_afisaj = en_afisaj_ff;


// FSM Normal, Power, Program
always @(*)
	begin
	nrProgramZ_next = nrProgramZ_ff;
	nrProgram_next = nrProgram_ff;	
	//semnalizare_nextZ = semnalizare_ffZ;
	semnalizare_next = semnalizare_ff;
	stare_next = stare_ff;
	triggEco_next = triggEco_ff;
	palpaie_next = palpaie_ff;
	nrOra_next = nrOra_ff;
	nrMin_next = nrMin_ff;
	en_afisaj_next = en_afisaj_ff;
	buton_next = buton_ff;

	
		case(stare_ff)
			
			`Normal:
				begin
					en_afisaj_next = 1'b1;
					LDalarma_next = 1'b0;
					LDceas_next = 1'b0;
					semnalizare_next = 1'b0;
					nrProgramZ_next = 14'b0;
					
								
					if(triggEco_ff == 1'b1)
						begin
							if(nrProgramZ_ff == 10'b1111101000) // 10 secunde 14'b10011100010000
								begin
									stare_next = `PSaver;
									//semnalizare_nextZ = 1'b1; //si pune semnalul de semnalizare pe 1 !!!! IMPORTANT	
									en_afisaj_next = 1'b0;	
									triggEco_next = 1'b0;
									nrProgramZ_next = 14'b0;
									
								end
							else
								begin
									nrProgramZ_next = nrProgramZ_ff + 1;
								end
						end
					
					
					
					
					
				/*	if(semnalizare_ffZ == 1'b1)
						begin
							stare_next = `PSaver;
							semnalizare_nextZ = 1'b0;
							en_afisaj_next = 1'b0; // ???????? e pus si in PSaver, sa-l mai pun si aici?????????
						end
					*/
					
					if(semnalOn_ff == 1'b1) // Daca mai apasa odata pe BTNS > 3 secunde, intram in PSaver! 	
						begin
							stare_next = `PSaver;
							en_afisaj_next = 1'b0;
						
						end
					
// ****************************************************************************************************** 
					
	
							if(displClipA_ff == 1'b1)
							
								begin
									stare_next = `Program;
									en_afisaj_next = 1'b1;
									palpaie_next = 1'b1;  // semnalul de palpaie display/LED
									buton_next = 2'b10;
								end
							else
									if(displayClipC_ff == 1'b1)
										begin
											stare_next = `Program;
											en_afisaj_next = 1'b1;
											palpaie_next = 1'b1;
											buton_next = 1'b1;
										end
				end
				
			`PSaver:
				begin
					LDalarma_next = 1'b0;
					LDceas_next = 1'b0;
					en_afisaj_next = 1'b0; // nu trimit en la afisaj,  o iesire care e intrare in TOpafisaj, aici e pe 0, in Normal e pe 1
					if(modEco_ff == 1'b1)  // aici o sa am un if care asculta dupa modEco si cand asta e 1, intra in normal, ASTA VINE DE LA FSM cu butoane, BTNS
						begin
							en_afisaj_next = 1'b1;
							triggEco_next = 1'b1;
							stare_next = `Normal; 
							
							
							
							
						end
					if(displClipA_ff == 1'b1)
						begin
							stare_next = `Program;
							en_afisaj_next = 1'b1;
							palpaie_next = 1'b1;
							nrOra_next = 4'b0; // resetez valori countere ora, minut 
							nrMin_next = 5'b0; // resetez valori countere ora, minut 
							buton_next = 2'b10;   // starea 2, de la ALARMA  // o variabila care sa-mi spuna ce buton a fost apasat ( 1 ceas, 2 alarma)
						end 
						else
							if(displayClipC_ff == 1'b1)
								begin
									stare_next = `Program;
									en_afisaj_next = 1'b1;
									palpaie_next=1'b1;
								    nrOra_next = 4'b0; // resetez valori countere ora, minut 
									nrMin_next = 5'b0; // resetez valori countere ora, minut 
									buton_next = 1'b1;
								end
					if(semnalOn_ff == 1'b1) // in continuu aprins	
						begin
							stare_next = `Normal;
							en_afisaj_next = 1'b1;
						
						end
					
				end		
				

			`Program:
				begin   
										
					if(palpaie_ff == 1'b1)
						
						begin
								if(nrProgram_ff ==9'b111110100) // 5 secunde   13'b1001110001000
									
									begin
										semnalizare_next = 1'b1; //si pune semnalul de semnalizare pe 1 !!!! IMPORTANT	
										nrProgram_next = 13'b0;
									end
								
								else
								
									begin
									nrProgram_next = nrProgram_ff + 1;
									if(clkH_ff == 1'b1)  // semnal incrementare ora, venim de la Butoane
										begin
										nrProgram_next = 13'b0;   
											if(nrOra_ff >= 5'b10111)   // 23 
												begin
													nrOra_next = 5'b0;
												end
											else
												begin
													nrOra_next = nrOra_ff + 1;
												end
										
										end
										else 
											if(clkM_ff == 1'b1)
												begin
												nrProgram_next = 13'b0;  
													if(nrMin_ff >= 6'b111011) // 59
														begin
															nrMin_next = 6'b0;
														end
													else
														begin
															nrMin_next = nrMin_ff + 1;
														end
												
												end
									end
						end		
					if(semnalizare_ff == 1'b1)
						begin
							stare_next = `Normal;
							palpaie_next = 1'b0;
							if(buton_ff == 1'b1)
								begin
									LDceas_next = 1'b1;
								end
							else
								begin
									LDalarma_next = 1'b1;
								end
										
								
						end		
						
				end
				
		
		endcase
	
	end

always @(*)  // *********************** proces de formare semnalOn pe un CLK **********************
	begin
	semnalOn_next = semnalOn_ff;
	
		if (semnalOn_ff == 1'b1) 
			begin
				semnalOn_next = 1'b0;
			end
		else 
			begin
				if ((modOn_ff == 1'b1) && (modOn_ff != modOn_ff2))
					begin
						semnalOn_next = 1'b1;
					end
			end
	end
	
	
/*  ***************************** Varianta mea ****************************

	stareON_next = stareON_ff;
	semnalOn_next = semnalOn_ff;
	
	
	
	case(stareON_ff)
		`PrimaON:
			begin
				semnalOn_next = 1'b0;
				if(modOn_ff == 1'b1)
					begin
						stareON_next = `DoiON;
					end
			end
		`DoiON:
			begin
				semnalOn_next = 1'b1;
				stareON_next = `PrimaON;
			end
	
	
	endcase
	
	****************************** Varianta Dorin *********************************
	
	semnalOn_next = semnalOn_ff;
	
		if (semnalOn_ff == 1'b1) 
			begin
				semnalOn_next = 1'b0;
			end
		else 
			begin
				if ((modOn_ff == 1'b1) && (modOn_ff != modOn_ff2))
					begin
						semnalOn_next = 1'b1;
					end
			end
	
	
	
	
	*/


// FSM pentru semnale de comanda de la BUTOANE!!!

always @(*)
	begin
		state_next  = state_ff  ;
		s_next = s_ff;
		l_next = l_ff;
		r_next = r_ff;
		u_next = u_ff;
		d_next = d_ff;
		clkH_next = clkH_ff;
		clkM_next = clkM_ff;
		STOP_next = STOP_ff;
		Snooze_next = Snooze_ff;
		modOn_next = modOn_ff;
		modEco_next = modEco_ff;
		displayClipC_next = displayClipC_ff;
		displClipA_next = displClipA_ff;
		enable_next = enable_ff;
		
	case(state_ff)
		
		`Idle:
			begin
			modOn_next = 1'b0;
			modEco_next = 1'b0;
			displayClipC_next = 1'b0;
			displClipA_next = 1'b0;
			Snooze_next = 1'b0;
			STOP_next = 1'b0;
			clkH_next=1'b0;  // incrementare Ora numarator
			clkM_next=1'b0; // incrementare Min Numarator
			enable_next = SW0;
			
			
			
				if(BTNS)
					begin // ************** baga if else
						state_next = `bS;
					end
				else
					if(BTND)
						begin
							state_next = `bD;
						end
					else
						if(BTNU)
							begin
								state_next = `bU;
							end
						else
							if(BTNL)
								begin
									state_next = `bL;
								end
							else
								if(BTNR)
									begin
										state_next = `bR;
									end
							
				
			end
		
		`bS:
			begin
				if(BTNS)
					begin
						if(s_ff == 12'b111111111111)
							begin
								s_next = 12'b111111111111;
							end
						else
							begin
								s_next = s_ff + 1;
							end
					end
				if(s_ff >= 9'b100101100) // 3 secunde la un clk de 100ms 12'b101110111000
					begin
						modOn_next = 1'b1; 	// ora afisata incontinuu pe display, merge la NORMAL din 1FSM
						
						if(~BTNS)
							begin
								state_next = `Idle;
								s_next = 12'b0;
							end
					end
				else
					begin
						if(~BTNS) // dau drumul la buton
							begin
								modEco_next = 1'b1;  // ora afisata 10 secunde pe display, merge la PSaver din 1FSM
								state_next = `Idle;
								s_next = 12'b0;
							end
					end
			end
		
		`bL: // Asta merge, individual!!
			begin
				if(BTNL) // acum e apasat
					begin
						   if(l_ff == 12'b111111111111) // 12'b111111111111
							begin
								l_next = 12'b111111111111;
							end
						else
							begin
								l_next = l_ff + 1;
							end
					end
					if(l_ff >= 9'b100101100) // 3 secunde la un clk de 100ms 12'b101110111000
						begin
							displayClipC_next = 1'b1;  // display-ul palpaie, este pregatit pentru setare CEAS, mergem in Psaver din 1FMS????
							
							if(~BTNL)
								begin
									state_next = `Idle;
									l_next = 12'b0;
								end
						end
					else
						begin
							if(~BTNL)   // acum am lasat de buton
								begin
									clkH_next = 1'b1;     // incrementam Ora la alarma sau Ceas.
									state_next = `Idle;
									l_next = 12'b0;	
								end
						end 
			end
		
		`bR:  // Asta merge, individual!!
			begin
				if(BTNR)
				    begin
						if(r_ff == 12'b111111111111)
							begin
								r_next = 12'b111111111111;
							end
						else
							begin
								r_next = r_ff + 1;
							end
					end
				if(r_ff >= 9'b100101100) // 3 secunde la un clk de 100ms  101110111000
					begin
						displayClipC_next = 1'b1; // display-ul palpaie, este pregatit pentru setare CEAS
							
						if(~BTNR)
							begin
								state_next = `Idle;
								r_next = 4'b0;
							end
					end
				else
						if(~BTNR)
							begin
								clkM_next = 1'b1;    // incrementam MIN la alarma sau Ceas.
								state_next = `Idle;
								r_next = 12'b0;
							end
					
				
			end
			
		`bU: // Asta merge, individual si cu btnl si btnr.... la snooze e o problema
			begin
			   if(BTNU)
				begin
					if( u_ff == 12'b111111111111) // 12'b111111111111
						begin
							u_next = 12'b111111111111;
						end
					else
						begin
							u_next = u_ff + 1;
						end
				end
				if(u_ff >= 9'b100101100) // 3 secunde la un clk de 100ms 12'b101110111000
					begin
						displClipA_next = 1'b1;   // LED-ul palpaie, este pregatit pentru setare Alarma, SETARE ALARMA
						
						if(~BTNU)
							begin
								state_next = `Idle;
								u_next = 12'b0;
							end
					end
				else
					begin
						if(~BTNU)
							begin
								Snooze_next = 1'b1;   // Snooze alarma
								state_next = `Idle;
								u_next = 12'b0;
							end
					end	
			end
			
		`bD: // Merge ...
			begin
				if(BTND)
					begin
						if(d_ff == 12'b111111111111)
							begin
								d_next = 12'b111111111111;
							end
						else
							begin
								d_next = d_ff + 1;
							end
					end
				if(d_ff >= 9'b100101100) // 3 secunde la un clk de 100ms 12'b101110111000
					begin
						if(~BTND)
							begin
								d_next = 12'b0;
								state_next = `Idle;
							end
					 end
				else
					begin
						if(~BTND)
							begin
								STOP_next = 1'b1; 									// Opreste Alarma 
								state_next = `Idle;
								d_next = 12'b0;
							end
					end
			end
			
		
	
	
	endcase
	end
	
	
// proces clk
always @(posedge clk or negedge reset_)
	begin
		if(~reset_)
			begin
				NRstare_ff <= `Asteapta;
				state_ff <= `Idle;
				stare_ff <= `PSaver;  // NORMAL
				STOP_ff <= 0;
				Snooze_ff <= 0;
				enable_ff <= 0;
				s_ff <= 0;
				l_ff <= 0;
				r_ff <= 0;
				u_ff <= 0;
				d_ff <= 0;
				clkH_ff <= 0;
				clkM_ff <= 0;
				nrProgram_ff <= 0;
				modOn_ff <= 0;
				modOn_ff2 <= 0;
				modEco_ff <= 0;
				displayClipC_ff <= 0;
				displClipA_ff <= 0;
				palpaie_ff <= 0;
				nrOra_ff <= 0;
				nrMin_ff <= 0;
				semnalizare_ff <=0;
				semnalizare_ffZ <=0;
				en_afisaj_ff <=0;
				triggEco_ff <=0;
				buton_ff <=0;
				LDalarma_ff <=0;
				LDceas_ff <=0;
				NRstareZ_ff <= `AsteaptaZ;
				nrProgramZ_ff <= 0;
				semnalOn_ff <= 0;
				
			end
		else
			begin
				nrProgramZ_ff <= nrProgramZ_next;
				NRstareZ_ff <= NRstareZ_next;
				LDalarma_ff <= LDalarma_next;
				LDceas_ff <= LDceas_next;
				buton_ff <= buton_next;
				triggEco_ff <= triggEco_next;
				en_afisaj_ff <= en_afisaj_next;
				semnalizare_ff <= semnalizare_next;
				semnalizare_ffZ <= semnalizare_nextZ;
				nrOra_ff <= nrOra_next;
				nrMin_ff <= nrMin_next;
				palpaie_ff <= palpaie_next;
				NRstare_ff <= NRstare_next;
				stare_ff <= stare_next;
				STOP_ff <= STOP_next;
				Snooze_ff <= Snooze_next;
				state_ff <= state_next;
				enable_ff <= enable_next;
				clkH_ff <= clkH_next;
				clkM_ff <= clkM_next;
				s_ff <= s_next;
				l_ff <= l_next;
				r_ff <= r_next;
				u_ff <= u_next;
				d_ff <= d_next;
				nrProgram_ff <= nrProgram_next;
				modOn_ff <= modOn_next;
				modOn_ff2 <= modOn_ff; // intarziere de un tact!!!!!!!!!!!
				modEco_ff <= modEco_next;
				displClipA_ff <= displClipA_next;
				displayClipC_ff <= displayClipC_next;
				semnalOn_ff <= semnalOn_next;
			end
end
		endmodule

		
		
		
		
/*
******************* ARHIVA ******************


resetTotal_next = 1'b0; // ********** ??? ***********
						
						if(~BTND)
							begin
								d_next = 12'b0;
								state_next = `Idle;
							end
						


// FSM Numarator 10 secunde			

always @(*)
	begin
	nrProgramZ_next = nrProgramZ_ff;  // PROBLEMA next
	NRstareZ_next = NRstareZ_ff;
	semnalizare_nextZ = semnalizare_ffZ;  //  // PROBLEMA next
	
		case(NRstareZ_ff)
		
			`AsteaptaZ:
				begin
					semnalizare_nextZ = 1'b0;
					if(triggEco_ff == 1'b1)
						begin
							NRstareZ_next = `NumaraZ;
						end
					
				end
				
			`NumaraZ:
				begin
					nrProgramZ_next = nrProgramZ_ff + 1;
					if(nrProgramZ_ff == 4'b1111) // 10 secunde 14'b10011100010000
						begin
							NRstareZ_next = `AsteaptaZ;
							semnalizare_nextZ = 1'b1; //si pune semnalul de semnalizare pe 1 !!!! IMPORTANT		
							nrProgramZ_next = 14'b0;
						end
				
				end
		
		endcase
	
	
	end	

	
*/


