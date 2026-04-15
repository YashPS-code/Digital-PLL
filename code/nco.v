module nco #(
    parameter base_freq = 10'd4
)(
    input clk,
    input rst_n,
    input signed [20:0] corr_val,
    output reg gen_freq
);

reg [20:0] counter;
wire signed [20:0] new_freq;

assign new_freq = base_freq + corr_val;

always @(posedge clk) begin
    if(!rst_n) begin
        counter <= 0;
        gen_freq <= 0;
    end else begin
        if(counter >= {new_freq[9:0]}) begin
            gen_freq <= ~gen_freq;
            counter <= 0;
        end else counter <= counter + 1'b1;
    end
end

endmodule