module title_screen ( input  [9:0] DrawX, DrawY,
							 output [16:0] title_address,
							 output        is_title
						  );
						  
			always @ (*)
			begin
				if (DrawX >= 186 && DrawX < 456 && DrawY >= 150  && DrawY < 306) // Title
				begin
					title_address = (DrawX - 186) + (DrawY - 150) * 435;
					is_title = 1'b1;
				end
				
				else if (DrawX >= 273 && DrawX < 366 && DrawY >= 440  && DrawY < 466) // Controls
				begin
					title_address = (DrawX - 4) + (DrawY - 440) * 435;
					is_title = 1'b1;
				end
				
				else if (DrawX >= 271 && DrawX < 369 && DrawY >= 316  && DrawY < 336) // Press Start
				begin
					title_address = (DrawX - 2) + (DrawY - 290) * 435;
					is_title = 1'b1;
				end
				
				else if (DrawX >= 85 && DrawX < 180 && DrawY >= 5  && DrawY < 73) // Sushi 
				begin
					title_address = (DrawX + 184) + (DrawY + 41) * 435;
					is_title = 1'b1;
				end
				
				else if (DrawX >= 476 && DrawX < 544 && DrawY >= 19  && DrawY < 73) // Fish
				begin
					title_address = (DrawX - 108) + (DrawY - 19) * 435;
					is_title = 1'b1;
				end
				
				else
				begin
					title_address = 0;
					is_title = 0;
				end
			end
			
endmodule
