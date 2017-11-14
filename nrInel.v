`define Inel 1
`define Stop 2
module NrInel (clk,reset_,en,an);


// ********** Intrari *********
input clk;
input reset_;
input en;

// ********* Iesiri *********
output [3:0] an;
    
 
// ******** Variabile interne ***
reg[3:0] s_ff, s_next; 
reg [2:0] state_ff, state_next;
//reg[3:0] out_ff, out_next; 
 


 
 
 
always @(*)   // ******* Combinational *********
	begin 
	s_next = s_ff;  // metoda de siguranta               OOOOOOOOOO
	state_next = state_ff;
	
	case(state_ff)
		`Inel:
			begin
				s_next = {s_ff[2:0],s_ff[3]};   
				if(~en)
					begin
						state_next = `Stop;
						s_next =4'b1111;
					end
				
			end
			
		`Stop:
			begin
				if(en)
					begin
						state_next=`Inel;
						s_next=4'b1110;
					
					end		
			
			end
	endcase
	end
	
		
 always @(posedge clk or negedge reset_)  // ******** Proces de clk si reset 
begin
		if (!reset_)   // daca reset e activ, initial s_ff=1110, prima stare
				begin
					s_ff <= 4'b1111; 
					state_ff <= `Inel;
				end
		
		else   // daca reset nu este activ
			begin
				state_ff <= state_next;	
				s_ff <= s_next;  // starea initiala = starea urmatoare
			
					
			end
		
end
 
  assign an = s_ff;
 
  endmodule
  
  
  
  
  
  // ********* explicatie OOOOOOOOOO
  /* always * inseamna ca va intrat in acel proces de cate ori se schimba starea unui semnal din interior
daca tu in proces ai N semnale _ff si _next
si doar unul trebuie sa se schimbe
atunci toate celalte trebuie sa ramana la aceeasi valoare 
asta e rolul _next <= _ff 
e un fel de solutie de backup
adica daca intra in proces si nu se schimba semnalele prin ramurile de if
atunci starea viitoare este tot una cu starea actuala

*/

