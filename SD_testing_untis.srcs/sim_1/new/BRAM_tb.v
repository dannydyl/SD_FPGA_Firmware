`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2024 09:12:37 PM
// Design Name: 
// Module Name: BRAM_tb
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

module FIFO_BRAM_tb;

    // Parameters
    parameter DATA_WIDTH = 12;
    parameter DEPTH = 16;

    // Testbench signals
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    wire full;
    wire empty;

    // Instantiate the FIFO_BRAM module
    FIFO_BRAM #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    // Test sequence
    initial begin
        // Monitor signals for debugging
        $monitor($time, " clk=%b rst=%b wr_en=%b rd_en=%b din=%d dout=%d full=%b empty=%b",
                 clk, rst, wr_en, rd_en, din, dout, full, empty);

        // Initialize signals
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        din = 0;

        // Reset the FIFO
        #10 rst = 0;

        // Write data into FIFO
        #10 wr_en = 1; din = 12'd100;
        #10 din = 12'd200;
        #10 din = 12'd300;
        #10 wr_en = 0;

        // Read data from FIFO
        #10 rd_en = 1;
        #10 rd_en = 0;

        // Fill the FIFO to test 'full' flag
        #10 wr_en = 1;
        repeat (DEPTH) begin
            #10 din = $random % 4096; // Random data within 12-bit range
        end
        wr_en = 0;

        // Attempt to write when FIFO is full
        #10 wr_en = 1; din = 12'd999;

        // Test reading until FIFO is empty
        #10 wr_en = 0; rd_en = 1;
        repeat (DEPTH + 2) begin
            #10;
        end
        rd_en = 0;

        // Finish simulation
        #20 $finish;
    end

endmodule
