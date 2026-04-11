`timescale 1ns / 1ps

module test_dpll;
    reg clk;
    reg rst_n;
    reg in_signal;
    wire out_signal;
    wire [10:0] corr_val;
    wire [5:0] phase;

    dpll utt(
        .clk(clk),
        .rst_n(rst_n),
        .in_signal(in_signal),
        .out_signal(out_signal),
        .corr_val1(corr_val),
        .phaseer(phase)
    );

    integer delay;
    integer lock_count = 0;
    integer unlock_count = 0;
    integer prev_lock_cnt = 0;
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
        for(i = 0; i < 15; i = i + 1) begin
            repeat(35) begin
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

    always @(posedge clk) begin
        if(t_in > 0) begin
            if((t_out - t_in) < 64'd10) lock_count <= lock_count + 1;
            else begin
                lock_count <= 0;
                unlock_count <= unlock_count + 1;
            end
        end

        if(lock_count > 100) begin
            if(prev_lock_cnt != unlock_count) $display("Lock at %0t", $time);
            prev_lock_cnt <= unlock_count;
        end
    end

    initial begin
        #40_000;
        $display("Simulation Ending.....");
        $stop;
    end

endmodule