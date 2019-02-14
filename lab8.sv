//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk, start_game, game_reset;
    logic [7:0] keycode;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h    <= ~(KEY[0]);        // The push buttons are active low
		  start_game <= ~(KEY[3]);
		  game_reset <= ~(KEY[1]) || ~(KEY[2]) || ~(KEY[3]);
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
//	 logic [1:0] game_mode;
//	 logic [2:0] next_fall;
//	 logic [9:0] object_position;	
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     nios_system nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset),
									  .key1_export_export({7'b0, KEY[1]}),
									  .key2_export_export({7'b0, KEY[2]}),
									  .key3_export_export({7'b0, KEY[3]})
									  
    );
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    logic [9:0] DrawX,DrawY, object_position0, object_position1, object_position2, object_position3, tray_position;
	 logic       is_ball, is_boat, is_object, is_digit, is_text, is_title;
	 logic [8:0] rand_position0, rand_position1, rand_position2, rand_position3, rand_obj;
	 logic       timer_reset, score_reset, time_up;
	 logic       obj0, obj1, obj2, obj3, game_over, game_menu;
	 logic [1:0] obj_code;
	 logic [7:0] time_left, score0, score1, score2, score3; // Score stored in 4 different sections to simplify displaying it.
	 logic [3:0] score_inc, score_in, points0, points1, points2, points3;
	 logic       point_mux0, point_mux1, point_mux2, point_mux3;
	 logic       combo_reset0, combo_reset1, combo_reset2, combo_reset3;
	 logic [9:0] combo_count;
	 
	 // ROM signals
	 logic [10:0] tray_address, boat_address;
//	 logic [13:0] object_address;
	 logic [15:0] background_address;
	 logic [16:0] title_address;
	 logic [13:0] object_address0, object_address1, object_address2, object_address3, digit_address;
	 logic [12:0] text_address;
	 logic [15:0] tray_color, boat_color, object_color0, object_color1, object_color2, object_color3, digit_color, text_color;
	 logic [15:0] background_color, title_color;
//	 logic [4:0]  tray_data_out, boat_data_out, background_data_out, text_data_out, object_data_out;
//	 logic [3:0]  text_index;
	 assign background_address = ((DrawX - 80) >> 1) + ((DrawY >> 1) * 240);
//	 assign title_address = (DrawX - 80) + (DrawY * 480);
	 
	 always_ff @ (posedge Clk)
	 begin
		if (rand_position0 < 480)
			object_position0 = {1'b0, rand_position0} + 10'd80;
		else
			object_position0 = ({1'b0, rand_position0} - 480) * 15 + 80;
		
		if (rand_position1 < 480)
			object_position1 = {1'b0, rand_position1} + 10'd80;
		else
			object_position1 = ({1'b0, rand_position1} - 480) * 15 + 80;
		
		if (rand_position2 < 480)
			object_position2 = {1'b0, rand_position2} + 10'd80;
		else
			object_position2 = ({1'b0, rand_position2} - 480) * 15 + 80;
		
		if (rand_position3 < 480)
			object_position3 = {1'b0, rand_position3} + 10'd80;
		else
			object_position3 = ({1'b0, rand_position3} - 480) * 15 + 80;
	 end
//	 assign object_position1 = {1'b0, rand_position1} + 10'd80;
//	 assign object_position2 = {1'b0, rand_position2} + 10'd80;
//	 assign object_position3 = {1'b0, rand_position3} + 10'd80;
	 
//	 always_ff @ (posedge Clk)
//	 begin
//			if (is_object0)
//			begin
//				object_address <= object_address0;
//			end
//			else if (is_object1)
//			begin
//				object_address <= object_address1;
//			end
//			else if (is_object2)
//			begin
//				object_address <= object_address2;
//			end
//			else if (is_object3)
//			begin
//				object_address <= object_address3;
//			end
//			else
//			begin
//				object_address <= 0;
//			end
//	 end
	 
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_CLK(VGA_CLK),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_SYNC_N(VGA_SYNC_N),
		.DrawX(DrawX),
		.DrawY(DrawY)
	 );
    
	 
	 
	 
	 
//---Objects-------------------------------------------------------------------------------------------------------------------------------------------
	 
    ball tray_instance
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.frame_clk(VGA_VS),
		.keycode(keycode),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.is_ball(is_ball),
		.tray_position(tray_position),
		.tray_address(tray_address)
	 );
	 
	 object_picker obj_picker0
	 (
		.Clk(Clk),
		.Reset(Reset),
		.rand_obj(rand_obj),
		.obj_code(obj_code)
	 );
	 
	 object1 object0_instance
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.object_on(obj0),
		.frame_clk(VGA_VS),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.obj_code(obj_code),
		.object_position(object_position0),// + 10'h80),
		.tray_position(tray_position),
		.is_ball(is_object0),
		.points(points0),
		.point_mux(point_mux0),
		.combo_reset(combo_reset0),
		.object_address(object_address0)
	 );

	 object1 object1_instance
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.object_on(obj1),
		.frame_clk(VGA_VS),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.obj_code(obj_code),
		.object_position(object_position1),// + 10'h80),
		.tray_position(tray_position),
		.is_ball(is_object1),
		.points(points1),
		.point_mux(point_mux1),
		.combo_reset(combo_reset1),
		.object_address(object_address1)
	 );
	 
	 object1 object2_instance
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.object_on(obj2),
		.frame_clk(VGA_VS),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.obj_code(obj_code),
		.object_position(object_position2),// + 10'h80),
		.tray_position(tray_position),
		.is_ball(is_object2),
		.points(points2),
		.point_mux(point_mux2),
		.combo_reset(combo_reset2),
		.object_address(object_address2)
	 );
	 
	 object1 object3_instance
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.object_on(obj3),
		.frame_clk(VGA_VS),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.obj_code(obj_code),
		.object_position(object_position3),// + 10'h80),
		.tray_position(tray_position),
		.is_ball(is_object3),
		.points(points3),
		.point_mux(point_mux3),
		.combo_reset(combo_reset3),
		.object_address(object_address3)
	 );
	 
	 
	 
	 
	 
//---Randomizers---------------------------------------------------------------------------------------------------------------------------------------
	 
	 random rand_obj0
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.rand_in(9'b111010100),
		.rand_out(rand_obj)
	 );
	 
	 random randomizer0
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.rand_in(9'b111010100),
		.rand_out(rand_position0)
	 );
	 
	 random randomizer1
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.rand_in(9'b001101100),
		.rand_out(rand_position1)
	 );
	 
	 random randomizer2
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.rand_in(9'b100101000),
		.rand_out(rand_position2)
	 );
	 
	 random randomizer3
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.rand_in(9'b100100111),
		.rand_out(rand_position3)
	 );
	 
	 
	

//---Scoring & Timer-----------------------------------------------------------------------------------------------------------------------------------	

	 score scoring0
	 (
		.Clk(Clk),
		.Reset(score_reset || Reset_h),//KEY[3]
		.score_inc(score_inc),//{2'b0,  KEY[2], KEY[1]}
		.score0(score0),
		.score1(score1),
		.score2(score2),
		.score3(score3)
	 );
	 
	 point_mux point_mux_instance
	 (
		.point_mux0(point_mux0),
		.point_mux1(point_mux1),
		.point_mux2(point_mux2),
		.point_mux3(point_mux3),
		.points0(points0),
		.points1(points1),
		.points2(points2),
		.points3(points3),
		.score_in(score_in)
	 );
	 
	 combo_counter combo_counter0
	 (
		.Clk(Clk),
		.combo_inc(point_mux0 || point_mux1 || point_mux2 || point_mux3),
		.combo_kill(combo_reset0 || combo_reset1 || combo_reset2 || combo_reset3),
		.combo_count(combo_count)
	 );
	 
	 combo combo0
	 (
		.combo_count(combo_count),
		.Clk(Clk),
		.score_in(score_in),
		.score_out(score_inc)
	 );
	 
	 timer timer0
	 (
		.Clk(Clk),
		.Reset(timer_reset || Reset_h),//KEY[3]
		.time_left(time_left),
		.time_up(time_up)
	 );
	 
	 scoreboard scoreboard
	 (
		.score0(score0[3:0]),
		.score1(score1[3:0]),
		.score2(score2[3:0]),
		.score3(score3[3:0]),
		.*
	 );
	 
	 
	 
	 
	 
//---State Machine-------------------------------------------------------------------------------------------------------------------------------------

	 parachute parachute0
	 (
		.Clk(Clk),
		.Reset(Reset_h),
		.start_game(start_game),
		.game_reset(game_reset),
		.time_up(time_up),
		.timer_reset(timer_reset),
		.score_reset(score_reset),
		.game_over,
		.game_menu,
		.obj0(obj0),
		.obj1(obj1),
		.obj2(obj2),
		.obj3(obj3)
	 );
	 
	 
	 
	 
	 
//---ROMS----------------------------------------------------------------------------------------------------------------------------------------------
	 
	 trayROM trayROM
	 (
		.address(tray_address),
		.clock(~VGA_CLK),
		.q(tray_color)
	 );
//	 playerROM playerROM0
//	 (
//		.*
//	 );
	 
	 backgroundROM backgroundROM0
	 (
		.address(background_address),
		.clock(~VGA_CLK),
		.q(background_color)
	 );
	 
	 titleROM titleROM0
	 (
		.address(title_address),
		.clock(~VGA_CLK),
		.q(title_color)
	 );
	 
	 textROM textROM
	 (
		.address(text_address),
		.clock(~VGA_CLK),
		.q(text_color)
	 );
	 
	 digitROM digitROM
	 (
		.address(digit_address),
		.clock(~VGA_CLK),
		.q(digit_color)
	 );
	 
	 objectROM objectROM0
	 (
		.address(object_address0),
		.clock(~VGA_CLK),
		.q(object_color0)
	 );
	 
	 objectROM objectROM1
	 (
		.address(object_address1),
		.clock(~VGA_CLK),
		.q(object_color1)
	 );
	 
	 objectROM objectROM2
	 (
		.address(object_address2),
		.clock(~VGA_CLK),
		.q(object_color2)
	 );
	 
	 objectROM objectROM3
	 (
		.address(object_address3),
		.clock(~VGA_CLK),
		.q(object_color3)
	 );

	 
	 
	 
	 
//---Display-------------------------------------------------------------------------------------------------------------------------------------------

    title_screen title_screen
	 (
		.DrawX,
		.DrawY,
		.title_address,
		.is_title
	 );
	 
	 color_mapper color_instance
	 (
		.DrawX(DrawX),
		.DrawY(DrawY),
		.is_ball(is_ball),
		.is_boat(is_boat),
		.is_object0,
		.is_object1,
		.is_object2,
		.is_object3,
		.is_digit,
		.is_text,
		.is_title,
		.game_over,
		.game_menu,
//		.tray_data_out,
//		.boat_data_out,
//		.object_data_out,
//		.text_data_out,
//		.background_data_out,
		.tray_color,
		.boat_color,
		.object_color0,
		.object_color1,
		.object_color2,
		.object_color3,
		.digit_color,
		.text_color,
		.background_color,
		.title_color,
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B)
	 );
    
    // Display keycode on hex display
    HexDriver hex_inst_0 (score0[3:0], HEX0);
    HexDriver hex_inst_1 (score1[3:0], HEX1);
	 HexDriver hex_inst_2 (score2[3:0], HEX2);
	 HexDriver hex_inst_3 (score3[3:0], HEX3);
	 
	 HexDriver hex_inst_6 (time_left[3:0], HEX6);
	 HexDriver hex_inst_7 (time_left[7:4], HEX7);
	 
	 HexDriver hex_inst_4 (keycode[3:0], HEX4);
	 HexDriver hex_inst_5 (keycode[7:4], HEX5);
    
    
endmodule
