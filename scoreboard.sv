module scoreboard ( input  [3:0]  score0, score1, score2, score3,
						  input  [9:0]  DrawX, DrawY, combo_count,
						  input  [7:0]  time_left,
						  input         game_over, game_menu,
						  output        is_text, is_digit,
						  output [13:0] digit_address,
						  output [12:0] text_address
						);
						
			logic [9:0] combo_offset, score0_offset, score1_offset, score2_offset, score3_offset, time_offset0, time_offset1;
			
			always_comb
			begin
				if (combo_count <= 8'd05)
					combo_offset = 32;
				else if (combo_count <= 8'd13)
					combo_offset = 64;
				else if (combo_count <= 8'd24)
					combo_offset = 96;
				else if (combo_count <= 8'd38)
					combo_offset = 128;
				else
					combo_offset = 160;
					
				if (score0 == 4'd0)
					score0_offset = 0;
				else if (score0 == 4'd1)
					score0_offset = 32;
				else if (score0 == 4'd2)
					score0_offset = 64;
				else if (score0 == 4'd3)
					score0_offset = 96;
				else if (score0 == 4'd4)
					score0_offset = 128;
				else if (score0 == 4'd5)
					score0_offset = 160;
				else if (score0 == 4'd6)
					score0_offset = 192;
				else if (score0 == 4'd7)
					score0_offset = 224;
				else if (score0 == 4'd8)
					score0_offset = 256;
				else
					score0_offset = 288;
				
				if (score1 == 4'd0)
					score1_offset = 0;
				else if (score1 == 4'd1)
					score1_offset = 32;
				else if (score1 == 4'd2)
					score1_offset = 64;
				else if (score1 == 4'd3)
					score1_offset = 96;
				else if (score1 == 4'd4)
					score1_offset = 128;
				else if (score1 == 4'd5)
					score1_offset = 160;
				else if (score1 == 4'd6)
					score1_offset = 192;
				else if (score1 == 4'd7)
					score1_offset = 224;
				else if (score1 == 4'd8)
					score1_offset = 256;
				else
					score1_offset = 288;
					
				if (score2 == 4'd0)
					score2_offset = 0;
				else if (score2 == 4'd1)
					score2_offset = 32;
				else if (score2 == 4'd2)
					score2_offset = 64;
				else if (score2 == 4'd3)
					score2_offset = 96;
				else if (score2 == 4'd4)
					score2_offset = 128;
				else if (score2 == 4'd5)
					score2_offset = 160;
				else if (score2 == 4'd6)
					score2_offset = 192;
				else if (score2 == 4'd7)
					score2_offset = 224;
				else if (score2 == 4'd8)
					score2_offset = 256;
				else
					score2_offset = 288;
					
				if (score3 == 4'd0)
					score3_offset = 0;
				else if (score3 == 4'd1)
					score3_offset = 32;
				else if (score3 == 4'd2)
					score3_offset = 64;
				else if (score3 == 4'd3)
					score3_offset = 96;
				else if (score3 == 4'd4)
					score3_offset = 128;
				else if (score3 == 4'd5)
					score3_offset = 160;
				else if (score3 == 4'd6)
					score3_offset = 192;
				else if (score3 == 4'd7)
					score3_offset = 224;
				else if (score3 == 4'd8)
					score3_offset = 256;
				else
					score3_offset = 288;
					
				if (time_left[3:0] == 4'd0)
					time_offset0 = 0;
				else if (time_left[3:0] == 4'd1)
					time_offset0 = 32;
				else if (time_left[3:0] == 4'd2)
					time_offset0 = 64;
				else if (time_left[3:0] == 4'd3)
					time_offset0 = 96;
				else if (time_left[3:0] == 4'd4)
					time_offset0 = 128;
				else if (time_left[3:0] == 4'd5)
					time_offset0 = 160;
				else if (time_left[3:0] == 4'd6)
					time_offset0 = 192;
				else if (time_left[3:0] == 4'd7)
					time_offset0 = 224;
				else if (time_left[3:0] == 4'd8)
					time_offset0 = 256;
				else
					time_offset0 = 288;
					
				if (time_left[7:4] == 4'd0)
					time_offset1 = 0;
				else if (time_left[7:4] == 4'd1)
					time_offset1 = 32;
				else if (time_left[7:4] == 4'd2)
					time_offset1 = 64;
				else if (time_left[7:4] == 4'd3)
					time_offset1 = 96;
				else if (time_left[7:4] == 4'd4)
					time_offset1 = 128;
				else if (time_left[7:4] == 4'd5)
					time_offset1 = 160;
				else if (time_left[7:4] == 4'd6)
					time_offset1 = 192;
				else if (time_left[7:4] == 4'd7)
					time_offset1 = 224;
				else if (time_left[7:4] == 4'd8)
					time_offset1 = 256;
				else
					time_offset1 = 288;
			end
			
			always @ (*)
			begin
				if (game_menu == 0)
				begin
					if (game_over == 0 && DrawY >= 0 && DrawY < 32 && DrawX >= 8 && DrawX < 72) // Score:
					begin
						text_address = (DrawX - 8) + (DrawY) * 256;
						is_text = 1;
					end
					else if (game_over == 0 && DrawY >= 0 && DrawY < 32 && DrawX >= 568 && DrawX < 632) // Time:
					begin
						text_address = (DrawX - 568 + 128) + (DrawY) * 256;
						is_text = 1;
					end
					else if (game_over == 0 && DrawY >= 416 && DrawY < 448 && DrawX >= 568 && DrawX < 632) // X Combo
					begin
						text_address = (DrawX - 568 + 192) + (DrawY - 416) * 256;
						is_text = 1;
					end
					else if (game_over == 1 && DrawY >= 208 && DrawY < 240 && DrawX >= 288 && DrawX < 352) // Final Score
					begin
						text_address = (DrawX - 288 + 64) + (DrawY - 208) * 256;
						is_text = 1;
					end
					else
					begin
						text_address = 0;
						is_text = 0;
					end
				end
				else
				begin
					text_address = 0;
					is_text = 0;
				end
			end
			
			always @ (*)
			begin
				if (game_menu == 0)
				begin
					if (game_over == 0 && DrawY >= 32 && DrawY < 64 && DrawX >= 60 && DrawX < 80) // Score0
					begin
						digit_address = (DrawX - 54 + score0_offset) + (DrawY - 32) * 512;
						is_digit = 1;
					end
					else if (game_over == 0 && DrawY >= 32 && DrawY < 64 && DrawX >= 40 && DrawX < 60) // Score1
					begin
						digit_address = (DrawX - 34 + score1_offset) + (DrawY - 32) * 512;
						is_digit = 1;
					end
					else if (game_over == 0 && DrawY >= 32 && DrawY < 64 && DrawX >= 20 && DrawX < 40) // Score2
					begin
						digit_address = (DrawX - 14 + score2_offset) + (DrawY - 32) * 512;
						is_digit = 1;
					end
					else if (game_over == 0 && DrawY >= 32 && DrawY < 64 && DrawX >= 0 && DrawX < 20) // Score3
					begin
						digit_address = (DrawX + 6 + score3_offset) + (DrawY - 32) * 512;
						is_digit = 1;
					end
					else if (game_over == 0 && DrawY >= 32 && DrawY < 64 && DrawX >= 600 && DrawX < 620) // Time0
					begin
						digit_address = (DrawX - 594 + time_offset0) + (DrawY - 32) * 512;
						is_digit = 1;
					end
					else if (game_over == 0 && DrawY >= 32 && DrawY < 64 && DrawX >= 580 && DrawX < 600) // Time1
					begin
						digit_address = (DrawX - 574 + time_offset1) + (DrawY - 32) * 512;
						is_digit = 1;
					end
					else if (game_over == 0 && DrawY >= 404 && DrawY < 436 && DrawX >= 578 && DrawX < 610) // Combo Multiplier
					begin
						digit_address = (DrawX - 578 + combo_offset) + (DrawY - 404) * 512;
						is_digit = 1;
					end
					else if (game_over == 1 && DrawY >= 240 && DrawY < 272 && DrawX >= 340 && DrawX < 360) // Final Score0
					begin
						digit_address = (DrawX - 334 + score0_offset) + (DrawY - 240) * 512;
						is_digit = 1;
					end
					else if (game_over == 1 && DrawY >= 240 && DrawY < 272 && DrawX >= 320 && DrawX < 340) // Final Score1
					begin
						digit_address = (DrawX - 314 + score1_offset) + (DrawY - 240) * 512;
						is_digit = 1;
					end
					else if (game_over == 1 && DrawY >= 240 && DrawY < 272 && DrawX >= 300 && DrawX < 320) // Final Score2
					begin
						digit_address = (DrawX - 294 + score2_offset) + (DrawY - 240) * 512;
						is_digit = 1;
					end
					else if (game_over == 1 && DrawY >= 240 && DrawY < 272 && DrawX >= 280 && DrawX < 300) // Final Score3
					begin
						digit_address = (DrawX - 274 + score3_offset) + (DrawY - 240) * 512;
						is_digit = 1;
					end
					else
					begin
						digit_address = 0;
						is_digit = 0;
					end
				end
				else
				begin
					digit_address = 0;
					is_digit = 0;
				end
			end
endmodule
