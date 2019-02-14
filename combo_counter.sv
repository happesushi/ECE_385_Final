module combo_counter ( input        Clk, combo_inc,
							  input        combo_kill,
							  output [9:0] combo_count
							);
							
always_ff @ (posedge Clk)
begin
	if (combo_kill)
		combo_count <= 0;
	else if (combo_count == 10'h3ff);
	else if (combo_inc)
		combo_count <= combo_count + 1;
end

endmodule
