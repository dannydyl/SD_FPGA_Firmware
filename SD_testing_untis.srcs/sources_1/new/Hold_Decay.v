module hold_and_decay #(
    parameter CLK_FREQ = 100_000_000,       // e.g., 100 MHz
    parameter HOLD_MS  = 500               // 500 ms
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [9:0]  in_data,
    output reg  [9:0]  out_data
);
    localparam integer HOLD_COUNT = (CLK_FREQ * HOLD_MS) / 1000; 
    reg [31:0] hold_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_data     <= 10'd0;
            hold_counter <= 0;
        end else if (in_data > out_data) begin
            // Update immediately if input goes up
            out_data     <= in_data;
            hold_counter <= HOLD_COUNT;
        end else if (in_data < out_data) begin
            // Begin/continue holding if input goes down
            if (hold_counter == 0) begin
                out_data     <= in_data;
                hold_counter <= HOLD_COUNT;
            end else begin
                hold_counter <= hold_counter - 1;
            end
        end
    end
endmodule
