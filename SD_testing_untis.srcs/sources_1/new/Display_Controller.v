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

   // Make sure display_level does not exceed 20
wire [4:0] level_saturated = (display_level > 20) ? 5'd20 : display_level;
    
    always @(*) begin
        // (1 << level_saturated) gives you 1 at bit 'level_saturated'
        // Subtracting 1 sets bits 0..(level_saturated-1) to 1
        // Example: if level_saturated = 5, (1 << 5) = 0b100000, minus 1 = 0b011111
        display_LED = (1 << level_saturated) - 1;
    end


endmodule
