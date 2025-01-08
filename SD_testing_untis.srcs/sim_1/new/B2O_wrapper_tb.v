`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2025 04:12:00 PM
// Design Name: 
// Module Name: B2O_wrapper_tb
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
module B2O_wrapper_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg [DATA_WIDTH-1:0] data_in;
    wire [19 : 0] display_LED;
    wire buzzer;
    
    parameter CLK_DIV = 4;       // Clock divider for SPI SCLK (example)
    parameter ADC_BITS = 8;     // Number of bits to capture from ADC
    parameter DATA_WIDTH = 8;   // Width of data (ADC resolution)
    parameter DEPTH = 16;        // Depth of FIFO (number of entries)
    
    // Instantiate the DUT (Device Under Test)
    B2O_wrapper #(
        .CLK_DIV(CLK_DIV),       // example clock divider
        .ADC_BITS(ADC_BITS),     // example bit size
        .DATA_WIDTH(DATA_WIDTH),   // must match your module
        .DEPTH(DEPTH)        // must match your module
    ) DUT (
        .clk         (clk),
        .reset       (reset),
        .data_in     (data_in),
        .display_LED (display_LED),
        .buzzer      (buzzer)
    );
    
    // Clock generation
    // 400 MHz => 2.5 ns period => half-cycle = 1.25 ns
    initial begin
        clk = 1'b0;
        forever #1.25 clk = ~clk;
    end
    integer i;
    // Test stimulus
    initial begin
        // Initialize signals
        reset    = 1'b1;
        data_in  = 0;
        
        // Wait a few clock cycles before releasing reset
        #50;
        reset    = 1'b0;
        
        // After coming out of reset, drive some data patterns
        // The pattern here is very simple; you can create more complex or random data.
        
        // For demonstration, let’s toggle data_in a few times
        for (i = 0; i < 1000; i = i + 50) begin
            #10 data_in = i;
        end
        
        // You might wait a bit and then apply another reset
        #100;
//        reset = 1'b1;
//        #50;
//        reset = 1'b0;
        
        // Continue with more data patterns if needed
        for (i = 16; i < 1000; i = i + 50) begin
            #10 data_in = i;
        end
        
        // Finish the simulation
        #200;
        $stop;  // or $finish;
    end
    
    // Optionally, you can monitor signals or use $display
    // to get a runtime printout of key signals
    initial begin
        $monitor("Time = %0t | reset = %b | data_in = %b | display_LED = %b | buzzer = %b",
                 $time, reset, data_in, display_LED, buzzer);
    end

endmodule

