module phase_detect(
    input clk,
    input rst_n,
    input ref_freq,         // Reference Frequency
    input nco_fb,           // NCO Feedback
    output reg phase_err
);

// XOR Detector

always @(posedge clk) begin
    if(!rst_n) begin
        phase_err <= 0;
    end else begin
        phase_err <= nco_fb ^ ref_freq;
    end
end

endmodule