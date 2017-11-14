module TopControl(clk,reset_,BTNS,BTNL,BTNR,BTNU,BTND,SW0,en_alarma,STOP,Snooze,LDceas,LDalarma,en_afisaj,pgr,Diig0,Diig1,Diig2,Diig3);

input clk, reset_;
input BTNS, BTNL, BTNR, BTNU, BTND, SW0;
output en_alarma,STOP,Snooze;
output LDceas, LDalarma;
output en_afisaj;
output pgr;
output [3:0] Diig0, Diig1, Diig2, Diig3;


wire [4:0] ora_fir;
wire [5:0] minut_fir;


ControlFSM

	U0
	(

.clk(clk), 
.reset_(reset_),
.BTNS(BTNS),
.BTNL(BTNL),
.BTNR(BTNR),
.BTNU(BTNU),
.BTND(BTND),
.SW0(SW0),
.en_alarma(en_alarma),
.STOP(STOP),
.Snooze(Snooze),
.LDceas(LDceas),
.LDalarma(LDalarma),
.Ora(ora_fir),  // FIR
.Minut(minut_fir), // FIR
.en_afisaj(en_afisaj),
.palpaie(pgr)

	);
	


divMod 

DivMinute

( 
  .clk(clk),
  .reset_(reset_),
  .digMinut(minut_fir),
  .dig0(Diig0),
  .dig1(Diig1)
);

divMod_O

DivOra

( 
  .clk(clk),
  .reset_(reset_),
  .digOra(ora_fir),
  .dig2(Diig2),
  .dig3(Diig3)
);

endmodule