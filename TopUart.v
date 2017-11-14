module TopUart(clk,Rx,reset_,LD1,LD2,LED1,LED2,Dig0,Dig1,Dig2,Dig3,Tx );

// --- Inputs and Outputs
input clk;
input Rx;
input reset_;


output LD1;
output LD2;
output LED1;
output LED2;
output [3:0] Dig0;
output [3:0] Dig1;
output [3:0] Dig2;
output [3:0] Dig3;
output Tx;


// ------ Variabile interne

wire [7:0] firBite;
wire firUseByte;
wire [5:0] fir_minute;
wire [4:0] fir_ore;

// instantiere Uart

Uart
	DUT
	(
	.clk(clk),
	.buss(Rx),
	.reset_(reset_),
	.bite(firBite), /// se leaga cu bite-ul din Uart2? 
	.use_byte(firUseByte) // se leaga cu use_byte din uart2? )
	);
	
// instantiere Uart2

Uart2
	DUT1
	(
	.clk(clk),
	.bite(firBite), // aici pun firu de legatura? il declar ca wire?
	.use_byte (firUseByte), // fir de legatura ?
	.reset_(reset_),
	.Minute(fir_minute),
	.Ora(fir_ore),
	.LD1(LD1),
	.LD2(LD2),
	.LED1(LED1),
	.LED2(LED2)
	
	);
	
assign Tx = 1'b0;

divMod 

DivMinute

( 
  .clk(clk),
  .reset_(reset_),
  .digMinut(fir_minute),
  .dig0(Dig0),
  .dig1(Dig1)
);

divMod_O

DivOra

( 
  .clk(clk),
  .reset_(reset_),
  .digOra(fir_ore),
  .dig2(Dig2),
  .dig3(Dig3)
);


endmodule