`timescale 1ns / 1ps

module test_dpll;
    reg clk;
    reg rst_n;
    reg in_signal;
    wire out_signal;
    wire [10:0] cor_val;

    dpll utt(
        .clk(clk),
        .rst_n(rst_n),
        .in_signal(in_signal),
        .out_signal(out_signal),
        .cor_val(cor_val)
    );

    integer delay;
    integer i;
    integer freq;
    time t_in = 0, t_out = 0;

    initial begin
        clk = 0;
        freq = 16;
        forever #1 clk <= ~clk;
    end

    initial begin
        rst_n = 0;
        #50
        rst_n = 1;
    end

    initial begin
        in_signal = 0;
        #50
        for(i = 0; i < 12; i = i + 1) begin
            repeat(50) begin
                in_signal = ~in_signal;
                delay = freq + $urandom_range(0, 6);
                #(delay);
            end
            freq = freq + 8;
        end
    end

    always @(posedge in_signal) begin
        t_in <= $time;
    end

    always @(posedge out_signal) begin
        t_out <= $time;
        $display("Phase error = %0t", t_out - t_in);
    end
    
    initial begin
        #37_880;
        $display("Simulation Ending.....");
        $stop;
    end

endmodule