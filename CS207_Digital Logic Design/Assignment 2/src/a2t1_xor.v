`timescale 1ns / 1ps

module a2t1_xor(x, y);
	input[3: 0] x;
	output y;
	wire xor1, xor2;

	xor(xor1, x[0], x[1]);
	xor(xor2, x[2], x[3]);
	xor(y, xor1, xor2);
endmodule