module dpll#(
    parameter Kp = 10'sb0001_000010,   //Q4.6
    parameter Ki = 10'sb0_0000010001    //Q1.9
)(
    input clk,
    input rst_n,
    input in_signal,
    output out_signal,
    output [10:0] cor_val
);

wire nco_fb;
wire phase_err;

phase_detect pd(                // Phase Detector
    .ref_freq(in_signal),
    .nco_fb(nco_fb),
    .phase_err(phase_err)
);

wire signed [20:0] corr_val;
assign cor_val = corr_val;

wire signed [9:0] K_p, K_i;
assign K_p = Kp;
assign K_i = Ki;

lpf lpf(                        // Low Pass Filter
    .clk(clk),
    .rst_n(rst_n),
    .phase_err(phase_err),
    .Kp(K_p),
    .Ki(K_i),
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