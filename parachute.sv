module parachute ( input  logic       Clk, Reset, start_game, game_reset, time_up,
						 output logic       timer_reset, score_reset, obj0, obj1, obj2, obj3, game_over, game_menu
					  );
					  

		logic [26:0] sec_timer;
		logic        sec_timer_start;//, obj_flag0_out, obj_flag1_out, obj_flag2_out, obj_flag0_in, obj_flag1_in, obj_flag2_in;
//		logic        obj0_spawn, obj1_spawn, obj2_spawn, obj3_spawn;
		
		enum logic [4:0] {Menu, Start, Wait0, Wait1, Wait2, Wait3, Spawn_Obj0, Spawn_Obj1, Spawn_Obj2, Spawn_Obj3, Game_Over, Menu_Buffer} State, Next_State;
		
		always_ff @ (posedge Clk)
		begin
			if (Reset)
			begin
				State <= Menu;
//				obj0 <= 0;
//				obj1 <= 0;
//				obj2 <= 0;
//				obj3 <= 0;
//				obj_flag0_in <= 0;
//				obj_flag1_in <= 0;
//				obj_flag2_in <= 0;
			end
			else
			begin
				State <= Next_State;
//				obj0 <= obj0_spawn;
//				obj1 <= obj1_spawn;
//				obj2 <= obj2_spawn;
//				obj3 <= obj3_spawn;
//				obj_flag0_in <= obj_flag0_out;
//				obj_flag1_in <= obj_flag1_out;
//				obj_flag2_in <= obj_flag2_out;
			end
		end
		
		always_ff @ (posedge Clk)
		begin
			if (sec_timer_start)
				sec_timer <= sec_timer + 27'd1;
			else
				sec_timer <= 0;
		end
		
		
		always_comb
		begin
		 Next_State = State;
		 sec_timer_start = 1'b0;
		 obj0 = 1'b0;
		 obj1 = 1'b0;
		 obj2 = 1'b0;
		 obj3 = 1'b0;
//			State = Next_State;
		  case (State)
				Menu:
				begin
					if (start_game)
						Next_State = Start;
					else
						Next_State = Menu;
				end
				
				Start:
				begin
					if (sec_timer == 27'd75000000)
						Next_State = Spawn_Obj0;
					else
						Next_State = Start;
				end
						
				Wait0:
				begin
					if (time_up)
						Next_State = Game_Over;
					else if (sec_timer == 27'd75000000)
					begin
//						if (obj_flag0_in)
							Next_State = Spawn_Obj0;
//						else if (obj_flag1_in)
//							Next_State = Spawn_Obj1;
//						else if (obj_flag2_in)
//							Next_State = Spawn_Obj2;
//						else
//							Next_State = Spawn_Obj3;
					end
					else
						Next_State = Wait0;
				end
				
				Wait1:
				begin
					if (time_up)
						Next_State = Game_Over;
					else if (sec_timer == 27'd75000000)
						Next_State = Spawn_Obj1;
					else
						Next_State = Wait1;
				end
				
				Wait2:
				begin
					if (time_up)
						Next_State = Game_Over;
					else if (sec_timer == 27'd75000000)
						Next_State = Spawn_Obj2;
					else
						Next_State = Wait2;
				end
				
				Wait3:
				begin
					if (time_up)
						Next_State = Game_Over;
					else if (sec_timer == 27'd75000000)
						Next_State = Spawn_Obj3;
					else
						Next_State = Wait3;
				end
				
				Spawn_Obj0:
					Next_State = Wait1;
					
				Spawn_Obj1:
					Next_State = Wait2;
					
				Spawn_Obj2:
					Next_State = Wait3;
					
				Spawn_Obj3:
					Next_State = Wait0;
					
				Game_Over:
				begin
					if (game_reset)
						Next_State = Menu_Buffer;
					else
						Next_State = Game_Over;
				end
				
				Menu_Buffer: // Buffer state to prevent accidently starting the game again with 1 reset press
				begin
					if (~game_reset)
						Next_State = Menu;
					else
						Next_State = Menu_Buffer;
				end
				
			endcase
			
			case (State)
				Menu:
				begin
					score_reset = 1'b1;
					timer_reset = 1'b1;
					game_over = 1'b0;
					game_menu = 1'b1;
				end
					
				Start:
				begin
					score_reset = 1'b0;
					timer_reset = 1'b0;
					sec_timer_start = 1'b1;
					game_over = 1'b0;
					game_menu = 1'b0;
				end
					
				Wait0, Wait1, Wait2, Wait3:
				begin
					score_reset = 1'b0;
					timer_reset = 1'b0;
					sec_timer_start = 1'b1;
					game_over = 1'b0;
					game_menu = 1'b0;
				end
				
				Spawn_Obj0:
				begin
					score_reset = 1'b0;
					timer_reset = 1'b0;
//					obj_flag0_out = 1'b0;
//					obj_flag1_out = 1'b1;
//					obj_flag2_out = 1'b0;
					obj0 = 1'b1;
					game_over = 1'b0;
					game_menu = 1'b0;
				end
					
				Spawn_Obj1:
				begin
					score_reset = 1'b0;
					timer_reset = 1'b0;
//					obj_flag0_out = 1'b0;
//					obj_flag1_out = 1'b0;
//					obj_flag2_out = 1'b1;
					obj1 = 1'b1;
					game_over = 1'b0;
					game_menu = 1'b0;
				end
					
				Spawn_Obj2:
				begin
					score_reset = 1'b0;
					timer_reset = 1'b0;
//					obj_flag0_out = 1'b0;
//					obj_flag1_out = 1'b0;
//					obj_flag2_out = 1'b0;
					obj2 = 1'b1;
					game_over = 1'b0;
					game_menu = 1'b0;
				end
					
				Spawn_Obj3:
				begin
					score_reset = 1'b0;
					timer_reset = 1'b0;
//					obj_flag0_out = 1'b1;
//					obj_flag1_out = 1'b0;
//					obj_flag2_out = 1'b0;
					obj3 = 1'b1;
					game_over = 1'b0;
					game_menu = 1'b0;
				end
					
				Game_Over:
				begin
					score_reset = 1'b0;
					timer_reset = 1'b1;
					game_over = 1'b1;
					game_menu = 1'b0;
				end
				
				Menu_Buffer:
				begin
					score_reset = 1'b0;
					timer_reset = 1'b1;
					game_over = 1'b1;
					game_menu = 1'b0;
				end
				
				default:;
//				begin
//					sec_timer_start = 1'b0;
//					obj0 = 1'b0;
//					obj1 = 1'b0;
//					obj2 = 1'b0;
//					obj3 = 1'b0;
//				end
			endcase
		end
endmodule
