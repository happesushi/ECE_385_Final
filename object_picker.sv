module object_picker ( input  logic       Clk, Reset,
							  input  logic [8:0] rand_obj,
							  output logic [1:0] obj_code
							);
							
	// obj_code:
	//       00: Wasabi
	// 		01: 1pt Sushi
	//       10: 2pt Sushi
	// 		11: 3pt Sushi
	 
							
	always_ff @ (posedge Clk)
	begin
		if (Reset)
			obj_code <= 0;
		else if (rand_obj <= 9'd255)
			obj_code <= 2'b01;
		else if (rand_obj <= 9'd383)
			obj_code <= 2'b10;
		else if (rand_obj <= 9'd448)
			obj_code <= 2'b11;
		else
			obj_code <= 2'b00;
	end
	
endmodule
