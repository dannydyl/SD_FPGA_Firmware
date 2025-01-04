`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2025 10:20:36 PM
// Design Name: 
// Module Name: Audio_Controller
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


module Audio_Controller(
   input wire clk,               
   input wire rst,              // Reset signal
   input wire audio_alert,     // Enable signal for audio alert
   output reg audio_reset,
   output reg speaker_output    // Output signal to speaker
);

localparam AUDIO_ON_TIME = 1200000000;  // 3 seconds at 400MHz clock
localparam AUDIO_OFF_TIME = 400000000;  // 1 second at 400MHz clock


reg [15:0] audio_counter;      // Timer for audio alert duration
reg audio_state;
   // Audio Control Logic: 3s ON / 1s OFF cycle for audio alert
   always @(posedge clk or posedge rst) begin
       if (rst) begin
           audio_reset <= 0;
           audio_counter <= 0;
           audio_state <= 0;
       end else if (audio_alert) begin
           // Control audio based on ON/OFF timing
           if (audio_state == 0) begin
               audio_reset <= 1;              // 3s ON state
               if (audio_counter < AUDIO_ON_TIME) begin
                   audio_counter <= audio_counter + 1;
               end else begin
                   audio_counter <= 0;         // Reset counter
                   audio_state <= 1;           // Switch to OFF state
               end
           end else begin
               audio_reset <= 0;              // 1s OFF state
               if (audio_counter < AUDIO_OFF_TIME) begin
                   audio_counter <= audio_counter + 1;
               end else begin
                   audio_counter <= 0;         // Reset counter
                   audio_state <= 0;           // Switch back to ON state
               end
           end
       end else begin
           // Reset audio if no alert
           audio_reset <= 0;
           audio_counter <= 0;
           audio_state <= 0;
       end
   end

endmodule
