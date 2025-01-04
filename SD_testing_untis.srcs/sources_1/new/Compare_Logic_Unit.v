`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2024 08:58:34 PM
// Design Name: 
// Module Name: Compare_Logic_Unit
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
module CompareLogicUnit #(
    parameter DATA_WIDTH = 12,  // Bit width of 'signal_in'
    parameter integer level_step = (1 << DATA_WIDTH) / 20
)(
 input wire [11:0] signal_in,     // 12-bit input signal strength
 input wire reset_audio_alert,    // Reset audio_alert signal
 output reg [4:0] strength_level, // 5-bit output for 20 levels
 output reg audio_alert
);

 // Compare logic to set strength_level based on signal_in
 always @(*) begin
  if (signal_in < level_step) begin
      strength_level = 5'd0;
      audio_alert = 0;
  end else if (signal_in < 2 * level_step) begin
      strength_level = 5'd1;
      audio_alert = 0;
  end else if (signal_in < 3 * level_step) begin
      strength_level = 5'd2;
      audio_alert = 0;
  end else if (signal_in < 4 * level_step) begin
      strength_level = 5'd3;
      audio_alert = 0;
  end else if (signal_in < 5 * level_step) begin
      strength_level = 5'd4;
      audio_alert = 0;
  end else if (signal_in < 6 * level_step) begin
      strength_level = 5'd5;
      audio_alert = 0;
  end else if (signal_in < 7 * level_step) begin
      strength_level = 5'd6;
      audio_alert = 0;
  end else if (signal_in < 8 * level_step) begin
      strength_level = 5'd7;
      audio_alert = 0;
  end else if (signal_in < 9 * level_step) begin
      strength_level = 5'd8;
      audio_alert = 0;
  end else if (signal_in < 10 * level_step) begin
      strength_level = 5'd9;
      audio_alert = 0;
  end else if (signal_in < 11 * level_step) begin
      strength_level = 5'd10;
      audio_alert = 0;
  end else if (signal_in < 12 * level_step) begin
      strength_level = 5'd11;
      audio_alert = 0;
  end else if (signal_in < 13 * level_step) begin
      strength_level = 5'd12;
      audio_alert = 0;
  end else if (signal_in < 14 * level_step) begin
      strength_level = 5'd13;
      audio_alert = 0;
  end else if (signal_in < 15 * level_step) begin
      strength_level = 5'd14;
      audio_alert = 0;
  end else if (signal_in < 16 * level_step) begin
      strength_level = 5'd15;
      if (reset_audio_alert) begin
          audio_alert = 0;
      end else begin
          audio_alert = 1;
      end
  end else if (signal_in < 17 * level_step) begin
      strength_level = 5'd16;
      if (reset_audio_alert) begin
          audio_alert = 0;
      end else begin
          audio_alert = 1;
      end
  end else if (signal_in < 18 * level_step) begin
      strength_level = 5'd17;
      if (reset_audio_alert) begin
          audio_alert = 0;
      end else begin
          audio_alert = 1;
      end
  end else if (signal_in < 19 * level_step) begin
      strength_level = 5'd18;
      if (reset_audio_alert) begin
          audio_alert = 0;
      end else begin
          audio_alert = 1;
      end
  end else if (signal_in < 20 * level_step) begin
      strength_level = 5'd19;
      if (reset_audio_alert) begin
          audio_alert = 0;
      end else begin
          audio_alert = 1;
      end
  end else begin
      strength_level = 5'd20; // Maximum level if above the last threshold
      if (reset_audio_alert) begin
          audio_alert = 0;
      end else begin
          audio_alert = 1;
      end
  end
end

endmodule
