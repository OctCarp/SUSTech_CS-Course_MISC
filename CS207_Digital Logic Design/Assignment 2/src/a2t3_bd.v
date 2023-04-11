`timescale 1ns / 1ps

module a2t3_bd(x, y);
	input[3: 0] x;
	output reg y;

	always@(*)
		y = 4'b1111 - x + 1;
endmodule