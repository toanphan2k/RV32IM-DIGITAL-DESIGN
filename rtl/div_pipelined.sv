`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: div_pipelined
// Description: 8-stage pipelined 32-bit signed/unsigned divider (RV32M).
//              - Stage 0 resolves the upper 4 dividend bits (width-pruned 4-bit
//                restoring steps) in parallel with precomputing 3 * abs_divisor.
//              - Stages 1..7 each perform two 2-bit Radix-4 restoring steps
//                using registered 1x, 2x, and 3x divisor multiples, cutting per-
//                stage carry-chain depth in half while keeping exact 8-cycle latency.
//              - Per-stage valid gating enables synthesis clock-gating when idle.
//////////////////////////////////////////////////////////////////////////////////

module div_pipelined (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        i_valid = 1'b1,
    input  logic        is_signed,
    input  logic [31:0] i_dividend,
    input  logic [31:0] i_divisor,
    output logic [31:0] o_remainder,
    output logic [31:0] o_quotient
);

    logic        sign_dividend;
    logic        sign_divisor;
    logic [31:0] abs_dividend;
    logic [31:0] abs_divisor;
    logic [33:0] divisor3_in;
    logic        negate_quot_in;
    logic        negate_rem_in;

    assign sign_dividend  = is_signed & i_dividend[31];
    assign sign_divisor   = is_signed & i_divisor[31];
    assign abs_dividend   = sign_dividend ? -i_dividend : i_dividend;
    assign abs_divisor    = sign_divisor  ? -i_divisor  : i_divisor;
    assign divisor3_in    = {2'b00, abs_divisor} + {1'b0, abs_divisor, 1'b0};
    assign negate_quot_in = sign_dividend ^ sign_divisor;
    assign negate_rem_in  = sign_dividend;

    logic        p_valid             [0:7];
    logic [31:0] p_divisor           [0:6];
    logic [33:0] p_divisor3          [0:6];
    logic [31:0] p_remainder         [0:7];
    logic [31:0] p_dividend          [0:7];
    logic        p_neg_quot          [0:7];
    logic        p_neg_rem           [0:7];
    logic        p_div_by_zero       [0:7];
    logic        p_overflow          [0:7];
    logic [31:0] p_original_dividend [0:7];

    logic [31:0] stage_div_out       [0:7];
    logic [31:0] stage_rem_out       [0:7];

    // -------------------------------------------------------------------------
    // Stage 0: Initial remainder is 0, so only abs_dividend[31:28] (4 bits) can
    // be non-zero. If abs_divisor >= 16, all 4 quotient bits are 0 immediately.
    // -------------------------------------------------------------------------
    logic       s0_div_hi_nz;
    logic [3:0] s0_d4;
    logic [3:0] s0_q;
    logic [3:0] s0_rem [0:4];

    assign s0_div_hi_nz = |abs_divisor[31:4];
    assign s0_d4        = abs_divisor[3:0];
    assign s0_rem[0]    = 4'd0;

    genvar i, j;
    generate
        for (j = 0; j < 4; j = j + 1) begin : gen_s0_iters
            logic [3:0] pr4;
            logic [4:0] sub5;
            logic       take;

            assign pr4         = {s0_rem[j][2:0], abs_dividend[31 - j]};
            assign sub5        = {1'b0, pr4} - {1'b0, s0_d4};
            assign take        = (~s0_div_hi_nz) & (~sub5[4]);
            assign s0_q[3 - j] = take;
            assign s0_rem[j+1] = take ? sub5[3:0] : pr4;
        end

        assign stage_div_out[0] = {abs_dividend[27:0], s0_q};
        assign stage_rem_out[0] = {28'd0, s0_rem[4]};

        // ---------------------------------------------------------------------
        // Stages 1..7: Two Radix-4 (2-bit) restoring iterations per stage using
        // registered 1xD, 2xD, and 3xD multiples (halves serial carry depth).
        // ---------------------------------------------------------------------
        for (i = 1; i < 8; i = i + 1) begin : gen_stages
            logic [31:0] r_step [0:2];
            logic [3:0]  q_stage;

            assign r_step[0] = p_remainder[i-1];

            for (j = 0; j < 2; j = j + 1) begin : gen_r4_iters
                logic [1:0]  top2;
                logic [33:0] pr34;
                logic [34:0] sub1, sub2, sub3;
                logic [1:0]  q2;
                logic [31:0] rem_next;

                assign top2 = (j == 0) ? p_dividend[i-1][31:30] : p_dividend[i-1][29:28];
                assign pr34 = {r_step[j], top2};
                assign sub1 = {1'b0, pr34} - {3'b000, p_divisor[i-1]};
                assign sub2 = {1'b0, pr34} - {2'b00,  p_divisor[i-1], 1'b0};
                assign sub3 = {1'b0, pr34} - {1'b0,   p_divisor3[i-1]};

                always_comb begin
                    if (!sub3[34]) begin
                        q2       = 2'b11;
                        rem_next = sub3[31:0];
                    end else if (!sub2[34]) begin
                        q2       = 2'b10;
                        rem_next = sub2[31:0];
                    end else if (!sub1[34]) begin
                        q2       = 2'b01;
                        rem_next = sub1[31:0];
                    end else begin
                        q2       = 2'b00;
                        rem_next = pr34[31:0];
                    end
                end

                assign r_step[j+1] = rem_next;
                if (j == 0) begin : gen_q_hi
                    assign q_stage[3:2] = q2;
                end else begin : gen_q_lo
                    assign q_stage[1:0] = q2;
                end
            end

            assign stage_div_out[i] = {p_dividend[i-1][27:0], q_stage};
            assign stage_rem_out[i] = r_step[2];
        end
    endgenerate

    integer k;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (k = 0; k < 8; k = k + 1) begin
                p_valid[k]             <= 1'b0;
                p_dividend[k]          <= '0;
                p_remainder[k]         <= '0;
                p_neg_quot[k]          <= 1'b0;
                p_neg_rem[k]           <= 1'b0;
                p_div_by_zero[k]       <= 1'b0;
                p_overflow[k]          <= 1'b0;
                p_original_dividend[k] <= '0;
            end
            for (k = 0; k < 7; k = k + 1) begin
                p_divisor[k]           <= '0;
                p_divisor3[k]          <= '0;
            end
        end else begin
            p_valid[0] <= i_valid;
            if (i_valid) begin
                p_dividend[0]          <= stage_div_out[0];
                p_remainder[0]         <= stage_rem_out[0];
                p_divisor[0]           <= abs_divisor;
                p_divisor3[0]          <= divisor3_in;
                p_neg_quot[0]          <= negate_quot_in;
                p_neg_rem[0]           <= negate_rem_in;
                p_div_by_zero[0]       <= (i_divisor == 32'd0);
                p_overflow[0]          <= is_signed &&
                                          (i_dividend == 32'h8000_0000) &&
                                          (i_divisor  == 32'hffff_ffff);
                p_original_dividend[0] <= i_dividend;
            end

            for (k = 1; k < 8; k = k + 1) begin
                p_valid[k] <= p_valid[k-1];
                if (p_valid[k-1]) begin
                    p_dividend[k]          <= stage_div_out[k];
                    p_remainder[k]         <= stage_rem_out[k];
                    p_neg_quot[k]          <= p_neg_quot[k-1];
                    p_neg_rem[k]           <= p_neg_rem[k-1];
                    p_div_by_zero[k]       <= p_div_by_zero[k-1];
                    p_overflow[k]          <= p_overflow[k-1];
                    p_original_dividend[k] <= p_original_dividend[k-1];
                    if (k < 7) begin
                        p_divisor[k]       <= p_divisor[k-1];
                        p_divisor3[k]      <= p_divisor3[k-1];
                    end
                end
            end
        end
    end

    always_comb begin
        if (p_div_by_zero[7]) begin
            o_remainder = p_original_dividend[7];
            o_quotient  = 32'hffff_ffff;
        end else if (p_overflow[7]) begin
            o_remainder = 32'b0;
            o_quotient  = 32'h8000_0000;
        end else begin
            o_remainder = p_neg_rem[7]  ? -p_remainder[7] : p_remainder[7];
            o_quotient  = p_neg_quot[7] ? -p_dividend[7]  : p_dividend[7];
        end
    end

endmodule
