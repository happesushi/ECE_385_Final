module random ( input  logic       Clk, Reset,
					 input  logic [8:0] rand_in,
					 output logic [8:0] rand_out
				  );
				  

reg [8:0] current, next;
wire rand_bit;
assign rand_bit = current[8] ^ current[5] ^ current[4] ^ current[0];
always @ (posedge Clk)
begin
	if (Reset)
	begin
			current <= rand_in;
	end
	else begin
			current <= next;
	end
	
	
end

always @ (*)
begin
	next = current;
	
	next = {current[7:0], rand_bit};

end

assign rand_out = current;

endmodule
