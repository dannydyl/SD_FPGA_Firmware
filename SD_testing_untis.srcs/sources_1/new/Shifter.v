module shifter (
    input  wire [9:0] in_data,
    input  wire [1:0] shift_sel, // 01=>no shift, 10=>>>1, 11=>>>2
    output reg  [9:0] out_data
);
    always @(*) begin
        case (shift_sel)
            2'b01: out_data = in_data;       // "1": no shift
            2'b10: out_data = in_data >> 1;  // "2": shift right by 1
            2'b11: out_data = in_data >> 2;  // "3": shift right by 2
            default: out_data = in_data;     // 00 or anything else
        endcase
    end
endmodule
