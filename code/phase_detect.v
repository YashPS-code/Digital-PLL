module phase_detect(
    input ref_freq,         // Reference Frequency
    input nco_fb,           // NCO Feedback
    output phase_err
);

// XOR Detector
assign phase_err = nco_fb ^ ref_freq;

endmodule