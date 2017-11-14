module numMod
#( //------------parameter definition-------------
	parameter modulo_param = 10 // both values are in Hz  
)
(clk,reset_,en,load,digit,clk_out,counter);
//------------parameter deffinition-------------
parameter modulo = modulo_param;	
parameter counter_width = (modulo > $clog2(modulo)) ? ($clog2(modulo)+1) : $clog2(modulo); 

//------------input signals-------------
input clk;
input en;		// active high
input reset_;	// active low
input load;
input [counter_width-1:0] digit;
//------------ouput signals-------------


output clk_out;
output [counter_width-1:0] counter;

//-------------local values definition-------------


reg[counter_width-1:0] counter_ff, counter_next; 
reg			   		   out_ff    , out_next;

//------------continue assignement-----------------
assign clk_out = out_ff;	
assign counter = counter_ff;							
						    

//---------------combinational logic----------

always @*	// ----- !!!! ----- will enter this process whenever a signal from the one used below changes his state
	begin		
		counter_next = counter_ff;
		out_next = out_ff;
		
		if(load && (digit <= modulo))
			begin
				counter_next=digit;   // inseamna ca incarcarea este sincrona. Oricand vine load-ul respectiv update-ul counter-ului la iesire va fi luat pe primul semnal de tact
				
			end
		else 
			begin
				if(en)  // daca en e 1
					begin 
						counter_next = counter_ff+1'b1;
						if(counter_ff == (modulo-1)) // am pus asta sa am nextu activ la 8, astfel incat ff-u, out_ff, care vine pe clk, sa fie activ la 9.		 
							begin
								out_next=1'b1; // Eu inainte am pus aici FF, pentru ca aveam nevoie de o intarziere, mie mi se facea 8,9,0,21, sarea peste 20., asa ca, am pus SUS
								
							end
						else if(counter_ff == modulo)	// daca e egal cu modula, sa se puna pe 0 si out_next sa fie 0.	
							begin
								counter_next = {counter_width{1'b0}};
								out_next=1'b0;
							end
					end
			end
	end

//-------------clock process------------
// aici doar atribuim urmatoarea stare!
// nu fac LOGICA!!!

// clock process este declansat/actionat doar de posedge clk SAU negedge reset_
always @(posedge clk or negedge reset_)   // intotdeauna la frontul crescator de tact sau negativ de reset
	begin
		if(!reset_)   // daca reset e 0, if active reset the counter and the output are set to default values
			begin
				counter_ff <= {counter_width{1'b0}};  // atribuim counter_ff(starea actuala) 0
				out_ff 	   <= 1'b0;			
			end
		else  // daca reset_ e 1
			begin
				counter_ff <= counter_next;          // update the counter state
				out_ff     <= out_next    ;     	  // clk = clk negat
			end
			
	end
	
endmodule
