`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2025 10:20:36 PM
// Design Name: 
// Module Name: Visual_Audio_Control_unit
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


module Visual_Audio_Control_unit(
   input wire clk,                  // Clock signal
   input wire rst,                  // Reset signal
   input wire [4:0] strength_level, // 5-bit signal from CLU
   input wire audio_alert,          // Audio alert signal from CLU
   output reg [4:0] display_level,  // Output to Display Controller
   output reg audio_enable          // Output to Audio Controller
);

// Parameter for 500ms display decay delay
localparam DISPLAY_DELAY = 200000000;   // 500ms delay at 400MHz clock


// Internal register for display delay counter
reg [27:0] display_counter;      // Counter for display decay delay


// Display Control Logic: Update immediately when going up, delay 500ms when going down
always @(posedge clk or posedge rst) begin
   if (rst) begin
       display_level <= 5'd0;
       display_counter <= 0;
   end else if (strength_level > display_level) begin
       // Update display level immediately if strength increases
       display_level <= strength_level;
       display_counter <= DISPLAY_DELAY; // Reset delay counter
   end else if (strength_level < display_level) begin
       // Start decay delay when strength decreases
       if (display_counter == 0) begin
           display_level <= display_level - 1; // Decrement display level
           display_counter <= DISPLAY_DELAY;   // Reset delay counter for next decay step
       end else begin
           display_counter <= display_counter - 1; // Count down delay
       end
   end
end


// Audio Control Logic: Enable audio based on audio_alert signal
always @(posedge clk or posedge rst) begin
   if (rst) begin
       audio_enable <= 0;
   end else begin
       audio_enable <= audio_alert; // Directly pass audio alert signal
   end
end

endmodule
