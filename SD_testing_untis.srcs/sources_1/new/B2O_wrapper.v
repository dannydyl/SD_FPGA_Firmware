`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2025 02:03:51 PM
// Design Name: 
// Module Name: B2O_wrapper
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


module B2O_wrapper#(
        parameter CLK_DIV = 4,       // Clock divider for SPI SCLK (example)
        parameter ADC_BITS = 8,     // Number of bits to capture from ADC
        parameter DATA_WIDTH = 8,   // Width of data (ADC resolution)
        parameter DEPTH = 16        // Depth of FIFO (number of entries)
    )(
        input clk,
        input reset,
        input[DATA_WIDTH - 1 : 0] data_in,     // connect with ADC pin
        output [19 : 0] display_LED,
        output buzzer
    );
    reg wr_en, rd_en;
    wire [DATA_WIDTH-1:0] data_BRAM_out;
    wire audio_rest_AC_out, audio_enable_VACU_out;
    wire [4:0] strength_level_CLU_out;
    wire [4:0] display_level_VACU_out;
    
       FIFO_BRAM #(
        .DATA_WIDTH(DATA_WIDTH),  // Width of data (ADC resolution)
        .DEPTH(DEPTH)        // Depth of FIFO (number of entries)
    ) BRAM_inst (
        .clk   (clk),
        .rst   (reset),
        .wr_en (wr_en),
        .rd_en (rd_en),
        .din   (data_in),
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
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            //buzzer <= 0;
            wr_en <= 1'b0;
            rd_en <= 1'b0;
        end else begin
            wr_en <= 1'b1;
            rd_en <= 1'b1;
        end
    end 
endmodule
