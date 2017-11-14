module TopAlarma(clk, reset_, Dig0,Dig1,Dig2,Dig3,LD,EN,DigN0,DigN1,DigN2,DigN3,STOP,Snooze,buzz);


// ****** Intrari
input clk;
input reset_;
input [3:0] Dig0;
input [3:0] Dig1;
input [3:0] Dig2;
input [3:0] Dig3;
input LD;
input EN;
input [3:0] DigN0;
input [3:0] DigN1;
input [3:0] DigN2;
input [3:0] DigN3;
input STOP;
input Snooze;

// ******* Iesiri

output buzz;

// ******* Variabile interne
wire [3:0] zeroDig,unuDig,doiDig,treiDig;  // semnale de legatura intre Registru si Comparator
wire Trigg;
wire feed;
//******* Instantiere Registru

AlarmaReg
	DUT
	(
	.clk(clk),
	.reset_(reset_),
	.Dig0(Dig0),
	.Dig1(Dig1),
	.Dig2(Dig2),
	.Dig3(Dig3),
	.LD(LD),
	.Dig00(zeroDig),
	.Dig11(unuDig),
	.Dig22(doiDig),
	.Dig33(treiDig)
	);
	
AlarmaComp
	DUT1
	(
	.clk(clk),
	.reset_(reset_),
	.Dig0(zeroDig),
	.Dig1(unuDig),
	.Dig2(doiDig),
	.Dig3(treiDig),
	.DigN0(DigN0),
	.DigN1(DigN1),
	.DigN2(DigN2),
	.DigN3(DigN3),
	.EN(EN),
	.feedback(feed),
	.Trigger(Trigg)
	);
	
AlarmaBuzzer
	DUT2
	(
	.clk(clk),
	.reset_(reset_),
	.STOP(STOP),
	.Snooze(Snooze),
	.Trigger(Trigg),
	.buzz(buzz),
	.feedback(feed)
	);




endmodule