`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_alu
// Description: Self-checking testbench for alu.sv (RV32I ops + MUL/MULH/MULHSU/MULHU)
// Dependencies: def_pkg.sv, alu.sv, cla.sv, gp1.sv, gp4.sv, gp8.sv, mul.sv
//////////////////////////////////////////////////////////////////////////////////

import RV32_PKG::*;

module tb_alu;

    logic [REG_SIZE-1:0] srca_alu, srcb_alu;
    logic [4:0]          alu_ctrl_e;
    logic [REG_SIZE-1:0] d_result_e;
    logic                zero_flag, less_flag, less_u_flag;

    int tests = 0;
    int passed = 0;
    int failed = 0;

    alu dut (
        .srca_alu,
        .srcb_alu,
        .alu_ctrl_e,
        .d_result_e,
        .zero_flag,
        .less_flag,
        .less_u_flag
    );

    localparam logic [4:0] ALU_OPS [0:14] = '{
        ALU_AND, ALU_OR, ALU_ADD, ALU_SUB, ALU_LSHIFT_LEFT, ALU_LSHIFT_RIGHT,
        ALU_ASHIFT_RIGHT, ALU_XOR, ALU_MUL, ALU_MULH, ALU_MULSU, ALU_MULU,
        ALU_SLT, ALU_SLTU, ALU_NOP
    };

    function automatic string op_name(input logic [4:0] op);
        case (op)
            ALU_AND:          return "AND";
            ALU_OR:           return "OR";
            ALU_ADD:          return "ADD";
            ALU_SUB:          return "SUB";
            ALU_LSHIFT_LEFT:  return "SLL";
            ALU_LSHIFT_RIGHT: return "SRL";
            ALU_ASHIFT_RIGHT: return "SRA";
            ALU_XOR:          return "XOR";
            ALU_MUL:          return "MUL";
            ALU_MULH:         return "MULH";
            ALU_MULSU:        return "MULHSU";
            ALU_MULU:         return "MULHU";
            ALU_SLT:          return "SLT";
            ALU_SLTU:         return "SLTU";
            default:          return $sformatf("OP_%05b", op);
        endcase
    endfunction

    function automatic logic [31:0] ref_alu(
        input logic [31:0] a,
        input logic [31:0] b,
        input logic [4:0]  op
    );
        logic signed [63:0] p_ss;
        logic signed [63:0] p_su;
        logic        [63:0] p_uu;
        p_ss = $signed({{32{a[31]}}, a}) * $signed({{32{b[31]}}, b});
        p_su = $signed({{32{a[31]}}, a}) * $signed({32'b0, b});
        p_uu = {32'b0, a} * {32'b0, b};
        case (op)
            ALU_AND:          return a & b;
            ALU_OR:           return a | b;
            ALU_ADD:          return a + b;
            ALU_SUB:          return a - b;
            ALU_XOR:          return a ^ b;
            ALU_LSHIFT_LEFT:  return a << b[4:0];
            ALU_LSHIFT_RIGHT: return a >> b[4:0];
            ALU_ASHIFT_RIGHT: return $signed(a) >>> b[4:0];
            ALU_SLT:          return {31'b0, $signed(a) < $signed(b)};
            ALU_SLTU:         return {31'b0, a < b};
            ALU_MUL:          return p_ss[31:0];
            ALU_MULH:         return p_ss[63:32];
            ALU_MULSU:        return p_su[63:32];
            ALU_MULU:         return p_uu[63:32];
            default:          return '0;
        endcase
    endfunction

    task automatic check(
        input logic [31:0] a,
        input logic [31:0] b,
        input logic [4:0]  op,
        input string       label = ""
    );
        logic [31:0] exp_res;
        logic        exp_zero, exp_lt, exp_ltu;
        begin
            srca_alu   = a;
            srcb_alu   = b;
            alu_ctrl_e = op;
            #1;

            exp_res  = ref_alu(a, b, op);
            exp_zero = (a == b);
            exp_lt   = ($signed(a) < $signed(b));
            exp_ltu  = (a < b);

            tests++;
            if ((d_result_e !== exp_res) || (zero_flag !== exp_zero) ||
                (less_flag !== exp_lt) || (less_u_flag !== exp_ltu)) begin
                failed++;
                $error("[FAIL] %s %s a=%08h b=%08h | got res=%08h z=%b lt=%b ltu=%b | exp res=%08h z=%b lt=%b ltu=%b",
                       op_name(op), label, a, b, d_result_e, zero_flag, less_flag, less_u_flag,
                       exp_res, exp_zero, exp_lt, exp_ltu);
            end else begin
                passed++;
                if (label != "")
                    $display("[PASS] %s %s a=%08h b=%08h res=%08h", op_name(op), label, a, b, d_result_e);
            end
        end
    endtask

    initial begin
        $display("==================================================");
        $display(" tb_alu: alu.sv self-checking testbench");
        $display("==================================================");

        $display("--- Begin Directed RV32I tests (24 cases) ---");
        check(32'd10,         32'd5,         ALU_ADD,          "basic");
        check(32'hFFFF_FFFF,  32'd1,         ALU_ADD,          "wrap");
        check(32'h7FFF_FFFF,  32'd1,         ALU_ADD,          "signed overflow");
        check(32'h0F0F_0F0F,  32'hF0F0_F0F1, ALU_ADD,          "full carry chain");
        check(32'd10,         32'd5,         ALU_SUB,          "basic");
        check(32'd5,          32'd5,         ALU_SUB,          "equal -> zero");
        check(32'd0,          32'd1,         ALU_SUB,          "borrow");
        check(32'hAA55_AA55,  32'h55AA_55AA, ALU_AND,          "zero result");
        check(32'h0F0F_0000,  32'h0000_F0F0, ALU_OR,           "");
        check(32'hA5A5_A5A5,  32'h5A5A_5A5A, ALU_XOR,          "all ones");
        check(32'd3,          32'd2,         ALU_LSHIFT_LEFT,  "");
        check(32'h0000_0001,  32'd31,        ALU_LSHIFT_LEFT,  "shamt 31");
        check(32'h0000_0001,  32'h0000_0021, ALU_LSHIFT_LEFT,  "shamt uses [4:0]");
        check(32'h8000_0001,  32'd1,         ALU_LSHIFT_RIGHT, "");
        check(32'h8000_0000,  32'd31,        ALU_LSHIFT_RIGHT, "shamt 31");
        check(32'h8000_0001,  32'd1,         ALU_ASHIFT_RIGHT, "negative");
        check(32'h8000_0000,  32'd31,        ALU_ASHIFT_RIGHT, "shamt 31");
        check(32'h4000_0000,  32'd4,         ALU_ASHIFT_RIGHT, "positive");
        check(32'hFFFF_FFFF,  32'd1,         ALU_SLT,          "-1 < 1");
        check(32'h8000_0000,  32'd1,         ALU_SLT,          "INT_MIN < 1 (overflow)");
        check(32'h7FFF_FFFF,  32'h8000_0000, ALU_SLT,          "INT_MAX vs INT_MIN");
        check(32'd1,          32'd2,         ALU_SLTU,         "");
        check(32'hFFFF_FFFF,  32'd1,         ALU_SLTU,         "high unsigned");
        check(32'd7,          32'd7,         ALU_SLTU,         "equal");
        $display("--- End Directed RV32I tests ---");

        $display("--- Begin Directed RV32M multiply tests (11 cases) ---");
        check(32'd20,         32'd6,         ALU_MUL,          "20*6");
        check(32'hFFFF_FFFF,  32'hFFFF_FFFF, ALU_MUL,          "-1*-1");
        check(32'h8000_0000,  32'hFFFF_FFFF, ALU_MUL,          "INT_MIN*-1");
        check(32'hFFFF_FFFF,  32'hFFFF_FFFF, ALU_MULH,         "-1*-1");
        check(32'h8000_0000,  32'h8000_0000, ALU_MULH,         "INT_MIN*INT_MIN");
        check(32'h7FFF_FFFF,  32'h7FFF_FFFF, ALU_MULH,         "INT_MAX^2");
        check(32'hFFFF_FFFF,  32'hFFFF_FFFF, ALU_MULSU,        "-1*0xFFFFFFFF");
        check(32'h8000_0000,  32'hFFFF_FFFF, ALU_MULSU,        "INT_MIN*0xFFFFFFFF");
        check(32'h0000_0002,  32'hFFFF_FFFF, ALU_MULSU,        "2*0xFFFFFFFF");
        check(32'hFFFF_FFFF,  32'hFFFF_FFFF, ALU_MULU,         "max*max");
        check(32'h8000_0000,  32'h0000_0002, ALU_MULU,         "");
        $display("--- End Directed RV32M multiply tests ---");

        $display("--- Begin Unused / NOP control tests (2 cases) ---");
        check(32'h1234_5678,  32'h9ABC_DEF0, ALU_NOP,          "default -> 0");
        check(32'h1234_5678,  32'h9ABC_DEF0, ALU_DIV,          "DIV not in ALU -> 0");
        $display("--- End Unused / NOP control tests ---");

        // ---------------- Random over all ops ----------------
        $display("--- Begin Random tests ---");
        $display("Testing Random Value for 2000 times");
        repeat (2000) begin
            check($urandom, $urandom, ALU_OPS[$urandom_range(0, 14)]);
        end
        foreach (ALU_OPS[i]) begin
            $display("Testing random value of %s for 50 times", op_name(ALU_OPS[i]));
            repeat (50) check($urandom, $urandom_range(0, 40), ALU_OPS[i]);
        end
        $display("--- End Random tests ---");

        $display("===== tb_alu SUMMARY =====");
        $display("Total: %0d | Passed: %0d | Failed: %0d", tests, passed, failed);
        if (failed == 0) $display("RESULT: ALL TESTS PASSED");
        else             $display("RESULT: TESTS FAILED");
        $display("==========================");
        $finish;
    end

endmodule
