`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2025 12:47:36 PM
// Design Name: 
// Module Name: VACU_tb
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


module VACU_tb;
    reg         clk;
    reg         rst;
    reg  [4:0]  strength_level;
    reg         audio_alert;
    
    wire [4:0]  display_level;
    wire        audio_enable;
    
    VisualAudioControlUnit dut (
    .clk           (clk),
    .rst           (rst),
    .strength_level(strength_level),
    .audio_alert   (audio_alert),
    .display_level (display_level),
    .audio_enable  (audio_enable)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz
    end
    
    initial begin
    // Initial values
    rst            = 1;
    strength_level = 5'd0;
    audio_alert    = 1'b0;
    
    // Hold reset for a while
    #50;
    rst = 0;
    
    // Wait a short time, then increase strength_level
    #100;
    strength_level = 5'd8;
    $display("[%0t] strength_level set to %d", $time, strength_level);

    // Further increase strength_level
    #100;
    strength_level = 5'd15;
    $display("[%0t] strength_level set to %d", $time, strength_level);

    // Decrease strength_level to trigger the 500ms decay (scaled in simulation)
    #100;
    strength_level = 5'd5;
    $display("[%0t] strength_level set to %d (should wait for decay)", $time, strength_level);
    
    // Toggle audio_alert ON
    #200;
    audio_alert = 1'b1;
    $display("[%0t] audio_alert set to %b", $time, audio_alert);
    
    // Toggle audio_alert OFF
    #200;
    audio_alert = 1'b0;
    $display("[%0t] audio_alert set to %b", $time, audio_alert);

    // Wait enough time to allow at least one decrement event
    // (In real simulation with DISPLAY_DELAY=200,000,000, this would be much longer)
    $display("[%0t ns] Waiting 500 ms = 500,000,000 ns for 1 decrement", $time);
    #500_000_100;

    $display("[%0t] Test completed. Simulation ends.", $time);
    $finish;
end

//initial begin
//    $monitor("[%0t] clk=%b rst=%b strength_level=%d display_level=%d audio_alert=%b audio_enable=%b",
//             $time, clk, rst, strength_level, display_level, audio_alert, audio_enable);
//end
    
endmodule
