`timescale 1ns / 1ps


module UnsignedMultiplier_sim( );
reg [1: 0] sin1,sin2;
wire [3: 0] sled;
UnsignedMultiplier task1(
    sin1, sin2, sled
);
initial begin 
    sin1 = 2'b0; sin2 = 2'b0;
    repeat(15) #10 {sin1, sin2} = {sin1, sin2} + 1;
    #10 $finish();
end
endmodule
