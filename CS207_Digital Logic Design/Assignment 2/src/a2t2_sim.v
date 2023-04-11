`timescale 1ns / 1ps

module a2t2_sim ();
    reg[3: 0] sx;
    wire y_ss, y_sp;
	a2t2_somin som(sx, y_ss);
	a2t2_pomax pom(sx, y_sp);
	
	initial begin
		sx = 4'b0000;
		repeat(15) #10 sx = sx + 1;
    	#10 $finish;
	end
endmodule