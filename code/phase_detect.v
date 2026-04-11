module phase_detect(
    input clk,
    input rst_n,
    input ref_freq,         // Reference Frequency
    input nco_fb,           // NCO Feedback
    output reg [5:0] phase_err
);

// XOR Detector

reg [5:0] samp_cnt, err_cnt;

always @(posedge clk) begin
    if(!rst_n) begin
        samp_cnt <= 0;
        err_cnt <= 0;
    end else begin
        samp_cnt <= samp_cnt + 1'b1;
        if(nco_fb ^ ref_freq) err_cnt <= err_cnt + 1'b1;
        if(&samp_cnt) begin
            err_cnt <= 0;
            phase_err <= err_cnt;
        end
    end
end

endmodule