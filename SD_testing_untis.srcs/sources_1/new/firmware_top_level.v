`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2025 12:35:17 AM
// Design Name: 
// Module Name: firmware_top_level
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


module firmware_top_level#(
        parameter CLK_DIV = 4,       // Clock divider for SPI SCLK (example)
        parameter ADC_BITS = 10,     // Number of bits to capture from ADC
        parameter DATA_WIDTH = 12,   // Width of data (ADC resolution)
        parameter DEPTH = 16,        // Depth of FIFO (number of entries)
        parameter level_step = 205   // example step size for each level
    )(
        input clk,
        input sclk,     // slave clock
        input reset,
        input data_in,     // connect with ADC pin
        output reg display_LED,
        output reg buzzer
    );
    
wire [DATA_WIDTH-1 : 0] data_ADC_out, data_BRAM_out;
wire audio_reset, audio_alert_CLU_out, audio_enable_VACU_out, audio_rest_AC_out;
wire [4:0] strength_level_CLU_out, display_level_VACU_out;
    
    // assuming communication protocol is SPI
    ADC #(
        .CLK_DIV(CLK_DIV),       // Example value: generate a slower SPI clock
        .ADC_BITS(ADC_BITS)      // 10-bit ADC data
    ) adc_inst (
        .clk       (clk),
        .rst     (reset),
        .miso      (data_in),
        .sclk      (sclk),
        .cs_n      (cs_n),
        .data_out  (data_ADC_out),
        .data_valid(data_valid)
    );
    
    FIFO_BRAM #(
        .DATA_WIDTH(DATA_WIDTH),  // Width of data (ADC resolution)
        .DEPTH(DEPTH)        // Depth of FIFO (number of entries)
    ) BRAM_inst (
        .clk   (clk),
        .rst   (rst),
        .wr_en (wr_en),
        .rd_en (rd_en),
        .din   (data_ADC_out),
        .dout  (data_BRAM_out),
        .full  (full),
        .empty (empty)
    );
    
    CompareLogicUnit #(
        .DATA_WIDTH(DATA_WIDTH)
    ) CLU_inst (
        .signal_in(data_BRAM_out),
        .reset_audio_alert(audio_rest_AC_out),
        .strength_level(strength_level_CLU_out),
        .audio_alert(audio_alert_CLU_out)
    );
    
    VisualAudioControlUnit VACU_inst (
        .clk(clk),
        .rst(reset),
        .strength_level(strength_level_CLU_out),
        .audio_alert(audio_alert_CLU_out),
        .display_level(display_level_VACU_out),
        .audio_enable(audio_enable_VACU_out)
    );
    
    AudioController AC_inst(
        .clk(clk),
        .rst(reset),
        .audio_alert(audio_enable_VACU_out),
        .audio_reset(audio_rest_AC_out),
        .speaker_output(buzzer)
    );
    
    DisplayController DC_inst(
        .display_level(display_level_VACU_out),
        .display_LED(display_LED)
    );
    
    
endmodule
