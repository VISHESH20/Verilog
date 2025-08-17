// alu.v
// Performs arithmetic and logical operations.
module alu (
    input  [7:0] a,
    input  [7:0] b,
    input  [2:0] alu_op,
    output reg [7:0] result,
    output reg zero_flag
);

    // Operation codes for the ALU
    parameter OP_ADD = 3'b000;
    parameter OP_SUB = 3'b001;
    parameter OP_AND = 3'b010;
    parameter OP_PASS_B = 3'b011; // Used for LOAD/STORE address calculation

    always @(*) begin
        case (alu_op)
            OP_ADD:    result = a + b;
            OP_SUB:    result = a - b;
            OP_AND:    result = a & b;
            OP_PASS_B: result = b; // Pass through operand B
            default:   result = 8'h00;
        endcase

        if (result == 8'h00) begin
            zero_flag = 1'b1;
        end else begin
            zero_flag = 1'b0;
        end
    end
endmodule
