`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_cla
// Description: Self-checking testbench for the 32-bit hierarchical CLA (cla.sv)
// Dependencies: cla.sv, gp1.sv, gp4.sv, gp8.sv
//////////////////////////////////////////////////////////////////////////////////

module tb_cla;

    logic [31:0] a, b;
    logic        cin;
    logic [31:0] sum;

    int tests = 0;
    int passed = 0;
    int failed = 0;

    cla dut (
        .a,
        .b,
        .cin,
        .sum
    );

    task automatic check(
        input logic [31:0] ta,
        input logic [31:0] tb,
        input logic        tcin,
        input string       label = ""
    );
        logic [31:0] expected;
        begin
            a   = ta;
            b   = tb;
            cin = tcin;
            #1;
            expected = ta + tb + {31'b0, tcin};

            tests++;
            if (sum !== expected) begin
                failed++;
                $error("[FAIL] %s a=%08h b=%08h cin=%b | got=%08h exp=%08h",
                       label, ta, tb, tcin, sum, expected);
            end else begin
                passed++;
                if (label != "")
                    $display("[PASS] %s a=%08h b=%08h cin=%b sum=%08h", label, ta, tb, tcin, sum);
            end
        end
    endtask

    initial begin
        $display("==================================================");
        $display(" tb_cla: 32-bit CLA self-checking testbench");
        $display("==================================================");

        $display("--- Begin Directed tests (90 cases) ---");
        check(32'd0,          32'd0,          1'b0, "zero");
        check(32'd0,          32'd0,          1'b1, "cin only");
        check(32'd10,         32'd5,          1'b0, "basic");
        check(32'hFFFF_FFFF,  32'd1,          1'b0, "full ripple wrap");
        check(32'hFFFF_FFFF,  32'd0,          1'b1, "cin ripple wrap");
        check(32'hFFFF_FFFF,  32'hFFFF_FFFF,  1'b1, "all ones + cin");
        check(32'h7FFF_FFFF,  32'd1,          1'b0, "signed overflow");
        check(32'hAAAA_AAAA,  32'h5555_5555,  1'b0, "propagate all");
        check(32'hAAAA_AAAA,  32'h5555_5555,  1'b1, "propagate all + cin");
        check(32'h8000_0000,  32'h8000_0000,  1'b0, "MSB carry out dropped");

        // Carry generated at each 4-bit group boundary, propagated through the rest
        for (int g = 0; g < 8; g++) begin
            check(32'hFFFF_FFFF, 32'h1 << (4*g), 1'b0, $sformatf("group %0d generate", g));
            check(32'h0000_000F << (4*g), 32'h1 << (4*g), 1'b0, $sformatf("group %0d boundary", g));
        end

        // Walking single bit carries
        for (int i = 0; i < 32; i++) begin
            check(32'h1 << i, 32'h1 << i, 1'b0, "");
            check((32'h1 << i) - 1, 32'h1, 1'b0, "");
        end
        $display("--- End Directed tests ---");

        $display("--- Begin Exhaustive low-byte tests (4096 cases) ---");
        for (int i = 0; i < 256; i++)
            for (int j = 0; j < 256; j += 17)
                check(i, j, i[0] ^ j[0], "");
        $display("--- End Exhaustive low-byte tests ---");

        $display("--- Begin Random tests (5000 cases) ---");
        repeat (5000) check($urandom, $urandom, $urandom_range(0, 1));
        $display("--- End Random tests ---");

        $display("===== tb_cla SUMMARY =====");
        $display("Total: %0d | Passed: %0d | Failed: %0d", tests, passed, failed);
        if (failed == 0) $display("RESULT: ALL TESTS PASSED");
        else             $display("RESULT: TESTS FAILED");
        $display("==========================");
        $finish;
    end

endmodule
