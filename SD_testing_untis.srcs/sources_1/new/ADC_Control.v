module ADC_control (
    input  wire        mclk,    // master clock
    input  wire        reset,
    // Add any ADC interface signals here (e.g., SPI lines or parallel bus),
    input wire [9:0] adc_data_l_hori,
    input wire [9:0] adc_data_l_vert,
    input wire [9:0] adc_data_x_hori,
    input wire [9:0] adc_data_x_vert,
    output reg  [9:0]  L_hori,
    output reg  [9:0]  L_vert,
    output reg  [9:0]  X_hori,
    output reg  [9:0]  X_vert
);
    always @(posedge mclk or posedge reset) begin
        if (reset) begin
            L_hori <= 10'd0;
            L_vert <= 10'd0;
            X_hori <= 10'd0;
            X_vert <= 10'd0;
        end else begin
            // Read data from the ADC interface and update outputs
             L_hori <= adc_data_l_hori;
             L_vert <= adc_data_l_vert;
             X_hori <= adc_data_x_hori;
             X_vert <= adc_data_x_vert;
        end
    end
endmodule
