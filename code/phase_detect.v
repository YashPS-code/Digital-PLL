module phase_detect(
    input clk,
    input rst_n,
    input ref_freq,         // Reference Frequency
    input nco_fb,           // NCO Feedback
    output reg [ 1: 0] pd_out
);

//XOR Detector

reg [10: 0] counter;

always @(posedge clk) begin
    if(!rst_n) begin
        pd_out <= 0;
    end else begin
        if(nco_fb ^ ref_freq) begin
            counter <= counter + 1'b1;
        end else begin
            counter <= 0;
            pd_out <= 0;
        end
    end
end

endmodule