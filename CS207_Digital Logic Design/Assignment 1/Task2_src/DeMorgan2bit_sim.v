`timescale 1ns / 1ps

module DeMorgan2bit_sim();
reg [1: 0] sa, sb;   
wire [1: 0] cos_df, poc_df, cop_df, soc_df, cos_sd, poc_sd, cop_sd, soc_sd;
DeMorgan2bit_df df(
    sa, sb, cos_df, poc_df, cop_df, soc_df
);
DeMorgan2bit_sd sd(
    sa, sb, cos_sd, poc_sd, cop_sd, soc_sd
);
initial begin 
    sa = 2'b0; sb = 2'b0;
    repeat(15) #10 {sa, sb} = {sa, sb} + 1;
    #10 $finish();
end
endmodule