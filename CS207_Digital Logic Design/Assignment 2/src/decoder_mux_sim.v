`timescale 1ns / 1ps

module decoder_mux_sim ();
    reg dc_sne;
    reg[1: 0] dc_sx;
    reg[15: 0] mux_sx;
    reg[3: 0] mux_ssel; 
    wire[3: 0] dc_y_s;
    wire  mux_y_s;
    
    d74139 dc(dc_sne, dc_sx, dc_y_s);
    mux16to1 mux(mux_sx, mux_ssel, mux_y_s);
    
    initial begin
        {dc_sne, dc_sx} = 3'b000;
        repeat(7) #10 {dc_sne, dc_sx} = {dc_sne, dc_sx} + 1;
        #10 dc_sne = 1;
        dc_sx = 0;
        //#10 $finish;
    end

    initial begin
        mux_sx = 16'b0000_0000_0000_0000;
        mux_ssel = 4'h0;
        #10 mux_sx = mux_sx + 1;
        repeat(15) #10 begin
            mux_sx = mux_sx * 2;
            mux_ssel = mux_ssel + 1;
        end
        #10 $finish;
    end

endmodule

    
    
    