/*
100MHz la 1KHz
100 * 10^6 / 1*10^3=100000
log100000/log2=17 ===> un registru cu dimensiunea de 17.
100000/2=50000, deoarece incepem de la 0 vom merge pana la 4999 de pulsuri.

*/


module clkParam
#( //------------parameter definition-------------
	parameter in_clk_f = 100000000, // both values are in Hz
	parameter out_clk_f = 1000		  // if the values will not be overwrited when the module is instantiated, theese values will be used
)
(clk,reset_,en,clk_out);
//------------input signals-------------
input clk;
input en;		// active high
input reset_;	// active low
//------------ouput signals-------------
output clk_out;

//-------------local values definition-------------
parameter division_rate = in_clk_f/out_clk_f;	// this will act like the define found in the C language. When the code will be compiled, the parameter values will be replaced with the actual values from the module instantiation
												// if the 2 parameters in_clk_f and out_clk_f will not be overwritted in the module instantation the result will be 100_000_000/1000 = 100_000
parameter counter_width = $clog2(division_rate); // returns an integer which has the value of the ceiling of the log base 2. Ex $clog2(5) = 3, 5 can be written on 3 bits
													// log base 2(100000)=16,60 ==> 100000 poate fi scris intr-un registru cu 17 biti
reg[counter_width-1:0] counter_ff, counter_next; // counter_ff(or counter flip-flop) is the present state, this value will be assigned to the output, counter_next is the next state 
reg			   		   out_ff    , out_next;

//------------continue assignement-----------------
assign clk_out = out_ff;	// in this part all the ouputs are continiously assigned to the _ff signals 
							// atribuim starea prezenta
						    // -------------- ATRIBUIM clk_out lui out_ff ( starea prezenta ) ------------

//---------------combinational logic----------
always @*	// will enter this process whenever a signal from the one used below changes his state
	begin
		// in case the logic below doesn`t change the _next, we have to have a backup plan 
		counter_next = counter_ff;	// if nothing change below, the next state is the same as present state
		out_next = out_ff;         // ----- INTREBAREEE !!! ( de ce clk_out = out_ff dar si out_next = out_ff ===> out_next = clk_out????  -----------      
		if(en)  // daca en e 1
		begin
			// now we make the next state logic :)
			if(counter_ff < (division_rate/2))	// one half of the counting period out is 1, the other half is 0
													// in situatia data de mine (20,5), division rate=4, 4/2 - 1 = 1
													// cand counter_ff < 1, out_next=0
													// ADEVARAT
				begin
					out_next = 1'b0;
				end
			else									// cand counter_ff > 1, out_next=1, DA!
				begin
					out_next = 1'b1;
				end
			if(counter_ff == (division_rate-1))		// in cazul meu 4-1= 3, counting logic - reset when the counter values is equal with the division rate
				begin
					counter_next = {counter_width{1'b0}};				// reset all bits of the counter to 0. The {} will concatenate 0 for counter_width times
				end
			else
				begin
					counter_next = counter_ff+1'b1;			// increment the counter
				end
		end
	end

//-------------clock process------------
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
