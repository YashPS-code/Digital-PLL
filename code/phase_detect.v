module phase_detect(
    input clk,
    input rst_n,
    input ref_freq,         // Reference Frequency
    input nco_fb,           // NCO Feedback
    output reg up, down
);

// PFD(Phase Frequency Detector)

wire reset;

always @(posedge clk) begin
    if(!rst_n) up <= 0;
    else if(reset) up <= 0;
    else if(ref_freq) up <= 1;
end

always @(posedge clk) begin
    if(!rst_n) down <= 0;
    else if(reset) down <= 0;
    else if(nco_fb) down <= 1;
end

assign reset = up & down;

endmodule