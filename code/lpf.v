module lpf #(
    parameter Kp = 10'b000_1000100,   //Q4.6
    parameter Ki = 10'b0_000010000    //Q1.9
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
reg [9:0] i_val_temp3, i_val_temp4;
assign i_val_temp1 = Ki*phase_err;
assign i_val_temp2 = {i_val_temp1[15:6]};
reg state;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        i_val_temp3 <= 10'b0;
        i_val_temp4 <= 10'b0;
        state <= 0;
    end else begin
        if(!state) i_val_temp4 <= i_val_temp2 + i_val_temp3;
        else i_val_temp4 <= i_val_temp3;
        state <= ~state;
    end
end

assign i_val = {3'd0, i_val_temp4[9:3]};

assign corr_val = i_val + p_val;

endmodule