`timescale 1ns / 1ps

module DeMorgan2bit_sd(a, b, cos, poc, cop, soc);
input [1: 0] a,b;   
output [1: 0] cos, poc, cop, soc;
wire na0, nb0, na1, nb1;
    not (na0, a[0]);
    not (nb0, b[0]);
    not (na1, a[1]);
    not (nb1, b[1]);
    nor (cos[0], a[0], b[0]);
    nor (cos[1], a[1], b[1]);
    and (poc[0], na0, nb0);
    and (poc[1], na1, nb1);
    nand (cop[0], a[0], b[0]);
    nand (cop[1], a[1], b[1]);
    or (soc[0], na0, nb0);
    or (soc[1], na1, nb1);
endmodule