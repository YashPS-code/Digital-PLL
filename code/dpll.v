module dpll#(
    parameter Kp = 10'sb0000_00100001,   //Q4.6
    parameter Ki = 10'sb0_0000000100    //Q1.9
)(
    input clk,
    input rst_n,
    input in_signal,
    output out_signal,
    output up, down
);

wire nco_fb;

phase_detect pd(                // Phase Detector
    .clk(clk),
    .rst_n(rst_n),
    .ref_freq(in_signal),
    .nco_fb(nco_fb),
    .up(up),
    .down(down)
);

wire signed [20:0] corr_val;

wire signed [9:0] K_p, K_i;
assign K_p = Kp;
assign K_i = Ki;

lpf lpf(                        // Low Pass Filter
    .clk(clk),
    .rst_n(rst_n),
    .up(up),
    .down(down),
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