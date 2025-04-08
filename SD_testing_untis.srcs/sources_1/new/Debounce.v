`timescale 1ns / 1ps

module debounce (
    input  wire clk,        // 100MHz clock
    input  wire sw,         // Raw switch input (active high when pressed)
    output reg  debounced   // Debounced switch output
);

    // Calculate the number of clock cycles for a 50ms debounce period.
    // For 100MHz clock: 50ms * 100e6 = 5,000,000 cycles.
    parameter integer DEBOUNCE_COUNT_MAX = 5000000;

    // Counter for debouncing
    reg [22:0] count;  // 23 bits are enough to count up to 5e6 (~2^23 = 8,388,608)

    // State register to hold the last stable state of the switch.
    reg state;

    // Debounce logic: sample the switch at each clock edge.
    always @(posedge clk) begin
        // If the raw switch input is different from the last stable state...
        if (sw != state) begin
            // Increment the counter until it reaches the debounce limit.
            if (count < DEBOUNCE_COUNT_MAX)
                count <= count + 1;
            else begin
                // Once the input has been stable for the full debounce period,
                // update the stable state.
                state <= sw;
                count <= 0;
            end
        end else begin
            // If the switch input matches the stable state,
            // reset the counter.
            count <= 0;
        end
        
        // The debounced output reflects the stable state.
        debounced <= state;
    end

endmodule
