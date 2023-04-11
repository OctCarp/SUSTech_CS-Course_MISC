`timescale 1ns / 1ps

module a2t2_somin(x, y);
    input[3: 0] x;
    output y;
    wire s0, s1, s2, s3, s4, s5, s6, s7, s8, s9;
    
    and(s0, ~x[3], ~x[2], ~x[1], ~x[0]);
    and(s1, ~x[3], ~x[2], ~x[1], x[0]);
    and(s2, ~x[3], ~x[2], x[1], ~x[0]);
    and(s3, ~x[3], ~x[2], x[1], x[0]);
    and(s4, ~x[3], x[2], ~x[1], ~x[0]);
    and(s5, ~x[3], x[2], ~x[1], x[0]);
    and(s6, ~x[3], x[2], x[1], ~x[0]);
    and(s7, ~x[3], x[2], x[1], x[0]);
    and(s8, x[3], ~x[2], ~x[1], ~x[0]);
    and(s9, x[3], ~x[2], ~x[1], x[0]);
    
    or(y, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);

endmodule
