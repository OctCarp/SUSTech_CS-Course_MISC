`timescale 1ns / 1ps

module DeMorgan2bit_df(a, b, cos, poc, cop, soc);
input [1: 0] a, b;	
output [1: 0] cos, poc, cop, soc;
    assign cos[0] = ~(a[0] | b[0]);
    assign cos[1] = ~(a[1] | b[1]);
    assign poc[0] = ~a[0] & ~b[0];
    assign poc[1] = ~a[1] & ~b[1];
    assign cop[0] = ~(a[0] & b[0]);
    assign cop[1] = ~(a[1] & b[1]);
    assign soc[0] = ~a[0] | ~b[0];
    assign soc[1] = ~a[1] | ~b[1];
endmodule
