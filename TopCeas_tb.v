`timescale 1ps/1ps
module TopCeas_tb();

reg BTNS;
reg BTNL;
reg BTNR;
reg BTNU;
reg BTND;
reg SW0;
reg SW8;
reg clk;
reg reset_;
reg Rx;


wire [7:0] catod;
wire [3:0] anod;
wire LED1;
wire LED2;
wire Buzzer;

TopCeas
	TOP
	(
	.BTNS(BTNS),
	.BTNL(BTNL),
	.BTNR(BTNR),
	.BTNU(BTNU),
	.BTND(BTND),
	.SW0(SW0),
	.SW8(SW8),
	.clk(clk),
	.reset_(reset_),
	.Rx(Rx),
	.catod(catod),
	.anod(anod),
	.LED1(LED1),
	.LED2(LED2),
	.Buzzer(Buzzer)
	
	);

initial 
	begin
		clk=0;
		forever begin
			#2 clk=~clk;
		end
	end

initial
	begin
	Rx=1;
	BTNL=0;
	BTNS=0;
	BTND=0;
	BTNU=0;
	BTNR=0;
	SW0=0;
	SW8=0;
	#30
	SW8=1;
	#20
	BTNS=1;
	#100
	BTNS=0;
	#20
	BTNL =1;
	#100   // apasare lunga
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10  // BTNR
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	#10  
	BTNR=1;
	#10
	BTNR=0;
	

	
	
	end
	
	

endmodule

/*
************** Test BTNL sau BTNU si incrementare ora cu BTNL si BTNR ************

clk=0;
	reset_=0;
	#10
	reset_=1;
	#20
	BTNL =1;
	#50   // apasare lunga
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=1;
	#10
	BTNL=0;
	#10
	BTNL=1;
	#10
	BTNL=0;// a
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
	#10
	BTNR=1;
	#10
	BTNR=0;
*/