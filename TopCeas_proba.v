// `define clk_Uart_IN 0
`define clk_Uart_OUT 76800


`define clk_Afisaj_OUT 1000

// `define clk_Alarma_IN
`define clk_Alarma_OUT 100

// `define clk_Control_IN
`define clk_Control_OUT 100

// `define clk_Deb_IN 1000
`define clk_Deb_OUT 20

// `define clk_Numarator_IN
`define clk_Numarator_OUT 1






module TopCeas(SW8,clk,catod,anod);


input SW8;
input clk;



output [7:0] catod;
output [3:0] anod;



wire unu;
wire BTNS_fir, BTND_fir, BTNR_fir, BTNL_fir, BTNU_fir, SW0_fir;  // debounce
wire fir_100Hz, fir_1Hz, fir_1Khz, fir_76KHz, fir_20Hz;  // divizor
wire en_alarma_fir, STOP_fir, Snooze_fir, LDceas_fir, LDalarma_fir, ResetTotal__fir, en_afisaj_fir, pgr_fir; // TopControl
wire [3:0] DigC0_fir, DigC1_fir, DigC2_fir, DigC3_fir; // TopControl
wire [3:0] digitN0_fir, digitN1_fir, digitN2_fir, digitN3_fir; // TopNumarator
wire LD2alarma_fir, LD1ceas_fir; // TopUART
wire [3:0] DigU0_fir, DigU1_fir, DigU2_fir, DigU3_fir; // TopUART
wire [3:0] o_MuxLDCeas0_fir, o_MuxLDCeas1_fir, o_MuxLDCeas2_fir, o_MuxLDCeas3_fir; // MuxLoadCeas
wire [3:0] o_MuxLDAlarma0_fir, o_MuxLDAlarma1_fir, o_MuxLDAlarma2_fir, o_MuxLDAlarma3_fir; // MuxLoadAlarma
wire Load_FIIIR_ceas, Load_FIIIR_alarma;
reg semnal_Load;


TopNumarator 
	Numarator
	(
	.clk(fir_1Hz),
	.en(unu),  
	.reset_(SW8),
	.load(semnal_Load),  // FIIIIIIIR  LDceas_fir | LD1ceas_fir
	.dig0(doi), // de la MUX LDceas
	.dig1(doi), // de la MUX LDceas
	.dig2(doi), // de la MUX LDceas
	.dig3(doi), // de la MUX LDceas
	.digit0(digitN0_fir),
	.digit1(digitN1_fir),
	.digit2(digitN2_fir),
	.digit3(digitN3_fir)
	);
assign unu = 1'b1;
assign zero = 4'b0;
assign zeroo = 1'b0;
assign doi = 4'b0010;
	
always @(posedge clk or negedge SW8)
	begin
		if(~SW8)
			begin
				semnal_Load <= 1'b1;
			end
		else
			begin
				semnal_Load <= 1'b0;
			end
	
	end
	
// ********************************************************************************* TopAfisaj *************************************************

TopAfisare
	Afisare
	(
	.clk(fir_1Khz),
	.reset_(SW8),
	.Dig0(digitN0_fir), // de la numarator
	.Dig1(digitN1_fir), // de la numarator
	.Dig2(digitN2_fir), // de la numarator
	.Dig3(digitN3_fir), // de la numarator
	.DigB0(doi),
	.DigB1(doi),
	.DigB2(doi),
	.DigB3(doi),
	.prg(zeroo),
	.en(unu),
	.an(anod),
	.catod(catod)
	
	);
	
	
	
	
// ********************************************************************************* Divizor Clock *************************************************

clk_div  // 76,8Khz // incepem cu ASTA
#( //------------parameter definition-------------
	.FREQ_IN(100000000), //100000000
	.FREQ_OUT(`clk_Uart_OUT)		  // 76800
)

	clk_Uart
		(
		.clk_in(clk),
		.reset_(SW8),
		.clk_out(fir_76KHz) // FIR
		);		

clk_div  // 1kHz
#( //------------parameter definition-------------
	.FREQ_IN(`clk_Uart_OUT), //100000000
	.FREQ_OUT(`clk_Afisaj_OUT)		  // 76800
)

	clk_Afisaj
		(
		.clk_in(fir_76KHz),
		.reset_(SW8),
		.clk_out(fir_1Khz) // FIR
		);			
	
		
clk_div  //  100 hz si la ALARMA !!!
#( //------------parameter definition-------------
	.FREQ_IN(`clk_Afisaj_OUT), //100000000
	.FREQ_OUT(`clk_Control_OUT)		  // 76800
)

	clk_Control
		(
		.clk_in(fir_1Khz),
		.reset_(SW8),
		.clk_out(fir_100Hz) // FIR
		);		
			
			
clk_div  // 20 Hz Debounce
#( //------------parameter definition-------------
	.FREQ_IN(`clk_Control_OUT), //100000000
	.FREQ_OUT(`clk_Deb_OUT)		  // 76800
)

	clk_Deb
		(
		.clk_in(fir_100Hz),
		.reset_(SW8),
		.clk_out(fir_20Hz) // FIR
		);
		
clk_div  // 76,8Khz // incepem cu ASTA
#( //------------parameter definition-------------
	.FREQ_IN(`clk_Deb_OUT), //100000000
	.FREQ_OUT(`clk_Numarator_OUT)		  // 76800
)

	clk_Numarator
		(
		.clk_in(fir_20Hz),
		.reset_(SW8),
		.clk_out(fir_1Hz) // FIR
		);	
	
// ********************************************************************************* MuxLoad *************************************************


// ********************************************************************************* Debounce *************************************************
/*
debounce

	BTNS_deb (
	
	.clk(fir_20Hz),
	.btn(BTNS),
	.reset_(SW8),
	.iesire(BTNS_fir)
	
		);
		
debounce

	BTNR_deb (
	
	.clk(fir_20Hz),
	.btn(BTNR),
	.reset_(SW8),
	.iesire(BTNR_fir)
	
		);
		
debounce

	BTNL_deb (
	
	.clk(fir_20Hz),
	.btn(BTNL),
	.reset_(SW8),
	.iesire(BTNL_fir)
	
		);
		
debounce

	BTNU_deb (
	
	.clk(fir_20Hz),
	.btn(BTNU),
	.reset_(SW8),
	.iesire(BTNU_fir)
	
		);
		
debounce

	BTND_deb (
	
	.clk(fir_20Hz),
	.btn(BTND),
	.reset_(SW8),
	.iesire(BTND_fir)
	
		);
		
debounce

	SW0_deb (
	
	.clk(fir_20Hz),
	.btn(SW0),
	.reset_(SW8),
	.iesire(SW0_fir)
	
		);
		

*/		

		
// ********************************************************************************* TopControl *************************************************
/*
TopControl
	Control
	(
.clk(fir_100Hz), 
.reset_(SW8),  
.BTNS(BTNS_fir),
.BTNL(BTNL_fir),
.BTNR(BTNR_fir),
.BTNU(BTNU_fir),
.BTND(BTND_fir),
.SW0(SW0_fir),
.en_alarma(en_alarma_fir),
.STOP(STOP_fir),
.Snooze(Snooze_fir),
.LDceas(LDceas_fir),
.LDalarma(LDalarma_fir),
.en_afisaj(en_afisaj_fir),
.pgr(pgr_fir),
.Diig0(DigC0_fir), 
.Diig1(DigC1_fir), 
.Diig2(DigC2_fir), 
.Diig3(DigC3_fir)
	);
	

// ********************************************************************************* TopAlarma *************************************************

TopAlarma
	Alarma
	(
	.clk(fir_100Hz),
	.reset_(SW8),
	.Dig0(o_MuxLDAlarma0_fir),  // MUX
	.Dig1(o_MuxLDAlarma1_fir), // MUX
	.Dig2(o_MuxLDAlarma2_fir), // MUX
	.Dig3(o_MuxLDAlarma3_fir), // MUX
	.LD(Load_FIIIR_alarma), // FIIIIIIIIR LDalarma_fir | LD2alarma_fir 
	.EN(en_alarma_fir),
	.DigN0(digitN0_fir),  
	.DigN1(digitN1_fir), 
	.DigN2(digitN2_fir), 
	.DigN3(digitN3_fir), 
	.STOP(STOP_fir),
	.Snooze(Snooze_fir),
	.buzz(Buzzer)
	
	);
	
	
	
	// ********************************************************************************* TopUart *************************************************

TopUart

	Uart 
	(
	.clk(fir_76KHz),
	.Rx(Rx),
	.reset_(SW8),
	.LD1(LD1ceas_fir),      
	.LD2(LD2alarma_fir), 
	.LED1(LED1),
	.LED2(LED2),
	.Dig0(DigU0_fir),
	.Dig1(DigU1_fir),
	.Dig2(DigU2_fir),
	.Dig3(DigU3_fir),
	.Tx(Tx)
	);
	
	
	MuxLoad
	LoadCeas
	(
		.clk(fir_100Hz),
		.reset_(SW8),
		.LDControl(LDceas_fir),
		.LDUart(LD1ceas_fir),
		.digC0(DigC0_fir),
		.digC1(DigC1_fir),
		.digC2(DigC2_fir),
		.digC3(DigC3_fir),
		.digU0(DigU0_fir),
		.digU1(DigU1_fir),
		.digU2(DigU2_fir),
		.digU3(DigU3_fir),
		.o_dig0(o_MuxLDCeas0_fir),
		.o_dig1(o_MuxLDCeas1_fir),
		.o_dig2(o_MuxLDCeas2_fir),
		.o_dig3(o_MuxLDCeas3_fir),
		.o_load(Load_FIIIR_ceas)
		
	);
	
MuxLoad
	LoadAlarma
	(	
		.clk(fir_100Hz),
		.reset_(SW8),
		.LDControl(LDalarma_fir),
		.LDUart(LD2alarma_fir),
		.digC0(DigC0_fir),
		.digC1(DigC1_fir),
		.digC2(DigC2_fir),
		.digC3(DigC3_fir),
		.digU0(DigU0_fir),
		.digU1(DigU1_fir),
		.digU2(DigU2_fir),
		.digU3(DigU3_fir),
		.o_dig0(o_MuxLDAlarma0_fir),
		.o_dig1(o_MuxLDAlarma1_fir),
		.o_dig2(o_MuxLDAlarma2_fir),
		.o_dig3(o_MuxLDAlarma3_fir),
		.o_load(Load_FIIIR_alarma)
		
	);


// ********************************************************************************* TopNumarator *************************************************
*/



	
endmodule