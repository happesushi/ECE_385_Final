//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input               is_ball, is_boat, is_object0, is_object1, is_object2, is_object3, is_digit, is_text, is_title, game_over, game_menu,          // Whether current pixel belongs to ball 
                                                              //   or background (computed in ball.sv)
                       input        [9:0]  DrawX, DrawY,       // Current pixel coordinates
//							  input        [4:0]  tray_data_out, boat_data_out, object_data_out, text_data_out, background_data_out,
							  input        [15:0] tray_color, boat_color, object_color0, object_color1, object_color2, object_color3, digit_color, text_color,
							  input        [15:0] background_color, title_color,
                       output logic [7:0]  VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;

//	 logic [23:0] palette [16];
//	 assign palette [0]  = 24'hff00ff; // Magenta (invisible)
//	 assign palette [1]  = 24'ha5f3ff; // Sky Blue
//	 assign palette [2]  = 24'hffffff; // White
//	 assign palette [3]  = 24'h023ca5; // Blue
//	 assign palette [4]  = 24'h000000; // Black
//	 assign palette [5]  = 24'h808080; // Grey
//	 assign palette [6]  = 24'h333333; // Dark Grey
//	 assign palette [7]  = 24'haaaaaa; // Light Grey
//	 assign palette [8]  = 24'hff5a02; // Orange
//	 assign palette [9]  = 24'hfa935b; // Light Orange
//	 assign palette [10] = 24'hb48a4d; // Brown
//	 assign palette [11] = 24'hffe468; // Yellow
//	 assign palette [12] = 24'h365e35; // Green
//	 assign palette [13] = 24'h72c274; // Light Green
//	 assign palette [14] = 24'he8bed0; // Pink
//	 assign palette [15] = 24'ha4141e; // Red
	 
	 logic [23:0] tray_color_out;
	 logic [23:0] boat_color_out;
	 logic [23:0] object_color_out0;
	 logic [23:0] object_color_out1;
	 logic [23:0] object_color_out2;
	 logic [23:0] object_color_out3;
	 logic [23:0] digit_color_out;
	 logic [23:0] text_color_out;
	 logic [23:0] background_color_out;
	 logic [23:0] title_color_out;
	 
	 assign tray_color_out   = {tray_color[14:10], {3{tray_color[10]}}, tray_color[9:5]  , {3{tray_color[ 5]}}, tray_color[4:0]  , {3{tray_color[ 0]}}};
	 assign boat_color_out   = {boat_color[14:10], {3{boat_color[10]}}, boat_color[9:5]  , {3{boat_color[ 5]}}, boat_color[4:0]  , {3{boat_color[ 0]}}};
	 assign object_color_out0 = {object_color0[14:10], {3{object_color0[10]}}, object_color0[9:5]  , {3{object_color0[ 5]}}, object_color0[4:0]  , {3{object_color0[ 0]}}};
	 assign object_color_out1 = {object_color1[14:10], {3{object_color1[10]}}, object_color1[9:5]  , {3{object_color1[ 5]}}, object_color1[4:0]  , {3{object_color1[ 0]}}};
	 assign object_color_out2 = {object_color2[14:10], {3{object_color2[10]}}, object_color2[9:5]  , {3{object_color2[ 5]}}, object_color2[4:0]  , {3{object_color2[ 0]}}};
	 assign object_color_out3 = {object_color3[14:10], {3{object_color3[10]}}, object_color3[9:5]  , {3{object_color3[ 5]}}, object_color3[4:0]  , {3{object_color3[ 0]}}};
	 assign digit_color_out  = {digit_color[14:10], {3{digit_color[10]}}, digit_color[9:5]  , {3{digit_color[ 5]}}, digit_color[4:0]  , {3{digit_color[ 0]}}};
	 assign text_color_out   = {text_color[14:10], {3{text_color[10]}}, text_color[9:5]  , {3{text_color[ 5]}}, text_color[4:0]  , {3{text_color[ 0]}}};
	 assign background_color_out = {background_color[14:10], {3{background_color[10]}}, background_color[9:5]  , {3{background_color[ 5]}}, background_color[4:0]  , {3{background_color[ 0]}}};
	 assign title_color_out = {title_color[14:10], {3{title_color[10]}}, title_color[9:5]  , {3{title_color[ 5]}}, title_color[4:0]  , {3{title_color[ 0]}}};
	 
    
    // Assign color based on is_ball signal
    always_comb
    begin
			// Draw the player
		  if (is_title == 1 && game_menu == 1 && title_color_out != 24'hff00ff)
		  begin
				Red   = title_color_out[23:16];
				Green = title_color_out[15:8];
				Blue  = title_color_out[7:0];
		  end
        else if (is_ball == 1'b1 && tray_color_out != 24'hff00ff) 
        begin
            Red   = tray_color_out[23:16];
            Green = tray_color_out[15:8];
            Blue  = tray_color_out[7:0];
        end
		  else if (is_boat == 1'b1 && boat_color_out != 24'hff00ff)
		  begin
				Red   = boat_color_out[23:16];
				Green = boat_color_out[15:8];
				Blue  = boat_color_out[7:0];
		  end
		  else if (is_object0 == 1'b1 && object_color_out0 != 24'hff00ff && game_over != 1)
		  begin
				Red   = object_color_out0[23:16];
            Green = object_color_out0[15:8];
				Blue  = object_color_out0[7:0];
		  end
		  else if (is_object1 == 1'b1 && object_color_out1 != 24'hff00ff && game_over != 1)
		  begin
				Red   = object_color_out1[23:16];
            Green = object_color_out1[15:8];
				Blue  = object_color_out1[7:0];
		  end
		  else if (is_object2 == 1'b1 && object_color_out2 != 24'hff00ff && game_over != 1)
		  begin
				Red   = object_color_out2[23:16];
            Green = object_color_out2[15:8];
				Blue  = object_color_out2[7:0];
		  end
		  else if (is_object3 == 1'b1 && object_color_out3 != 24'hff00ff && game_over != 1)
		  begin
				Red   = object_color_out3[23:16];
            Green = object_color_out3[15:8];
				Blue  = object_color_out3[7:0];
		  end
		  else if (is_digit == 1'b1 && digit_color_out != 24'hff00ff)
		  begin
				Red   = digit_color_out[23:16];
            Green = digit_color_out[15:8];
				Blue  = digit_color_out[7:0];
		  end
		  else if (is_text == 1'b1 && text_color_out != 24'hff00ff)
		  begin
				Red   = text_color_out[23:16];
            Green = text_color_out[15:8];
				Blue  = text_color_out[7:0];
		  end
		  else if (game_over == 1 && DrawX >= 280 && DrawY >= 208 && DrawY < 272 && DrawX < 360)
		  begin
				Red   = 8'h00;
            Green = 8'h00;
				Blue  = 8'h00;
		  end
		  else if (DrawX >= 80 && DrawX < 560)
		  begin
				Red   = background_color_out[23:16];
            Green = background_color_out[15:8];
				Blue  = background_color_out[7:0];
		  end
		  else //if (is_object2 == 1'b1)
		  begin
				Red   = 8'h00;//background_color[23:16];
            Green = 8'h00;//background_color[15:8];
				Blue  = 8'h00;//background_color[7:0];
		  end
//		  else if (is_object3 == 1'b1)
//		  begin
//				Red = 8'hff;
//            Green = 8'hff;
//				Blue = 8'h00;
//		  end
//        else 
//        begin
//            // Background with nice color gradient
//            Red = 8'h3f; 
//            Green = 8'h00;
//            Blue = 8'h7f - {1'b0, DrawX[9:3]};
//        end
    end 
    
endmodule
