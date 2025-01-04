`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2025 10:20:05 PM
// Design Name: 
// Module Name: ADC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ADC#(
    parameter CLK_DIV = 4,       // Clock divider for SPI SCLK (example)
    parameter ADC_BITS = 10      // Number of bits to capture from ADC
)
(
    input  wire        clk,      // 100 MHz system clock
    input  wire        rst,    // Active-high reset
    output reg         sclk,     // SPI clock to ADC
    output reg         cs_n,     // SPI chip-select (active low)
    input  wire        miso,     // SPI data from ADC
    output reg [9:0]   data_out, // 10-bit output data
    output reg         data_valid// Pulses high for 1 clk when data is ready
);
     //-------------------------------------------------
    // Local parameters for FSM states (Verilog-2001)
    //-------------------------------------------------
    localparam [1:0] IDLE  = 2'b00,
                     START = 2'b01,
                     SHIFT = 2'b10,
                     DONE  = 2'b11;

    //-------------------------------------------------
    // Internal Signals
    //-------------------------------------------------
    reg [15:0] clk_count;                   // Counter for generating sclk
    reg [3:0]  bit_count;                   // Counts how many bits have been shifted in
    reg [ADC_BITS-1:0] shift_reg;           // Shift register for incoming data
    reg [1:0] current_state, next_state;    // FSM state registers

    //-------------------------------------------------
    // SPI Clock Generation (Divide system clock)
    //-------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_count <= 16'd0;
            sclk      <= 1'b0;
        end 
        else begin
            clk_count <= clk_count + 1'b1;
            // Toggle sclk when clk_count hits the divider
            if (clk_count == (CLK_DIV - 1)) begin
                clk_count <= 16'd0;
                sclk      <= ~sclk;
            end
        end
    end

    //-------------------------------------------------
    // FSM: Current State Register
    //-------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    //-------------------------------------------------
    // FSM: Next State Logic
    //-------------------------------------------------
    always @(*) begin
        // Default next_state is current_state
        next_state = current_state;

        case (current_state)
            IDLE: begin
                // Transition to START if we want to begin a transaction.
                next_state = START;
            end

            START: begin
                // Once CS is asserted, we move to SHIFT on next cycle
                next_state = SHIFT;
            end

            SHIFT: begin
                // Continue shifting until we've received ADC_BITS
                if (bit_count == (ADC_BITS - 1))
                    next_state = DONE;
            end

            DONE: begin
                // One-cycle data_valid, then go back to IDLE
                next_state = IDLE;
            end

            default: begin
                next_state = IDLE;
            end
        endcase
    end

    //-------------------------------------------------
    // FSM: Output Logic & Counters
    //-------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cs_n       <= 1'b1;
            data_out   <= {ADC_BITS{1'b0}};
            data_valid <= 1'b0;
            bit_count  <= 4'd0;
            shift_reg  <= {ADC_BITS{1'b0}};
        end 
        else begin
            // Default assignments each clock
            data_valid <= 1'b0; // Usually only pulses in DONE

            case (current_state)
                IDLE: begin
                    cs_n      <= 1'b1;   // De-assert chip select
                    bit_count <= 4'd0;
                end

                START: begin
                    cs_n      <= 1'b0;   // Assert chip select
                    bit_count <= 4'd0;
                end

                SHIFT: begin
                    // On every falling edge of sclk, sample MISO
                    // This example checks the toggling moment of sclk. 
                    // Adjust to rising edge if your ADC requires it.
                    if ((clk_count == (CLK_DIV - 1)) && (sclk == 1'b1)) begin
                        shift_reg <= {shift_reg[ADC_BITS-2:0], miso};
                        bit_count <= bit_count + 1'b1;
                    end
                end

                DONE: begin
                    // Latch the 10-bit data into data_out
                    data_out   <= shift_reg;
                    data_valid <= 1'b1;  // Pulse data_valid
                    cs_n       <= 1'b1;  // Deassert chip select
                end

                default: ;
            endcase
        end
    end

endmodule