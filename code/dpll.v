module dpll(
    input clk,
    input rst_n,
    input in_signal,
    output out_signal,
    output [10:0] corr_val1,
    output [5:0] phaseer
);

wire nco_fb;
wire [5:0] phase_err;
assign phaseer = phase_err;

phase_detect pd(                // Phase Detector
    .clk(clk),
    .rst_n(rst_n),
    .ref_freq(in_signal),
    .nco_fb(nco_fb),
    .phase_err(phase_err)
);

wire [10:0] corr_val;
assign corr_val1 = corr_val;

lpf lpf(                        // Low Pass Filter
    .clk(clk),
    .rst_n(rst_n),
    .phase_err(phase_err),
    .corr_val(corr_val)
);

nco nco(                        // Numerically Controlled Oscillator
    .clk(clk),
    .rst_n(rst_n),
    .corr_val(corr_val),
    .gen_freq(nco_fb)
);

assign out_signal = nco_fb;

endmodule