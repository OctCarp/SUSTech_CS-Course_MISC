`timescale 1ns / 1ps

module a2t3_sim ();
    reg[3: 0] sx;
    wire[3: 0] y_sdf, y_sbd;
	a2t3_df df(sx, y_sdf);
	a2t3_bd bd(sx, y_sbd);
	
	initial begin
		sx = 4'b0000;
		repeat(15) #10 sx = sx + 1;
    	#10 $finish();
	end
	
endmodule