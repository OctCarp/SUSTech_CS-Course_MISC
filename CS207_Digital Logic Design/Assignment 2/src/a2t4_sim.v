`timescale 1ns / 1ps

module a2t4_sim ();
    reg[4: 0] sx;
    wire y_s_dc;
    wire y_s_mux;

    a2t4_dc dc(sx, y_s_dc);
    a2t4_mux mux(sx, y_s_mux);

    initial begin
        sx = 5'b00000;
        repeat (31) #10 sx = sx + 1;
        #10 $finish();
    end

endmodule