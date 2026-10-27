`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: tb_riscv_programs
// Description: Self-checking program-level testbench for the CPU top (riscv.sv).
//              Runs the test images in tb/mem/*.mem one after another. Each program
//              is loaded into u_imem.iram, u_dmem.dram is cleared, the core is reset
//              and the PASS/FAIL signature in data memory is checked.
//
// Plusargs:    +MEM_DIR=<path/>  directory holding the .mem files (default "mem/")
//              +TRACE            print every writeback / store
// Dependencies: all files in rtl/ (see rtl_files.f)
//////////////////////////////////////////////////////////////////////////////////

import RV32_PKG::*;

module tb_riscv_programs;

    localparam int MAX_PROGRAM_CYCLES  = 2000;
    localparam logic [31:0] NOP        = 32'h0000_0013;
    localparam logic [31:0] PASS_SIG   = 32'h0000_0055;
    localparam logic [31:0] FAIL_SIG   = 32'h0000_00EE;
    localparam string       ZERO_FILE  = "tb_dmem_zero.mem";

    logic clk = 1'b0;
    logic rst_n = 1'b0;
    logic [REG_SIZE-1:0]  trace_pc;
    logic [INST_SIZE-1:0] trace_inst;

    logic [31:0] prog [0:NUM_WORDS-1];
    string mem_dir = "";
    bit    trace_en = 0;

    int cycle_count = 0;
    int store_count = 0;
    int tests = 0;
    int passed = 0;
    int failed = 0;

    riscv u_dut (
        .clk,
        .rst_n,
        .trace_pc,
        .trace_inst
    );

    always #5 clk = ~clk;

    // =================================================================
    // Bus monitor
    // =================================================================
    always @(posedge clk) begin
        if (rst_n) begin
            cycle_count <= cycle_count + 1;

            if (u_dut.store_we_dmem != 4'b0000) begin
                store_count <= store_count + 1;
                if (trace_en)
                    $display("[%0t] [STORE] addr=%08h we=%04b data=%08h",
                             $time, u_dut.store_addr_dmem, u_dut.store_we_dmem, u_dut.d_store_dmem_m);
            end

            if ((^u_dut.store_we_dmem) === 1'bx) begin
                failed <= failed + 1;
                $error("store_we_dmem is X at cycle %0d", cycle_count);
            end

            if ((^u_dut.c_pc_f) === 1'bx) begin
                failed <= failed + 1;
                $error("PC is X at cycle %0d", cycle_count);
            end

            if (trace_en && u_dut.u_datapath.u_wb.reg_we_w && u_dut.u_datapath.u_wb.rd_w != 0)
                $display("[%0t] [WB]    pc=%08h inst=%08h x%0d = %08h", $time,
                         u_dut.u_datapath.u_wb.c_pc_w, u_dut.u_datapath.u_wb.inst_w,
                         u_dut.u_datapath.u_wb.rd_w, u_dut.u_datapath.u_wb.d_rd_w);
        end
    end

    // =================================================================
    // Helpers
    // =================================================================
    function automatic logic [31:0] dmem_word(input int idx);
        return u_dut.u_memorypath.u_dmem.dram[idx];
    endfunction

    task automatic check_ram_word(
        input int          idx,
        input logic [31:0] expected,
        input string       description
    );
        tests++;
        if (dmem_word(idx) !== expected) begin
            failed++;
            $error("[FAIL] %s: dmem[%0d] expected %08h, got %08h",
                   description, idx, expected, dmem_word(idx));
        end else begin
            passed++;
            $display("[PASS] %s: dmem[%0d] = %08h", description, idx, expected);
        end
    endtask

    task automatic check_store_count(input int expected, input string description);
        tests++;
        if (store_count != expected) begin
            failed++;
            $error("[FAIL] %s: expected %0d store cycles, observed %0d",
                   description, expected, store_count);
        end else begin
            passed++;
            $display("[PASS] %s: observed exactly %0d store cycles", description, expected);
        end
    endtask

    task automatic load_program(input string mem_file);
        int fd;
        string path;
        path = {mem_dir, mem_file};

        fd = $fopen(path, "r");
        if (fd == 0) $fatal(1, "Cannot open %s (set +MEM_DIR=<dir>/)", path);
        $fclose(fd);

        for (int i = 0; i < NUM_WORDS; i++) prog[i] = NOP;
        $readmemh(path, prog);

        for (int i = 0; i < NUM_WORDS; i++)
            u_dut.u_memorypath.u_imem.iram[i] = prog[i];

        // dram is driven by always_ff in dmem, so clear it via $readmemh instead of assignments
        $readmemh(ZERO_FILE, u_dut.u_memorypath.u_dmem.dram);
    endtask

    task automatic run_program(
        input string       name,
        input string       mem_file,
        input int          completion_word,
        input logic [31:0] pass_marker,
        input logic [31:0] fail_marker,
        input logic        has_fail_marker
    );
        logic complete;
        int   cycles;
        begin
            $display("");
            $display("===== Running %s (%s) =====", name, mem_file);

            @(negedge clk);
            rst_n = 1'b0;
            load_program(mem_file);
            store_count = 0;
            cycle_count = 0;

            repeat (4) @(posedge clk);
            @(negedge clk);
            rst_n = 1'b1;

            complete = 1'b0;
            cycles   = 0;
            while (!complete && cycles < MAX_PROGRAM_CYCLES) begin
                @(negedge clk);
                cycles++;
                if (dmem_word(completion_word) === pass_marker)
                    complete = 1'b1;
                else if (has_fail_marker && dmem_word(completion_word) === fail_marker)
                    complete = 1'b1;
            end

            // Let any in-flight stores retire so post-checks see the final state
            repeat (8) @(negedge clk);

            tests++;
            if (!complete) begin
                failed++;
                $error("[FAIL] %s timed out after %0d cycles (dmem[%0d]=%08h, pc=%08h)",
                       name, MAX_PROGRAM_CYCLES, completion_word,
                       dmem_word(completion_word), u_dut.c_pc_f);
            end else if (dmem_word(completion_word) !== pass_marker) begin
                failed++;
                $error("[FAIL] %s wrote FAIL marker %08h to dmem[%0d]",
                       name, dmem_word(completion_word), completion_word);
            end else begin
                passed++;
                $display("[PASS] %s completed in %0d cycles with PASS marker %08h",
                         name, cycles, pass_marker);
            end
        end
    endtask

    // =================================================================
    // Test sequence
    // =================================================================
    initial begin : test_sequence
        void'($value$plusargs("MEM_DIR=%s", mem_dir));
        trace_en = $test$plusargs("TRACE");

        $display("==================================================");
        $display(" riscv.sv program-level testbench (MEM_DIR=%s)", mem_dir);
        $display("==================================================");

        begin : make_zero_image
            int fd;
            fd = $fopen(ZERO_FILE, "w");
            if (fd == 0) $fatal(1, "Cannot create %s", ZERO_FILE);
            for (int i = 0; i < NUM_WORDS; i++) $fdisplay(fd, "00000000");
            $fclose(fd);
        end

        // imem/dmem run their own $readmemh at time 0; load after that
        #1;

        run_program("Level 1: basic instructions",
                    "basic_instructions_test.mem",
                    64, PASS_SIG, FAIL_SIG, 1'b1);
        check_ram_word(64, PASS_SIG, "Basic instruction PASS signature");

        run_program("Level 2: pipeline hazards",
                    "pipeline_harzard_test.mem",
                    67, 32'h0000_0014, 32'h0, 1'b0);
        check_ram_word(64, 32'd30, "Pipeline result x3");
        check_ram_word(65, 32'd50, "Load-use result x7");
        check_ram_word(66, 32'd7,  "Taken-branch target result x9");
        check_ram_word(67, 32'd20, "Pipeline test completion store");
        check_ram_word(68, 32'd0,  "Wrong-path store was flushed");
        check_store_count(4, "Pipeline test");

        run_program("Level 3: load/store subsystem",
                    "load_store_subsystem_test.mem",
                    128, PASS_SIG, FAIL_SIG, 1'b1);
        check_ram_word(64,  32'h80FF_8001, "Seed word and byte address");
        check_ram_word(65,  32'h4433_2211, "SB byte lanes and strobes");
        check_ram_word(66,  32'h0456_0123, "SH halfword lanes and strobes");
        check_ram_word(68,  32'h89AB_C123, "SW/LW word address");
        check_ram_word(128, PASS_SIG,      "Load/store subsystem PASS signature");

        run_program("Level 4: control flow and corner cases",
                    "control_flow_corner_cases_test.mem",
                    64, PASS_SIG, FAIL_SIG, 1'b1);
        check_ram_word(64, PASS_SIG, "Control-flow PASS signature");

        // The signature goes to MMIO 0x80000000; dmem only decodes addr[10:2],
        // so it lands in dram[0].
        run_program("Level 5: SoC all-in-one (ALU/fwd/load-use/branch/jump/MUL/DIV/REM)",
                    "test_soc_all.mem",
                    0, PASS_SIG, FAIL_SIG, 1'b1);
        check_ram_word(0,  PASS_SIG, "SoC all PASS signature (MMIO alias)");
        check_ram_word(64, 32'd10,   "SoC all SW/LW RAM word");

        $display("");
        $display("===== riscv SUMMARY =====");
        $display("Total: %0d | Passed: %0d | Failed: %0d", tests, passed, failed);
        if (failed == 0) $display("RESULT: ALL TESTS PASSED");
        else             $display("RESULT: TESTS FAILED");
        $display("=========================");
        $finish;
    end

    initial begin
        repeat (6 * (MAX_PROGRAM_CYCLES + 20)) @(posedge clk);
        $fatal(1, "TIMEOUT: test sequence did not finish");
    end

endmodule
