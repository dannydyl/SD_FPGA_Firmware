`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2025 02:57:42 PM
// Design Name: 
// Module Name: Top_Level
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

module top_level (
    input  wire        mclk,
    input  wire        rst,
    input  wire [9:0]  adc_data_l_hori, adc_data_l_vert, adc_data_x_hori, adc_data_x_vert, // 4 channels
    input  wire [1:0]  sel_switch,        // controls 3-way switch
    output wire [9:0]  final_out,
    output wire        audio_alert
);
    wire [9:0] peak_val;
    wire [9:0] shifted_val;
    wire [9:0] hold_val;
    wire [9:0] L_hori, L_vert, X_hori, X_vert;
    
    ADC_control u_adc_control(
        .mclk(mclk),
        .reset(rst),
        .adc_data_l_hori(adc_data_l_hori),
        .adc_data_l_vert(adc_data_l_vert),
        .adc_data_x_hori(adc_data_x_hori),
        .adc_data_x_vert(adc_data_x_vert),
        .L_hori(L_hori),
        .L_vert(L_vert),
        .X_hori(X_hori),
        .X_vert(X_vert)
    );

    // 1) Peak detector for 4 inputs
    peak_detector u_peak_detector (
        .in0(L_hori),
        .in1(L_vert),
        .in2(X_hori),
        .in3(X_vert),
        .peak(peak_val)
    );

    // 2) Shifter
    shifter u_shifter (
        .in_data(peak_val),
        .shift_sel(sel_switch),
        .out_data(shifted_val)
    );

    // 3) Hold-and-decay (on the shifter output)
    hold_and_decay #(
        .CLK_FREQ(100_000_000),
        .HOLD_MS(500)
    ) u_hold_and_decay (
        .clk(mclk),
        .rst(rst),
        .in_data(shifted_val),
        .out_data(hold_val)
    );
    
    display_control u_display_control(
        .in_data(hold_val),
        .led_segments(final_out),
        .audio_alert(audio_alert)
    );
endmodule
