module nco #(
    parameter base_freq = 20'd2
)(
    input clk,
    input rst_n,
    input [12:0] corr_val,
    output reg gen_freq
);

reg [21:0] counter;
wire [21:0] ref_freq;

assign ref_freq = base_freq + corr_val;

always @(posedge clk) begin
    if(!rst_n) begin
        counter <= 0;
        gen_freq <= 0;
    end else begin
        if(counter >= ref_freq) begin
            gen_freq <= ~gen_freq;
            counter <= 0;
        end else counter <= counter + 1'b1;
    end
end

endmodule