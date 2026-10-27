# RV32IM UVM Testbench

## What Is Included

`rv32im_uvm_tb.sv` contains a UVM agent, an ISS-based scoreboard with functional coverage, and several tests.

- **Backdoor**: `tb_top` implements `rv32im_backdoor` with hierarchical references (load IMEM, clear DMEM, read registers/DMEM). No `uvm_hdl_*`/`+acc` is needed.
- **Driver**: loads the image, clears DMEM, resets the core and runs until the signature store is seen on the DMEM write port (or `max_cycles`), then drains the pipeline.
- **Monitor**: samples the WB retirement (`trace_pc/inst`, `reg_we_w/rd_w/d_rd_w`) and the MEM store port (`store_we/addr/data`).
- **Scoreboard**: a RV32IM ISS runs in lock-step with every retirement and checks PC order, the register write, and every store (address, strobe, data). DIV/REM retire twice in this core (shell with `reg_we=0`, then the divider writeback); the writeback is matched against a pending queue. At program end the whole register file and DMEM are compared with the ISS.
- **Coverage**: opcode, branch taken/not-taken, and RAW-hazard distance (1..3) x producer type (ALU/LOAD/MUL/DIV/JUMP).

`imem.mem` and `dmem.mem` are startup placeholders for the RTL `$readmemh` calls; the driver supplies the actual contents. The testbench writes `uvm_dmem_zero.mem` into the run directory to clear DMEM.

## Tests

| Test | Content |
| --- | --- |
| `rv32im_directed_test` | Hand-encoded program below |
| `rv32im_mem_regression_test` | All images in `tb/mem` (basic, pipeline hazard, load/store, control flow, SoC all) with signature and expected-word checks |
| `rv32im_mem_file_test` | One image: `+MEM_FILE=<file> [+SIG_WORD=<n>] [+PASS_MARKER=<hex>] [+FAIL_MARKER=<hex>] [+MAX_CYCLES=<n>]` |
| `rv32im_random_test` | Constrained-random programs (ALU, M-ext, loads/stores, forward branches, JAL/JALR): `+NUM_PROGRAMS=<n> +PROG_LEN=<n>` |
| `rv32im_full_regression_test` | Directed + mem regression + random |

`+MEM_DIR=<dir>/` selects the image directory (default `../mem/`). `+UVM_VERBOSITY=UVM_HIGH` prints every retirement and store.

The ISS follows the RISC-V spec. Signed DIV/REM by zero with a negative dividend is expected to be reported by the scoreboard, because `div_pipelined.sv` negates the all-ones quotient.

### Directed program

`rv32im_directed_test` exercises:

| Case | Stimulus / expected result |
| --- | --- |
| Reset and fetch | PC starts at zero and retires valid instructions |
| Integer ALU | ADDI, ADD, SUB, AND, OR, XOR and architectural register results |
| Forwarding | An immediately dependent ADDI/ADD pair computes x3 and x4 correctly |
| Store/load | SW followed by LW returns the stored word |
| Load-use hazard | An ADD consumes the immediately preceding LW result |
| Branch flush | A taken BNE skips a write to x12 |
| JAL flush/link | JAL skips a write to x14 and writes the return PC to x13 |
| M extension | MUL and signed DIV produce x16=120 and x17=3 |
| Divider dependency | An instruction consuming x17 waits and then writes x18=4 |
| x0 invariant | x0 remains zero |

Additional recommended tests, not yet encoded in this starter test, are listed below. Add each as a separate `uvm_test` or sequence and check final architectural state as well as the trace.

- Arithmetic corner cases: signed overflow, negative operands, shift amounts 0 and 31, SLT versus SLTU, and writes targeting x0.
- Load/store formats: LB/LBU, LH/LHU, SB/SH, byte offsets 0 through 3, and read-after-write behavior.
- Control flow: not-taken BEQ/BNE/BLT/BGE/BLTU/BGEU, negative branch offsets, JALR target alignment, and consecutive redirects.
- Divider: DIVU/REM/REMU, negative operands, divisor zero, minimum signed integer divided by -1, and back-to-back independent divides.
- Hazards: both source operands dependent on a load, stores dependent on a load base/data, multiple forwarding sources, and ALU/divider writeback collisions.
- Robustness: reset asserted while the pipeline/divider is active, illegal instruction handling, and behavior near the 512-word memory boundary.

## Questa Example

Compile and run with a Questa installation that provides the UVM library. Run from this directory so the RTL memory-image paths resolve:

```powershell
vlog -sv -L uvm -f rtl_files.f rv32im_uvm_tb.sv
vsim -c tb_top +UVM_TESTNAME=rv32im_full_regression_test -sv_seed random -do "coverage save -onexit cov.ucdb; run -all; quit -f"
```

For another simulator, compile `rtl_files.f` in order plus `rv32im_uvm_tb.sv` with its UVM library, and run from `tb/uvm` (or pass `+MEM_DIR`).