module score( input  logic [3:0] score_inc,
				  input  logic       Clk, Reset,
				  output logic [7:0] score0, score1, score2, score3
				);

logic [7:0] score_inc_ext;

always_ff @ (posedge Clk)
begin
	score_inc_ext <= {4'b0, score_inc};
	
	if (Reset)
	begin
		score0 <= 0;
		score1 <= 0;
		score2 <= 0;
		score3 <= 0;
	end
	
	else if ((score0 == 8'd09)&&(score1 == 8'd09)&&(score2 == 8'd09)&&(score3 == 8'd09));
//	begin
//		
//	end
	
	else
	begin
		if (score_inc_ext >= 8'd10)
		begin
			score_inc_ext <= score_inc_ext + 8'hf6;
			if (score1 == 8'h09)
			begin
				score1 <= 0;
			
				if (score2 == 8'h09)
				begin
					score3 <= score3 + 8'h01;
					score2 <= 0;
				end
			
				else
					score2 <= score2 + 8'h01;
			end
		
			else
				score1 <= score1 + 8'h01;
		end
		
		score0 <= score0 + score_inc_ext;
		
		if (score0 >= 8'd10)
		begin
			score0 <= score0 + 8'hf6;
		
			if (score1 == 8'h09)
			begin
				score1 <= 0;
			
				if (score2 == 8'h09)
				begin
					score3 <= score3 + 8'h01;
					score2 <= 0;
				end
			
				else
					score2 <= score2 + 8'h01;
			end
		
			else
				score1 <= score1 + 8'h01;
		end
	end

end

endmodule
