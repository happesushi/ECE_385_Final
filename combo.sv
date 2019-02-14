module combo ( input  logic [7:0] combo_count,
				 	input  logic       Clk,
					input  logic [3:0] score_in,
				 	output logic [3:0] score_out
				 );
			
//			logic [3:0] scoreX2, scoreX3, scoreX4, scoreX5;
			
 		   always_comb
			begin
				if (combo_count <= 8'd05)
					score_out = score_in;
				else if (combo_count <= 8'd13)
					score_out = score_in + score_in;
				else if (combo_count <= 8'd24)
					score_out = score_in + score_in + score_in;
				else if (combo_count <= 8'd38)
					score_out = score_in + score_in + score_in + score_in;
				else
					score_out = score_in + score_in + score_in + score_in + score_in;
			end
					
endmodule
