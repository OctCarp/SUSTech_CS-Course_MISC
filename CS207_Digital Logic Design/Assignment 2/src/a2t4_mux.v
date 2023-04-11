module a2t4_mux (x, y);
    input[4: 0] x;
    output y;

    wire[15: 0] in;
    
    and (in[0], x[0]);
    and (in[1], ~x[0]);
    and (in[2], ~x[0]);
    and (in[3], 0);
    and (in[4], ~x[0]);
    and (in[5], 0);
    and (in[6], 0);
    and (in[7], 0);
    and (in[8], ~x[0]);
    and (in[9], 0);
    and (in[10], 0);
    and (in[11], 0);
    and (in[12], 0);
    and (in[13], 0);
    and (in[14], 0);
    and (in[15], 0);

    mux16to1 mux(in, x[4: 1], y);

endmodule
