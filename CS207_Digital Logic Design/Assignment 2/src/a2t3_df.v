`timescale 1ns / 1ps

module a2t3_df(x, y);
	input[3: 0] x;
	output[3: 0] y;

	assign y = 4'b1111 - x + 1;
endmodule