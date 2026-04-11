module lpf #(
    parameter Kp = 10'b000_1000000,   //Q4.6
    parameter Ki = 10'b0_000001000    //Q1.9
)(
    input clk,
    input rst_n,
    input [5:0] phase_err,
    output [10:0] corr_val
);

wire [9:0] i_val, p_val;

wire [15:0] p_val_temp;
assign p_val_temp = Kp*phase_err;
assign p_val = {p_val_temp[15:6]};

wire [15:0] i_val_temp1;
wire [9:0] i_val_temp2;
reg [9:0] i_val_temp3;
assign i_val_temp1 = Ki*phase_err;
assign i_val_temp2 = {i_val_temp1[15:6]};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        i_val_temp3 <= 0;
    else
        i_val_temp3 <= i_val_temp2 + i_val_temp3;
end

assign i_val = {3'd0, i_val_temp3[9:3]};

assign corr_val = i_val + p_val;

endmodule