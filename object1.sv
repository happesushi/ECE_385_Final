//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module object1(input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,			 // The clock indicating a new frame (~60Hz)
									  object_on,
					//input [7:0]	  keycode, 	
               input [9:0]   DrawX, DrawY,		 // Current pixel coordinates
					input [9:0]	  object_position, tray_position,
					input [1:0]   obj_code,
					output[3:0]   points,
               output logic  is_ball, point_mux, combo_reset,  // Whether current pixel belongs to ball or background
					output[13:0]  object_address
              );
    
    logic     [9:0] Ball_X_Center;  // Random position on the X axis
	 logic     [9:0] tray_max, tray_min;
	 logic     [9:0] object_offset;
	 logic           chute_deployed;
	 
	 assign    tray_max = tray_position + 10'h19;
	 assign    tray_min = tray_position + 10'h3e7;
	 
    parameter [9:0] Ball_Y_Center = 10'd0;    // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd0;      // Step size on the X axis
    logic     [9:0] Ball_Y_Step;              // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd16;	       // Ball size
	 logic     [9:0] Chute_Deploy_Height;
     
	 //assign Ball_X_Center = object_position; 
	 
//	 always_ff @ (posedge Clk)
//	 begin
//		if (obj_code == )
//			Chute_Deploy_Height <= 
//	 end
	 

		
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
	 
	 always_comb
	 begin
		if(Ball_Y_Pos_in >= Chute_Deploy_Height)
			begin
				Ball_Y_Step = 10'd2;
			end
		
		else
			begin
				Ball_Y_Step = 10'd4;
			end
		
	 end
    
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
		  if (Reset)
		  begin
				Ball_X_Pos <= object_position;//10'd660;
            Ball_Y_Pos <= 10'd510;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
				point_mux  <= 1'b0;
				combo_reset <= 1'b0;
				object_offset <= 10'd0;
				chute_deployed <= 1'b0;
		  end
        else if (object_on)
        begin
            Ball_X_Pos <= object_position;
				Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= Ball_Y_Step;
				point_mux  <= 1'b0;
				combo_reset <= 1'b0;
				chute_deployed <= 1'b0;
				if (obj_code == 2'b11)
				begin
					Chute_Deploy_Height <= 10'd300;
					points <= 4'b0011;
					object_offset <= 10'd0;
				end
				else if (obj_code == 2'b10)
				begin
					Chute_Deploy_Height <= 10'd175;
					points <= 4'b0010;
					object_offset <= 10'd32;
				end
				else if (obj_code == 2'b01)
				begin
					Chute_Deploy_Height <= 10'd75;
					points <= 4'b0001;
					object_offset <= 10'd64;
				end
				else
				begin
					Chute_Deploy_Height <= 10'd490;
					points <= 4'b0000;
					object_offset <= 10'd96;
				end
		  end
        else
		  begin
				if((Ball_Y_Pos_in >= 10'd415) && (Ball_Y_Pos_in <= 10'd425) && (Ball_X_Pos >= tray_min) && (Ball_X_Pos <= tray_max))
				begin
					Ball_X_Pos <= Ball_X_Pos_in;
					Ball_Y_Pos <= 10'd510;
					if (object_offset != 10'd96)
					begin
						point_mux  <= 1'b1;
						combo_reset <= 1'b0;
					end
					else
						combo_reset <= 1'b1;
					chute_deployed <= 1'b0;
				end
				else if(Ball_Y_Pos_in >= 10'd500 && Ball_Y_Pos_in < 10'd510)
				begin
					//Ball_X_Pos <= object_position;
					//Ball_Y_Pos <= 10'd0;
					//Ball_Y_Motion <= Ball_Y_Motion_in;
					//Ball_X_Pos <= 10'd660;
					point_mux  <= 1'b0;
					if (object_offset != 10'd96)
						combo_reset <= 1'b1;
					chute_deployed <= 1'b0;
				end
				else if(Ball_Y_Pos_in >= 10'd510)
				begin
					point_mux  <= 1'b0;
					combo_reset <= 1'b0;
					chute_deployed <= 1'b0;
				end
				else
				begin
					//Ball_X_Pos <= Ball_X_Pos_in;
					Ball_Y_Pos <= Ball_Y_Pos_in;
					//Ball_X_Motion <= Ball_X_Motion_in;
					Ball_Y_Motion <= Ball_Y_Motion_in;
					point_mux  <= 1'b0;
					combo_reset <= 1'b0;
					if(Ball_Y_Pos_in >= Chute_Deploy_Height)
						chute_deployed <= 1'b1;
				end
			end
    end
    
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        // Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
		  //  Ball_X_Motion_in = 10'b0;
				Ball_Y_Motion_in = Ball_Y_Step;
				
										
					 
            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
        end

        
    end
    

int DistX, DistY, Size;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign Size = Ball_Size;
    always @ (*) begin
//	 if (object_on)
//	 begin
        if ( Size > DistY && (0 - Size) < DistY && Size > DistX && (0 - Size) < DistX && chute_deployed == 1'b0 && object_offset != 96) 
		  begin
				object_address = (DrawX - (Ball_X_Pos - Size) + object_offset) + (DrawY - (Ball_Y_Pos - Size)) * 128;
            is_ball = 1'b1;
		  end
		  else if ( Size > DistY && (0 - (Size + 32)) < DistY && Size > DistX && (0 - Size) < DistX && chute_deployed == 1'b1 && object_offset != 96)
		  begin
				object_address = (DrawX - (Ball_X_Pos - Size) + object_offset) + (DrawY - (Ball_Y_Pos - Size) + 64) * 128;
            is_ball = 1'b1;
		  end
		  else if ( Size > DistY && (0 - Size) < DistY && Size > DistX && (0 - Size) < DistX && object_offset == 96)
		  begin
				object_address = (DrawX - (Ball_X_Pos - Size) + object_offset) + (DrawY - (Ball_Y_Pos - Size) + 32) * 128;
            is_ball = 1'b1;
		  end
        else
            is_ball = 1'b0;
//	 end
    end
    
endmodule
