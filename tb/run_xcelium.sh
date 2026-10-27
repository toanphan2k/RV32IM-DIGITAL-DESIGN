#!/usr/bin/env bash
set -euo pipefail

usage() {
    printf '%s\n' \
        'Usage: bash tb/run_xcelium.sh [all|alu|cla|div|cpu] [--waves] [--trace]' \
        'Run from any directory on a Linux host with xrun on PATH.' \
        'Default: all. --waves records SHM waveforms; --trace enables CPU logging.' \
        'Optional: XRUN_BIN=/path/to/xrun SIM_OUT=/path/to/results'
}

test_name=all
waves=0
trace=0
selected=0
for argument in "$@"; do
    case "$argument" in
        all|alu|cla|div|cpu)
            if (( selected )); then
                usage >&2
                exit 2
            fi
            test_name=$argument
            selected=1
            ;;
        --waves) waves=1 ;;
        --trace) trace=1 ;;
        -h|--help) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
    esac
done

tb_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
project_dir=$(cd -- "$tb_dir/.." && pwd)
rtl_dir="$project_dir/rtl"
xrun_bin=${XRUN_BIN:-xrun}
if ! command -v "$xrun_bin" >/dev/null 2>&1; then
    printf 'Cannot find %s. Load the Cadence environment on the remote host first.\n' "$xrun_bin" >&2
    exit 127
fi
xrun_bin=$(command -v "$xrun_bin")
if [[ "$xrun_bin" != /* ]]; then
    xrun_bin="$PWD/$xrun_bin"
fi

output_dir=${SIM_OUT:-"$project_dir/sim/xcelium"}
mkdir -p -- "$output_dir"
output_dir=$(cd -- "$output_dir" && pwd)

run_test() (
    local name=$1
    local top
    local source
    local status=0
    local -a sources=()
    local -a options=()
    case "$name" in
        cla)
            top=tb_cla
            sources=(gp1.sv gp4.sv gp8.sv cla.sv)
            ;;
        alu)
            top=tb_alu
            sources=(def_pkg.sv gp1.sv gp4.sv gp8.sv cla.sv mul.sv alu.sv)
            ;;
        div)
            top=tb_div_unit
            sources=(def_pkg.sv divu_1iter.sv div_pipelined.sv div_unit.sv)
            ;;
        cpu)
            top=tb_riscv_programs
            sources=(def_pkg.sv)
            for source in "$rtl_dir"/*.sv; do
                [[ "${source##*/}" == def_pkg.sv ]] || sources+=("${source##*/}")
            done
            ;;
    esac
    for source in "${!sources[@]}"; do
        sources[$source]="$rtl_dir/${sources[$source]}"
    done

    mkdir -p -- "$output_dir/$name"
    cd -- "$output_dir/$name"
    if [[ "$name" == cpu ]]; then
        # RTL initial blocks read these before the testbench loads each program.
        for ((word=0; word<512; word++)); do printf '00000013\n'; done > imem.mem
        for ((word=0; word<512; word++)); do printf '00000000\n'; done > dmem.mem
        options+=("+MEM_DIR=$tb_dir/mem/")
        if (( trace )); then options+=(+TRACE); fi
    fi
    if (( waves )); then
        options+=(-access +rwc -input "$tb_dir/xcelium_waves.tcl")
    fi

    printf '\n===== %s: %s =====\n' "$name" "$PWD"
    "$xrun_bin" -64bit -sv -top "$top" -l xrun.log \
        "${sources[@]}" "$tb_dir/$top.sv" "${options[@]}" > console.log 2>&1 || status=$?
    cat console.log
    if (( status != 0 )); then
        printf 'FAIL: %s (xrun exit %s). See %s/console.log\n' "$name" "$status" "$PWD" >&2
        exit 1
    fi
    if grep -Fq 'RESULT: TESTS FAILED' console.log ||
       ! grep -Fq 'RESULT: ALL TESTS PASSED' console.log; then
        printf 'FAIL: %s (failed or missing test summary). See %s/console.log\n' "$name" "$PWD" >&2
        exit 1
    fi
    printf 'PASS: %s\n' "$name"
)

tests=("$test_name")
if [[ "$test_name" == all ]]; then tests=(cla alu div cpu); fi
failed=0
for test_name in "${tests[@]}"; do
    if ! run_test "$test_name"; then failed=1; fi
done
printf '\nResults: %s\n' "$output_dir"
exit "$failed"