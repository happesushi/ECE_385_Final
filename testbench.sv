module testbench();

timeunit 10ns;
timeprecision 1ns;

logic clk;
logic reset;
logic reset_h;
logic [8:0]  rand_position;
logic [9:0]  object_position, tray_position, tray_min, tray_max;
logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
logic [7:0]  VGA_R, VGA_G, VGA_B;
logic        VGA_CLK, VGA_SYNC_N, VGA_BLANK_N, VGA_VS, VGA_HS;
logic [1:0]  OTG_ADDR;
logic        OTG_CS_N, OTG_RD_N, OTG_WR_N, OTG_RST_N;
logic [12:0] DRAM_ADDR;
logic [1:0]  DRAM_BA;
logic [3:0]  DRAM_DQM;
logic        DRAM_RAS_N, DRAM_CAS_N, DRAM_CKE, DRAM_WE_N, DRAM_CS_N, DRAM_CLK;
wire  [31:0] DRAM_DQ;
logic        OTG_INT;
wire  [15:0] OTG_DATA;


lab8 lab8_0 (.CLOCK_50(clk), .KEY({1'b0, 1'b0, 1'b0, reset}), .*);

always_comb begin
		rand_position = lab8_0.rand_position;
		object_position = lab8_0.object1_instance.object_position;
		reset_h = lab8_0.Reset_h;
		tray_position = lab8_0.tray_position;
		tray_min = lab8_0.object1_instance.tray_min;
		tray_max = lab8_0.object1_instance.tray_max;
end

always begin
#1 clk = ~clk;
end

initial begin
	clk = 0;
end


initial begin
	reset = 0;
#2 reset = 1;
end

endmodule
