`timescale 1ns / 1ps

module a2t1_sim ();
    reg[3: 0] sx;
    wire y_sxor, y_snand;
	a2t1_xor sxor(sx, y_sxor);
	a2t1_nand snand(sx, y_snand);
	
	initial begin
		sx = 4'b0000;
		repeat(15) #10 sx = sx + 1;
    	#10 $finish();
	end
endmodule
