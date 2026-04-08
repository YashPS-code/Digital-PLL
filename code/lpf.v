module lpf #(
    parameter Kp = 10'd5,
    parameter Ki = 10'd6
)(
    input clk,
    input rst_n,
    input phase_err,
    output [12:0] corr_val   //2^13
);

reg [15:0] n_err, prev_err;
reg [15:0] counter;
reg [26:0] p_val;
reg [40:0] err_sum;
reg [41:0] i_val;
reg [41:0] pid_val;

always @(posedge clk) begin
    if(!rst_n) begin
        counter <= 0;
        n_err <= 0;
    end else begin
        counter <= counter + 1'b1;
        if(phase_err) n_err <= n_err + 1'b1;
    end
end

always @(posedge clk) begin
    if(!rst_n) begin
        p_val <= 0;
        prev_err <= 0;
        err_sum <= 0;
        i_val <= 0;
        pid_val <= 0;
    end else begin
        p_val <= Kp*n_err;
        prev_err <= n_err;
        err_sum <= err_sum + n_err;
        i_val <= Ki*err_sum;
        pid_val <= p_val + i_val;
    end
end

assign corr_val = pid_val >> 28;
endmodule