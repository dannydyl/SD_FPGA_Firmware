`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2024 09:03:16 PM
// Design Name: 
// Module Name: Compare_Logic_Unit_tb
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
`timescale 1ns / 1ps

module CompareLogicUnit_tb;

    // Testbench signals
    reg [11:0] signal_in;          // Test input for signal strength
    reg reset_audio_alert;         // Test input for resetting audio alert
    wire [4:0] strength_level;     // Test output for strength level
    wire audio_alert;              // Test output for audio alert

    // Instantiate the CompareLogicUnit module
    CompareLogicUnit #(
        .level_step(205)           // Example level step
    ) uut (
        .signal_in(signal_in),
        .reset_audio_alert(reset_audio_alert),
        .strength_level(strength_level),
        .audio_alert(audio_alert)
    );

    // Test sequence
    initial begin
        // Monitor changes for debugging
        $monitor($time, " signal_in = %d, reset_audio_alert = %b, strength_level = %d, audio_alert = %b",
                 signal_in, reset_audio_alert, strength_level, audio_alert);

        // Initialize inputs
        signal_in = 0;
        reset_audio_alert = 0;

        // Test for various input ranges
        #10 signal_in = 100;       // Below first level
        #10 signal_in = 300;       // Second level
        #10 signal_in = 600;       // Third level
        #10 signal_in = 1200;      // Sixth level
        #10 signal_in = 3000;      // Fifteenth level

        // Test audio alert triggering
        #10 signal_in = 3300;      // Sixteenth level
        #10 reset_audio_alert = 1; // Reset alert
        #10 reset_audio_alert = 0; // Unset reset alert

        #10 signal_in = 4000;      // Eighteenth level
        #10 signal_in = 4100;      // Above maximum threshold

        // End simulation
        #10 $finish;
    end

endmodule
