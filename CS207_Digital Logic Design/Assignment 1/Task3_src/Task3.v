`timescale 1ns / 1ps

module Task3(a, b, c, d, o1, o2, o3);
input  a, b, c, d;	
output  o1, o2, o3;
    assign o1 = (~a&~b&~c&~d) | (~a&~b&c&~d) | (~a&~b&c&d) | (~a&b&c&~d) | (~a&b&c&d)
        | (a&~b&c&~d) | (a&~b&c&d) | (a&b&~c&~d) | (a&b&~c&d) | (a&b&c&d);
    assign o2 = (a|b|c|~d) & (a|~b|c|d) & (a|~b|c|~d) & (~a|b|c|d) & (~a|b|c|~d) & (~a|~b|~c|d);
    assign o3 = (~b&c&~d) | (~a&c&~d) | (~a&~b&~d) | (a&b&~c)|(c&d);
endmodule
