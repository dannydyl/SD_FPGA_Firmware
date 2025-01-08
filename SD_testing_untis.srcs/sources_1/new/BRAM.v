`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2024 09:12:01 PM
// Design Name: 
// Module Name: BRAM
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
module FIFO_BRAM #(
   parameter DATA_WIDTH = 12,  // Width of data (ADC resolution)
   parameter DEPTH = 16        // Depth of FIFO (number of entries)
)(
   input wire clk,             // Clock signal
   input wire rst,             // Reset signal
   input wire wr_en,           // Write enable
   input wire rd_en,           // Read enable
   input wire [DATA_WIDTH-1:0] din,  // Data input
   output reg [DATA_WIDTH-1:0] dout, // Data output
   output wire full,           // FIFO full indicator
   output wire empty           // FIFO empty indicator
);


   // Internal parameters
   localparam ADDR_WIDTH = $clog2(DEPTH); // Address width for FIFO depth


   // Internal memory and pointers
   reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1] ; // FIFO memory
   reg [ADDR_WIDTH-1:0] wr_ptr = 0;           // Write pointer
   reg [ADDR_WIDTH-1:0] rd_ptr = 0;           // Read pointer
   reg [ADDR_WIDTH:0] fifo_count = 0;         // Count of entries in FIFO


   // Write operation
   always @(posedge clk) begin
       if (rst) begin
           wr_ptr <= 0;
       end else if (wr_en) begin
           fifo_mem[wr_ptr] <= din;
           wr_ptr <= (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1; // Circular addressing
       end
   end


   // Read operation
   always @(posedge clk) begin
       if (rst) begin
           rd_ptr <= 0;
           dout <= 0;
       end else if (rd_en && (!empty || wr_en)) begin
           dout <= fifo_mem[rd_ptr];
           rd_ptr <= (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1; // Circular addressing
       end
   end

    integer i;
   // FIFO count update
   always @(posedge clk) begin
       if (rst) begin
           fifo_count <= 0;
           for(i=0;i<DEPTH;i=i+1) begin
                fifo_mem[i] <= 0;
           end
       end else begin
           case ({wr_en, rd_en})
               2'b10: fifo_count <= (fifo_count < DEPTH) ? fifo_count + 1 : fifo_count; // Write only
               2'b01: fifo_count <= (fifo_count > 0) ? fifo_count - 1 : fifo_count;    // Read only
               default: fifo_count <= fifo_count;                                     // No change
           endcase
       end
   end


   // Full and empty flags
   assign full = (fifo_count == DEPTH);
   assign empty = (fifo_count == 0);


endmodule
