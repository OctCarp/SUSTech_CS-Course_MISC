`timescale 1ns / 1ps

module UnsignedMultiplier(in1, in2, product_led);
input [1: 0] in1, in2;	
output [3: 0]  product_led;
    assign product_led[0] = in1[0]&in2[0];
    assign product_led[1] = (~(in1[1]&in2[0]) & (in1[0]&in2[1]))
        | (~(in1[0]&in2[1]) & (in1[1]&in2[0]));
    assign product_led[2] = ((in1[1]&in2[0]) & ~(in1[1]&in2[1]) & (in1[0]&in2[1]))
        | (~(in1[1]&in2[0]) & (in1[1]&in2[1])) | ((in1[1]&in2[1]) & ~(in1[0]&in2[1]));
    assign product_led[3] = (in1[1]&in2[0]) & (in1[1]&in2[1] & (in1[0]&in2[1]));
endmodule
