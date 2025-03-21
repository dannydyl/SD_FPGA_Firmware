`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2025 03:10:08 PM
// Design Name: 
// Module Name: tb_top_level
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
module tb_top_level;

    // Inputs as registers, outputs as wires
    reg         mclk;
    reg         rst;
    reg  [9:0]  adc_data_l_hori;
    reg  [9:0]  adc_data_l_vert;
    reg  [9:0]  adc_data_x_hori;
    reg  [9:0]  adc_data_x_vert;
    reg  [1:0]  sel_switch;
    wire [9:0]  final_out;
    wire        audio_alert;

    // Instantiate the top_level module (Device Under Test)
    top_level dut (
        .mclk(mclk),
        .rst(rst),
        .adc_data_l_hori(adc_data_l_hori),
        .adc_data_l_vert(adc_data_l_vert),
        .adc_data_x_hori(adc_data_x_hori),
        .adc_data_x_vert(adc_data_x_vert),
        .sel_switch(sel_switch),
        .final_out(final_out),
        .audio_alert(audio_alert)
    );

    // Clock generation: 100 MHz clock => period = 10 ns (toggle every 5 ns)
    initial begin
        mclk = 0;
        forever #5 mclk = ~mclk;
    end

    // Test stimulus
    initial begin
        // Initialize all inputs and hold reset high initially
        rst                 = 1;
        adc_data_l_hori     = 10'd0;
        adc_data_l_vert     = 10'd0;
        adc_data_x_hori     = 10'd0;
        adc_data_x_vert     = 10'd0;
        sel_switch          = 2'b01; // Default selection: no shift

        // Hold reset for 20 ns, then release
        #20;
        rst = 0;

        // ------------------------------------------------------------
        // Case 1: Basic rising ADC values
        // Expected: Peak detector selects highest value (250)
        #50;
        adc_data_l_hori = 10'd100;
        adc_data_l_vert = 10'd150;
        adc_data_x_hori = 10'd200;
        adc_data_x_vert = 10'd250;  // peak = 250

        // ------------------------------------------------------------
        // Case 2: Increase ADC inputs so the peak becomes higher (450)
        #100;
        adc_data_l_hori = 10'd300;
        adc_data_l_vert = 10'd400;
        adc_data_x_hori = 10'd350;
        adc_data_x_vert = 10'd450;  // peak = 450

        // ------------------------------------------------------------
        // Case 3: Even higher values (650)
        #100;
        adc_data_l_hori = 10'd500;
        adc_data_l_vert = 10'd600;
        adc_data_x_hori = 10'd550;
        adc_data_x_vert = 10'd650;  // peak = 650

        // ------------------------------------------------------------
        // Case 4: Test shifter functionality by changing sel_switch
        // 2'b01 = no shift, 2'b10 = shift right by 1, 2'b11 = shift right by 2
        #100;
        sel_switch = 2'b10; // Expect 650 >> 1 = 325
        #100;
        sel_switch = 2'b11; // Expect 650 >> 2 = 162
        #50;
        sel_switch = 2'b01; // Revert to no shift

        // ------------------------------------------------------------
        // Case 5: Test hold-and-decay when the peak drops.
        // Set ADC inputs lower (50) so the peak detector output drops to 50.
        // Hold-and-decay should hold the previous high value for 500 ms before updating.
        #100;
        adc_data_l_hori = 10'd50;
        adc_data_l_vert = 10'd50;
        adc_data_x_hori = 10'd50;
        adc_data_x_vert = 10'd50;  // New peak would be 50, but hold should maintain previous value for 500ms.

        // Wait 500ms (500,000,000 ns) for the hold-and-decay to update.
        #500000000;

        // ------------------------------------------------------------
        // Case 6: Test individual channel variations.
        // Vary channels so that one channel is significantly higher.
        adc_data_l_hori = 10'd800;
        adc_data_l_vert = 10'd200;
        adc_data_x_hori = 10'd300;
        adc_data_x_vert = 10'd400;  // Expected peak = 800

        #100;
        adc_data_l_hori = 10'd250;
        adc_data_l_vert = 10'd900;  // Now expected peak = 900 (from adc_data_l_vert)
        adc_data_x_hori = 10'd100;
        adc_data_x_vert = 10'd100;

        // ------------------------------------------------------------
        // Case 7: Test audio alert assertion.
        // For audio alert, the display_control should assert it when high segments are active.
        // To do this, set all ADC inputs to maximum (1023) with no shift.
        #100;
        sel_switch = 2'b01; // Ensure no shift so peak remains high.
        adc_data_l_hori = 10'd1023;
        adc_data_l_vert = 10'd1023;
        adc_data_x_hori = 10'd1023;
        adc_data_x_vert = 10'd1023;  // Expected peak = 1023, which should light high segments and assert audio_alert.

        // ------------------------------------------------------------
        // Let the simulation run for an additional period to observe the final state.
        #100000000; // 100ms extra delay
        $stop;
    end

endmodule
