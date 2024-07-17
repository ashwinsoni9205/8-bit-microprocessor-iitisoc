`timescale 1ns/1ps
module controller (
    input internal_clock,
    input halted,
    input resume,
    input restart,
    input controller_enable,
    output reg clk1,
    output reg clk2,
    output reg reset,
    output reg enable,
    output reg flush  // Added flush as an output
);

parameter [1:0] S0 = 2'b00;
parameter [1:0] S1 = 2'b01;
parameter [1:0] S2 = 2'b10;
parameter [1:0] S3 = 2'b11;

reg [1:0] state = 2'b00;
reg internal_halted, internal_restart;

always @(restart or halted) begin
    if (restart == 1)
        internal_restart <= 1;
    if (halted == 1)
        internal_halted <= 1;
    else
        internal_halted <= 0;
end

always @(posedge internal_clock) begin
    if (controller_enable) begin
        if (state == S2 && halted == 1'b1) begin
            internal_halted <= halted;
            state <= S3;
        end else
            state <= S2;

        if (internal_restart == 1'b1) begin
            state <= S0;
        end
        if (state == S3 && resume == 1'b1) begin
            state <= S2;
            internal_halted <= 0;
        end
        if (internal_halted == 1'b1) begin
            state <= S3;
        end

        case (state)
            S0: begin
                internal_restart <= 1'b0;
                internal_halted <= 1'b0;
                enable <= 1'b0;
                reset <= 1'b0;
                clk1 <= 0;
                clk2 <= 0;
                state <= S1;
                flush <= 1'b1; // Flush the pipeline
            end
            S1: begin 
                enable <= 1;
                reset <= 1;
                state <= S2;
                flush <= 1'b0;
            end
            S2: begin
                if (internal_halted)
                    state <= S3;
                else begin
                    reset <= 0;
                    clk1 <= 1'b1;
                    clk2 <= 1'b0;
                    #10;
                    clk1 <= 1'b0;
                    #10;
                    clk2 <= 1'b1;
                    #10;
                    clk2 <= 1'b0;
                    #10;
                end
            end
            S3: begin
                clk1 <= 1'b0;
                clk2 <= 1'b0;
                if (internal_restart) begin
                    state <= S0;
                    internal_halted <= 0;
                    internal_restart <= 0;
                    flush <= 1'b1; // Flush the pipeline
                end
            end
            default: begin
                state <= S0;
                internal_halted <= 1'b0;
                internal_restart <= 1'b0;
                flush <= 1'b1; // Flush the pipeline
            end
        endcase
    end else begin
        clk1 <= 0;
        clk2 <= 0;
        flush <= 1'b0; // Ensure flush is de-asserted when controller is not enabled
    end
end

endmodule
