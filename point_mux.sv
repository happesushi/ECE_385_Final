module point_mux ( input        point_mux0, point_mux1, point_mux2, point_mux3,
						 input  [3:0] points0, points1, points2, points3,
						 output [3:0] score_in
					  );
					  
always_comb
begin
	if (point_mux0)
		score_in = points0;
	else if (point_mux1)
		score_in = points1;
	else if (point_mux2)
		score_in = points2;
	else if (point_mux3)
		score_in = points3;
	else
		score_in = 4'b0000;
end

endmodule
