module displayCase (clk,dig0,dig1,dig2,dig3,an,reset_,a,b,c,d,e,f,g,dp);


// ******* Intrari *****
input clk;
input [3:0] dig0, dig1,dig2,dig3,an;
input reset_;
// ******* Iesiri ****
output a,b,c,d,e,f,g,dp;

reg [3:0] vector;
reg [6:0] cifra;
reg dpR;


assign  {g, f, e, d, c, b, a} = cifra;  // -------- concatenare catozi -------
assign dp = dpR;


always @(*)     // ---------- Cazuri la anod --------
	begin
if(!reset_)
	begin
		cifra = 7'b1111111;
		dpR   = 1'b1;
	end
	else
		begin
			case(an)
				4'b1110: begin // modifica bitii
							vector = dig0;
							dpR = 1'b1;
						end
						
				4'b1101: begin 
							vector = dig1;
							dpR = 1'b1;
						end
						
				4'b1011: begin 
							vector = dig2;
							dpR = 1'b0;
						end
				4'b0111: begin 
							vector = dig3;
							dpR = 1'b1;
						end
			endcase
			case(vector) // aici era FF, asa mi-a zis Dorin
				4'd0 : cifra = 7'b1000000;
				4'd1 : cifra = 7'b1111001;
				4'd2 : cifra = 7'b0100100;
				4'd3 : cifra = 7'b0110000;
				4'd4 : cifra = 7'b0011001;
				4'd5 : cifra = 7'b0010010;
				4'd6 : cifra = 7'b0000010;
				4'd7 : cifra = 7'b1111000;
				4'd8 : cifra = 7'b0000000;
				4'd9 : cifra = 7'b0010000;
				default : cifra = 7'b0111111; //dash
			endcase
		end
end

endmodule