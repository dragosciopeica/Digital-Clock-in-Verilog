`define clk_Palpaire_IN 1000
`define clk_Palpaire_OUT 100

module TopAfisare(clk,reset_,Dig0,Dig1,Dig2,Dig3,DigB0,DigB1,DigB2,DigB3,prg,en,an,catod);

input clk;
input reset_;
input [3:0] Dig0;
input [3:0] Dig1;
input [3:0] Dig2;
input [3:0] Dig3;
input [3:0] DigB0;
input [3:0] DigB1;
input [3:0] DigB2;
input [3:0] DigB3;
input prg;
input en;

output [3:0] an;
output [7:0] catod;

// variabile Interne ( FIRE )
wire en_mux2;
wire palpaire_nrInel;
wire [3:0] s_dig0, s_dig1, s_dig2, s_dig3;



// ******** ClkParam

clkParam
#( //------------parameter definition-------------
	.in_clk_f(`clk_Palpaire_IN), 
	.out_clk_f(`clk_Palpaire_OUT)		  
)

	clk_Palpaire
		(
		.clk(clk),
		.en(prg),
		.reset_(reset_),
		.clk_out(en_mux2) // FIR
		);

		
// ******** NrInel
NrInel

	NrInel

		(
		.clk(clk),
		.reset_(reset_),
		.en(palpaire_nrInel), // FIR
		.an(an)
		);

// ******** Mux2		
Mux2
	
	Mux2
	
		(
		.clk(clk),
		.reset_(reset_),
		.sel(prg),
		.In1(en_mux2), // FIR /// am schimbat
		.In2(en),  
		.Out(palpaire_nrInel)  // FIR
		);

// ******** Mux

Mux
	
	DUT3
	
		(
	.clk(clk),
	.reset_(reset_),
	.sel(prg),
	.dig0(Dig0),
	.dig1(Dig1),
	.dig2(Dig2),
	.dig3(Dig3),
	.digB0(DigB0),
	.digB1(DigB1),
	.digB2(DigB2),
	.digB3(DigB3),
	.o_dig0(s_dig0),  // FIR
	.o_dig1(s_dig1), // FIR
	.o_dig2(s_dig2), // FIR
	.o_dig3(s_dig3)  // FIR
		
		);
		
displayCase

	DUT4
	(
	.clk(clk),
	.dig0(s_dig0),
	.dig1(s_dig1),
	.dig2(s_dig2),
	.dig3(s_dig3),
	.an(an),
	.reset_(reset_),
	.a(catod[0]),
	.b(catod[1]),
	.c(catod[2]),
	.d(catod[3]),
	.e(catod[4]),
	.f(catod[5]),
	.g(catod[6]),
	.dp(catod[7])
	);

	
endmodule

	

	
