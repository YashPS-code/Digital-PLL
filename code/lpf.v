module lpf(
    input clk,
    input rst_n,
    input up,
    input down,
    input signed [9:0] Kp, //Q4.6
    input signed [9:0] Ki, //Q1.9
    output signed [20:0] corr_val
);

reg signed [20:0] avg_phase;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        avg_phase <= 0;
    end else begin
        if(up) avg_phase <= avg_phase - 1'b1;
        else if(down) avg_phase <= avg_phase + 1'b1;
    end
end

wire signed [23:0] i_val, p_val;

wire signed [29:0] p_val_temp;
assign p_val_temp = Kp*avg_phase;
assign p_val = {p_val_temp[29:6]}; //24bits

wire signed [29:0] i_val_temp1;
assign i_val_temp1 = Ki*avg_phase;
reg signed [49:0] i_val_temp2, i_val_temp3;
reg signed state;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        i_val_temp3 <= 0;
        i_val_temp2 <= 0;
        state <= 0;
    end else begin
        if(!state) i_val_temp3 <= i_val_temp2 + i_val_temp1;
        else i_val_temp2 <= i_val_temp3;
        state <= ~state;
    end
end

assign i_val = {i_val_temp3[32:9]};

assign corr_val = i_val + p_val;

endmodule