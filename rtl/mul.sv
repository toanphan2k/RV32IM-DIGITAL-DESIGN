`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: mul
// Description: Unified single 33x33 signed multiplier supporting RV32M
//              MUL, MULH, MULHSU, and MULHU without triplicating 64x64 trees.
//////////////////////////////////////////////////////////////////////////////////

import RV32_PKG::*;

module mul (
    input  logic [REG_SIZE - 1:0] a,
    input  logic [REG_SIZE - 1:0] b,
    input  logic [4:0]            alu_ctrl_e,
    output logic [REG_SIZE - 1:0] result
);

    logic               a_is_signed;
    logic               b_is_signed;
    logic signed [32:0] op_a;
    logic signed [32:0] op_b;
    logic signed [65:0] prod;

    assign a_is_signed = (alu_ctrl_e == ALU_MULH) || (alu_ctrl_e == ALU_MULSU);
    assign b_is_signed = (alu_ctrl_e == ALU_MULH);

    assign op_a = {a_is_signed & a[31], a};
    assign op_b = {b_is_signed & b[31], b};
    assign prod = op_a * op_b;

    always_comb begin
        case (alu_ctrl_e)
            ALU_MUL:   result = prod[31:0];
            ALU_MULH,
            ALU_MULSU,
            ALU_MULU:  result = prod[63:32];
            default:   result = '0;
        endcase
    end

endmodule
