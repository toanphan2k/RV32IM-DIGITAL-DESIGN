`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_div_unit
// Description: Self-checking testbench for div_unit.sv (8-stage pipelined divider).
//              Issues back-to-back DIV/DIVU/REM/REMU (with bubbles) and checks the
//              result, the tag {is_div, is_rem, rd} and PC/INST trace after 8 cycles.
// Dependencies: def_pkg.sv, div_unit.sv, div_pipelined.sv, divu_1iter.sv
//////////////////////////////////////////////////////////////////////////////////

import RV32_PKG::*;

module tb_div_unit;

    localparam int LATENCY = DIVIDER_STAGES;

    logic                   clk = 1'b0;
    logic                   rst_n = 1'b0;
    logic [4:0]             alu_ctrl_e;
    logic [REG_SIZE-1:0]    dividend, divisor;
    logic [4:0]             rd_addr_e;
    logic [REG_SIZE-1:0]    c_pc_e;
    logic [INST_SIZE-1:0]   inst_e;

    logic [6:0]             div_stage_0, div_stage_1, div_stage_2, div_stage_3,
                            div_stage_4, div_stage_5, div_stage_6, div_stage_7;
    logic [REG_SIZE-1:0]    div_pc_end;
    logic [INST_SIZE-1:0]   div_inst_end;
    logic [REG_SIZE-1:0]    quotient, remainder;

    typedef struct {
        logic [4:0]  op;
        logic [31:0] a;
        logic [31:0] b;
        logic [31:0] exp_q;
        logic [31:0] exp_r;
        logic [4:0]  rd;
        logic [31:0] pc;
        logic [31:0] inst;
    } div_txn_t;

    div_txn_t scoreboard[$];

    int tests = 0;
    int passed = 0;
    int failed = 0;
    int issued = 0;

    div_unit dut (
        .clk,
        .rst_n,
        .alu_ctrl_e,
        .dividend,
        .divisor,
        .rd_addr_e,
        .c_pc_e,
        .inst_e,
        .div_stage_0, .div_stage_1, .div_stage_2, .div_stage_3,
        .div_stage_4, .div_stage_5, .div_stage_6, .div_stage_7,
        .div_pc_end,
        .div_inst_end,
        .quotient,
        .remainder
    );

    always #5 clk = ~clk;

    function automatic string op_name(input logic [4:0] op);
        case (op)
            ALU_DIV:  return "DIV";
            ALU_DIVU: return "DIVU";
            ALU_REM:  return "REM";
            ALU_REMU: return "REMU";
            default:  return "NONDIV";
        endcase
    endfunction

    // RISC-V spec reference (quotient and remainder for the given signedness)
    task automatic ref_div(
        input  logic [31:0] a,
        input  logic [31:0] b,
        input  logic        is_signed,
        output logic [31:0] q,
        output logic [31:0] r
    );
        if (b == 32'd0) begin
            q = 32'hFFFF_FFFF;
            r = a;
        end else if (is_signed && a == 32'h8000_0000 && b == 32'hFFFF_FFFF) begin
            q = 32'h8000_0000;
            r = 32'd0;
        end else if (is_signed) begin
            q = $signed(a) / $signed(b);
            r = $signed(a) % $signed(b);
        end else begin
            q = a / b;
            r = a % b;
        end
    endtask

    function automatic logic [31:0] encode_div(input logic [4:0] op, input logic [4:0] rd);
        logic [2:0] funct3;
        case (op)
            ALU_DIV:  funct3 = 3'b100;
            ALU_DIVU: funct3 = 3'b101;
            ALU_REM:  funct3 = 3'b110;
            default:  funct3 = 3'b111;
        endcase
        return {7'b0000001, 5'd2, 5'd1, funct3, rd, 7'b0110011};
    endfunction

    // Drive one instruction on the next cycle (call at negedge)
    task automatic drive(input logic [4:0] op, input logic [31:0] a, input logic [31:0] b);
        div_txn_t t;
        logic is_div_op;
        begin
            is_div_op = (op == ALU_DIV) || (op == ALU_DIVU) || (op == ALU_REM) || (op == ALU_REMU);
            alu_ctrl_e = op;
            dividend   = a;
            divisor    = b;
            rd_addr_e  = is_div_op ? 5'(1 + (issued % 31)) : 5'($urandom);
            c_pc_e     = 32'h1000 + 4 * issued;
            inst_e     = is_div_op ? encode_div(op, rd_addr_e) : 32'h0000_0013;

            if (is_div_op) begin
                t.op   = op;
                t.a    = a;
                t.b    = b;
                t.rd   = rd_addr_e;
                t.pc   = c_pc_e;
                t.inst = inst_e;
                ref_div(a, b, (op == ALU_DIV) || (op == ALU_REM), t.exp_q, t.exp_r);
                scoreboard.push_back(t);
            end
            issued++;
        end
    endtask

    task automatic check_output();
        div_txn_t t;
        logic [31:0] exp_res, got_res;
        logic is_rem_op;
        begin
            if (div_stage_7[6] !== 1'b1) return;

            tests++;
            if (scoreboard.size() == 0) begin
                failed++;
                $error("[FAIL] div_stage_7 valid but no transaction expected (stage7=%07b)", div_stage_7);
                return;
            end

            t = scoreboard.pop_front();
            is_rem_op = (t.op == ALU_REM) || (t.op == ALU_REMU);
            exp_res   = is_rem_op ? t.exp_r : t.exp_q;
            got_res   = div_stage_7[5] ? remainder : quotient;

            if ((quotient     !== t.exp_q) ||
                (remainder    !== t.exp_r) ||
                (got_res      !== exp_res) ||
                (div_stage_7  !== {1'b1, is_rem_op, t.rd}) ||
                (div_pc_end   !== t.pc) ||
                (div_inst_end !== t.inst)) begin
                failed++;
                $error("[FAIL] %s a=%08h b=%08h | got q=%08h r=%08h tag=%07b pc=%08h inst=%08h | exp q=%08h r=%08h tag=%07b pc=%08h inst=%08h",
                       op_name(t.op), t.a, t.b, quotient, remainder, div_stage_7, div_pc_end, div_inst_end,
                       t.exp_q, t.exp_r, {1'b1, is_rem_op, t.rd}, t.pc, t.inst);
            end else begin
                passed++;
                $display("[PASS] %-4s a=%08h b=%08h -> %08h (rd=x%0d)",
                         op_name(t.op), t.a, t.b, got_res, t.rd);
            end
        end
    endtask

    // Advance one cycle: check what is leaving stage 7, then drive the next input
    task automatic step(input logic [4:0] op, input logic [31:0] a, input logic [31:0] b);
        @(negedge clk);
        check_output();
        drive(op, a, b);
    endtask

    task automatic all_ops(input logic [31:0] a, input logic [31:0] b);
        step(ALU_DIV,  a, b);
        step(ALU_DIVU, a, b);
        step(ALU_REM,  a, b);
        step(ALU_REMU, a, b);
    endtask

    task automatic flush_pipe();
        repeat (LATENCY + 1) step(ALU_ADD, 32'd0, 32'd0);
    endtask

    localparam logic [4:0] DIV_OPS [0:3] = '{ALU_DIV, ALU_DIVU, ALU_REM, ALU_REMU};

    initial begin
        $display("==================================================");
        $display(" tb_div_unit: pipelined divider testbench");
        $display("==================================================");

        alu_ctrl_e = ALU_ADD;
        dividend   = '0;
        divisor    = '0;
        rd_addr_e  = '0;
        c_pc_e     = '0;
        inst_e     = 32'h0000_0013;

        repeat (3) @(posedge clk);
        @(negedge clk);

        tests++;
        if ({div_stage_7, quotient, remainder, div_pc_end, div_inst_end} !== '0) begin
            failed++;
            $error("[FAIL] Outputs not cleared during reset");
        end else begin
            passed++;
            $display("[PASS] Reset clears pipeline outputs");
        end
        rst_n = 1'b1;

        // ---------------- Basic ----------------
        $display("--- Basic ---");
        all_ops(32'd20, 32'd6);
        all_ops(32'd10, 32'd3);
        all_ops(32'd100, 32'd10);
        all_ops(32'd7, 32'd9);
        all_ops(32'd5, 32'd5);
        all_ops(32'd0, 32'd5);

        // ---------------- Signed ----------------
        $display("--- Signed ---");
        all_ops(-32'sd10, 32'd3);
        all_ops(32'd10, -32'sd3);
        all_ops(-32'sd10, -32'sd3);
        all_ops(-32'sd1, 32'd2);
        all_ops(32'h8000_0000, 32'd1);
        all_ops(32'h7FFF_FFFF, 32'd2);

        // ---------------- Divide by zero ----------------
        $display("--- Divide by zero ---");
        all_ops(32'd100, 32'd0);
        all_ops(-32'sd10, 32'd0);
        all_ops(32'hFFFF_FFFF, 32'd0);
        all_ops(32'd0, 32'd0);

        // ---------------- Signed overflow ----------------
        $display("--- Signed overflow INT_MIN / -1 ---");
        all_ops(32'h8000_0000, 32'hFFFF_FFFF);

        // ---------------- Boundary ----------------
        $display("--- Boundary ---");
        all_ops(32'hFFFF_FFFF, 32'd1);
        all_ops(32'hFFFF_FFFF, 32'd2);
        all_ops(32'hFFFF_FFFF, 32'hFFFF_FFFF);
        all_ops(32'h5555_5555, 32'd3);
        all_ops(32'hAAAA_AAAA, 32'd7);
        all_ops(32'hCCCC_CCCC, 32'h0000_0101);
        all_ops(32'hFFFF_FFFF, 32'h4000_0000);
        all_ops(32'd1, 32'h8000_0000);
        flush_pipe();

        // ---------------- Bubbles between divides ----------------
        $display("--- Interleaved non-divide ops (bubbles) ---");
        repeat (40) begin
            if ($urandom_range(0, 1))
                step(DIV_OPS[$urandom_range(0, 3)], $urandom, $urandom_range(1, 1000));
            else
                step(ALU_ADD, $urandom, $urandom);
        end
        flush_pipe();

        // ---------------- Random back-to-back ----------------
        $display("--- Random back-to-back ---");
        repeat (500) step(DIV_OPS[$urandom_range(0, 3)], $urandom, $urandom);
        repeat (200) step(DIV_OPS[$urandom_range(0, 3)], $urandom, $urandom_range(0, 255));
        flush_pipe();

        tests++;
        if (scoreboard.size() != 0) begin
            failed++;
            $error("[FAIL] %0d transaction(s) never came out of the divider", scoreboard.size());
        end else begin
            passed++;
        end

        $display("===== tb_div_unit SUMMARY =====");
        $display("Total: %0d | Passed: %0d | Failed: %0d", tests, passed, failed);
        if (failed == 0) $display("RESULT: ALL TESTS PASSED");
        else             $display("RESULT: TESTS FAILED");
        $display("===============================");
        $finish;
    end

    initial begin
        #1_000_000;
        $fatal(1, "TIMEOUT");
    end

endmodule
