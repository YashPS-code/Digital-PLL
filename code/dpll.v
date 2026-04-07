module dpll(
    input clk,
    input rst_n,
    input in_signal,
    output out_signal
);

wire nco_fb;
wire [ 1: 0] pd_out;

phase_detect pd(                // Phase Detector
    .clk(clk),
    .rst_n(rst_n),
    .ref_freq(in_signal),
    .nco_fb(nco_fb),
    .pd_out(pd_out)
);

lpf lpf(                        // Low Pass Filter
    .clk(clk)
);

nco nco(                        // Numerically Controlled Oscillator
    .clk(clk),

    .gen_freq(nco_fb)
);

assign out_signal = nco_fb;

endmodule