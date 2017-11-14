
module debounce(clk,btn,reset_,iesire);

input clk;
input btn;
input reset_;
output iesire;

reg btn_last_ff;
reg btn_last_ff2;

reg out_ff, out_next;

assign iesire = out_ff;


always @(*)
	begin
	
	out_next = out_ff;
		
	if(btn ^ btn_last_ff2)
		begin
		out_next = btn;
		
		end
		

	end
// cand ies din reset, datorita testb, intra btn-ul in functiune
	
always @(posedge clk or negedge reset_)
	begin
		if(~reset_)
			begin
			btn_last_ff <= 0;
			out_ff <= 0;
			end
		else
			begin
			btn_last_ff <= btn;   // lui ff ii atribui next       // update the counter state
			btn_last_ff2 <= btn_last_ff;   // intarziere
			out_ff     <= out_next; 
			
			end
		
	
	end
	
	
	/* always@*  // asta nu e bun, de cate ori se schimba btn_last el devine 0.
begin

	btn_last =1'b0;
end
*/
	
endmodule