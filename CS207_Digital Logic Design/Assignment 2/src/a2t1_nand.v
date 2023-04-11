`timescale 1ns / 1ps

module a2t1_nand(x, y);
	input[3: 0] x;
	output y;
	wire n01, n00, n11, xor1, n23, n22, n33, xor2;
	wire o12, o11, o22;

	nand(n01, x[0], x[1]);
	nand(n00, n01, x[0]);
	nand(n11, n01, x[1]);
	nand(xor1, n00, n11);
	nand(n23, x[2], x[3]);
	nand(n22, n23, x[2]);
	nand(n33, n23, x[3]);
	nand(xor2, n22, n33);

	nand(o12, xor1, xor2);
	nand(o11, o12, xor1);
	nand(o22, o12, xor2);
	nand(y, o11, o22);
endmodule