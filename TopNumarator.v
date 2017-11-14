module TopNumarator(
clk,
en,
reset_,
load,
dig0,
dig1,
dig2,
dig3,
digit0,
digit1,
digit2,
digit3);

// -------------- Am declarat intrari la TopNumarator --------
input clk;
input en;
input reset_;
input load;
input [3:0] dig0;
input [3:0] dig1;
input [3:0] dig2;
input [3:0] dig3;

// -------------- Am declarat iesiri la TopNumarator --------
output [3:0] digit0;
output [3:0] digit1;
output [3:0] digit2;
output [3:0] digit3;

// -------------- Am declarat firele de legatura --------

wire en2;
wire en3;
wire en4;
wire [3:0] ldUnitMin;
wire [3:0] ldZeciMin;
wire [3:0] ldUnitOre;
wire [3:0] ldZeciOre;
wire random;
wire [2:0] zeciMinute;
wire [1:0] zeciOre;
wire resetTotal;
wire b;
wire a;



//-------------- Instatiere modul divMod ( cel care face accesul la cifrele lui digOra, digMinut) --------
/*divMod 

DUT

( .digOra(digOra),
  .digMinut(digMinut),
  .dig0(ldUnitMin),
  .dig1(ldZeciMin),
  .dig2(ldUnitOre),
  .dig3(ldZeciOre)

);
*/

// ------------- Instantiere numMod U1 ----------
numMod

#(
	.modulo_param(9)
 )
 
	U1

(
	.clk(clk),
	.en(en),
	.reset_(reset_),
	.load(load),
	.digit(dig0),
	.clk_out(en2),
	.counter(digit0)
);
	
// ------------- Instantiere numMod U2 ----------
numMod
#(
	.modulo_param(5)
 )

	U2

(
	.clk(clk),
	.en(en2),
	.reset_(reset_),
	.load(load),	
	.digit(dig1),
	.clk_out(en3),
	.counter(zeciMinute)
);

assign digit1 = 4'b0 | zeciMinute;
//assign ldZeciMin = 1'b0 | LoadZMin;
// ------------- Instantiere numMod U3 ----------
numMod
#(
	.modulo_param(9)
 )	
	
	U3

(
	.clk(clk),
	.en(en3&en2&en),
	.reset_(reset_&(~resetTotal)),
	.load(load),
	.digit(dig2),
	.clk_out(en4),
	.counter(digit2)	// cand digit2 este == 4 vei avea combinatia 0100  ~digit2[0]&~digit2[1]&digit2[2]&~digit2[3] => 1
);




// ------------- Instantiere numMod U4 ----------
numMod
	
#(
	.modulo_param(3)
 )
	
	U4
(
	.clk(clk),
	.en(en4&en3&en2&en),
	.reset_(reset_&(~resetTotal)),
	.load(load),
	.digit(dig3),
	.clk_out(random), // nu il mai folosesc nicaieri
	.counter(zeciOre)	// cand zeci ore este 2 vei avea combinatia 0010 ~zeciOre[0]&zeciOre[1]=1 => 1
);
assign digit3 = 4'b0 | zeciOre;

assign a = ~digit2[0] & ~digit2[1] & digit2[2] & ~digit2[3]; // detectam starea 4 la digit 2;
assign b = ~zeciOre[0] & zeciOre[1]; // detectam starea 2 la digit 3
assign resetTotal = a & b; // atribuit reset total '1' logic;




endmodule
