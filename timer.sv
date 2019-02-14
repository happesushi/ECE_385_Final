module timer ( input  logic       Clk, Reset,
					output logic [7:0] time_left,
					output logic       time_up
				 );
			
			logic [25:0] clk_transform;
			
			always @ (posedge Clk)
			begin
				if (Reset)
				begin
					time_left <= 8'h60;
					// While our time is in hex as 60 we want to have a 60 second timer, so we account for the difference when we count down from X0 to (X-1)9
					// (X and X-1 being the 10's digit)
					clk_transform <= 0;
					time_up <= 0;
				end
				
				else if (time_left == 0)
				begin
					time_up <= 1'b1;
				end
				
				else if (clk_transform == 26'd50000000)
				begin
					if (time_left[3:0] == 4'h0)
						time_left <= time_left + 8'hf9; // Extra being subtracted here to have our hex display match the decimal value we want
					else
						time_left <= time_left + 8'hff;
					clk_transform <= 0;
				end
				
				else
					clk_transform <= clk_transform + 8'h01;
			end
			
endmodule
