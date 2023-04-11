`timescale 1ns / 1ps

module a2t2_pomax(x, y);
	input[3: 0] x;
	output y;
	wire p10, p11, p12, p13, p14, p15;

	or(p10, ~x[3], x[2], ~x[1], x[0]);
	or(p11, ~x[3], x[2], ~x[1], ~x[0]);
	or(p12, ~x[3], ~x[2], x[1], x[0]);
	or(p13, ~x[3], ~x[2], x[1], ~x[0]);
	or(p14, ~x[3], ~x[2], ~x[1], x[0]);
	or(p15, ~x[3], ~x[2], ~x[1], ~x[0]);

	and(y, p10, p11, p12, p13, p14, p15);
endmodule