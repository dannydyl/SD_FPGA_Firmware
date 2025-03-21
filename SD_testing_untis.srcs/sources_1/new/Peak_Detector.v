module peak_detector (
    input  wire [9:0] in0,
    input  wire [9:0] in1,
    input  wire [9:0] in2,
    input  wire [9:0] in3,
    output reg  [9:0] peak
);
    always @(*) begin
        peak = in0;
        if (in1 > peak) peak = in1;
        if (in2 > peak) peak = in2;
        if (in3 > peak) peak = in3;
    end
endmodule