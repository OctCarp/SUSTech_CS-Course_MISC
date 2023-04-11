`timescale 1ns / 1ps

module mux16to1 (x, sel, y);
    input[15: 0] x;
    input[3: 0] sel;
    output reg y;
    
    always @(*) y = x[sel];

endmodule
