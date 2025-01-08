`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2025 10:21:07 PM
// Design Name: 
// Module Name: Display_Controller
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


module DisplayController(
    input wire [4:0] display_level,
    output reg [19:0] display_LED
    );

    // Clamp display_level to a maximum of 20
    wire [4:0] level_saturated = (display_level > 5'd20) ? 5'd20 : display_level;

    always @(*) begin
        if (level_saturated == 0)
            display_LED = 20'b0; // If level is 0, no LEDs are lit
        else
            // Generate LED pattern within 20 bits
            display_LED = (20'b1 << level_saturated) - 1;
    end

endmodule
