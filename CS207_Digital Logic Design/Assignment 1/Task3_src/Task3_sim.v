`timescale 1ns / 1ps


module Task3_sim( );
reg sa, sb, sc, sd;
wire so1, so2, so3;
Task3 task3(
    sa, sb, sc, sd, so1, so2, so3
);
initial begin 
    sa = 0; sb = 0; sc = 0; sd = 0;
    repeat(15) #10 {sa, sb, sc, sd} = {sa, sb, sc, sd} + 1;
    #10 $finish();
end
endmodule
