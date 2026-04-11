module nco #(
    parameter base_freq = 10'd4
)(
    input clk,
    input rst_n,
    input [10:0] corr_val,
    output reg gen_freq
);

reg [10:0] counter;
wire [10:0] new_freq;

assign new_freq = base_freq + corr_val;

always @(posedge clk) begin
    if(!rst_n) begin
        counter <= 0;
        gen_freq <= 0;
    end else begin
        if(counter >= new_freq) begin
            gen_freq <= ~gen_freq;
            counter <= 0;
        end else counter <= counter + 1'b1;
    end
end

endmodule