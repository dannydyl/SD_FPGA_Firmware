module display_control (
    input  wire [9:0] in_data,       // 10-bit input: 0 to 1023
    output reg  [9:0] led_segments,  // 10 LED segments
    output reg        audio_alert    // Audio alert when highest segments are active
);
    // Define thresholds for each segment based on a 10-bit range divided into 10 segments.
    // Each segment covers approximately 102 values.
    parameter SEG0_THRESH = 10'd102;
    parameter SEG1_THRESH = 10'd204;
    parameter SEG2_THRESH = 10'd306;
    parameter SEG3_THRESH = 10'd408;
    parameter SEG4_THRESH = 10'd510;
    parameter SEG5_THRESH = 10'd612;
    parameter SEG6_THRESH = 10'd714;
    parameter SEG7_THRESH = 10'd816;
    parameter SEG8_THRESH = 10'd918;
    parameter SEG9_THRESH = 10'd1020;

    always @(*) begin
        led_segments[0] = (in_data >= SEG0_THRESH) ? 1'b1 : 1'b0;
        led_segments[1] = (in_data >= SEG1_THRESH) ? 1'b1 : 1'b0;
        led_segments[2] = (in_data >= SEG2_THRESH) ? 1'b1 : 1'b0;
        led_segments[3] = (in_data >= SEG3_THRESH) ? 1'b1 : 1'b0;
        led_segments[4] = (in_data >= SEG4_THRESH) ? 1'b1 : 1'b0;
        led_segments[5] = (in_data >= SEG5_THRESH) ? 1'b1 : 1'b0;
        led_segments[6] = (in_data >= SEG6_THRESH) ? 1'b1 : 1'b0;
        led_segments[7] = (in_data >= SEG7_THRESH) ? 1'b1 : 1'b0;
        led_segments[8] = (in_data >= SEG8_THRESH) ? 1'b1 : 1'b0;
        led_segments[9] = (in_data >= SEG9_THRESH) ? 1'b1 : 1'b0;
        
        // Audio alert is triggered if either of the two highest segments are lit.
        audio_alert = led_segments[8] | led_segments[9];
    end
endmodule
