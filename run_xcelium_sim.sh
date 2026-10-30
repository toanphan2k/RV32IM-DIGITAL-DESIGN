#!/usr/bin/env bash
set -euo pipefail

#DEFAULTS
TOP_FILE=""
EN_MEM=false
EN_MEM_DIR=false
EN_UVM=false
COMPILE_ONLY=false
RUN_ONLY=false
TEST_NAME=""
PROJECT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
TOP_SOURCE=""
TOP_MODULE=""
MEM_FILE_LIST=""
MEM_DIR=""
XRUN_ARGS=()
usage() {
    cat <<EOF
Usage:
    run_xcelium_sim.sh --top <testbench.sv> [--mem <mem_files.f>] [--mem-dir <dir>] [--uvm] [--test-name NAME]
    run_xcelium_sim.sh --top <testbench.sv> --compile [--uvm]
    run_xcelium_sim.sh --top <testbench.sv> (--run|-R) [--test-name NAME]

Options:
  -h, --help            Show this help message
  --top FILE            Select the top module from FILE's filename (required)
      --mem-file FILE   Include FILE in the Xrun file lists
      --mem-dir DIR     Set +MEM_DIR=DIR for testbenches that load memory files
  --uvm                 Enable UVM for compile-and-run or compile-only
  --test-name NAME      Set +UVM_TESTNAME=NAME
  --compile             Compile only; do not simulate
  --run, -R             Run the prior compile in this top's output directory

Examples:
    run_xcelium_sim.sh --top tb_riscv_programs.sv
    run_xcelium_sim.sh --top tb/tb_alu.sv --uvm --test-name rv32im_base_test
    run_xcelium_sim.sh --top tb_top.sv --uvm --compile
    run_xcelium_sim.sh --top tb_top.sv -R --test-name rv32im_base_test

Default mode compiles, elaborates, and simulates. Use --compile to stop after
compilation, then --run (or -R) to run that compiled design later.

Testbench files can be in the current directory, the workspace root, or tb/.
The RTL paths in rtl_files.f are relative to sim/xcelium/<top>. The --top
filename selects this output directory, including when using --run.
Xrun must be available on PATH.
EOF
}

while (($#)); do
    argument=$1
    shift
    case "$argument" in
        --top)
            if (($# == 0)) || [[ -z "$1" ]] || [[ -n "$TOP_FILE" ]]; then
                usage >&2
                exit 2
            fi
            TOP_FILE=$1
            shift
            ;;
        --mem-file)
            if (($# == 0)) || [[ -z "$1" ]] || [[ "$EN_MEM" == true ]]; then
                usage >&2
                exit 2
            fi
            MEM_FILE_LIST=$1
            EN_MEM=true
            shift
            ;;
        --mem-dir)
            if (($# == 0)) || [[ -z "$1" ]] || [[ "$EN_MEM_DIR" == true ]]; then
                usage >&2
                exit 2
            fi
            MEM_DIR=$1
            EN_MEM_DIR=true
            shift
            ;;
        --uvm)
            if [[ "$EN_UVM" == true ]]; then
                usage >&2
                exit 2
            fi
            EN_UVM=true
            ;;
        --compile)
            if [[ "$COMPILE_ONLY" == true ]]; then
                usage >&2
                exit 2
            fi
            COMPILE_ONLY=true
            ;;
        --run|-R)
            if [[ "$RUN_ONLY" == true ]]; then
                usage >&2
                exit 2
            fi
            RUN_ONLY=true
            ;;
        --test-name)
            if (($# == 0)) || [[ -z "$1" ]] || [[ -n "$TEST_NAME" ]]; then
                usage >&2
                exit 2
            fi
            TEST_NAME=$1
            shift
            ;;
        -h|--help) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
    esac
done

if [[ "$COMPILE_ONLY" == true && "$RUN_ONLY" == true ]]; then
    usage >&2
    exit 2
fi

environment_check() {
    if ! xrun_bin=$(which xrun 2>/dev/null); then
        echo "Cannot find xrun. Load the Cadence environment on the remote host first." >&2
        exit 127
    fi
}

check_top_file() {
    if [[ -z "$TOP_FILE" || "$TOP_FILE" != *.sv ]]; then
        usage >&2
        exit 2
    fi

    if [[ "$RUN_ONLY" != true && ! -f "$TOP_FILE" ]]; then
        echo "Cannot find top file: $TOP_FILE" >&2
        exit 2
    fi
}

update_top_src_and_top_modulde() {
    if [[ "$RUN_ONLY" != true ]]; then
        TOP_SOURCE=$(realpath -- "$TOP_FILE")
    fi
    TOP_MODULE=${TOP_FILE##*/}
    TOP_MODULE=${TOP_MODULE%.sv}
}

check_rtl_files() {
    if [[ "$RUN_ONLY" == true ]]; then
        return
    fi

    RTL_FILE_LIST="$PROJECT_DIR/rtl_files.f"
    if [[ ! -f "$RTL_FILE_LIST" ]]; then
        echo "Cannot find RTL file list: $RTL_FILE_LIST" >&2
        exit 2
    fi
}

check_mem_file_list() {
    if [[ "$EN_MEM" == true ]]; then
        if [[ ! -f "$MEM_FILE_LIST" ]]; then
            echo "Cannot find memory file list: $MEM_FILE_LIST" >&2
            exit 2
        fi
        MEM_FILE_LIST=$(realpath -- "$MEM_FILE_LIST")
    fi
}

check_mem_dir() {
    if [[ "$EN_MEM_DIR" == true ]]; then
        if [[ ! -d "$MEM_DIR" ]]; then
            echo "Cannot find memory directory: $MEM_DIR" >&2
            exit 2
        fi
        MEM_DIR=$(realpath -- "$MEM_DIR")
    fi
}

create_output_dir() {
    local output_root="$PROJECT_DIR/sim/xcelium"
    mkdir -p -- "$output_root/$TOP_MODULE"
    OUTPUT_DIR=$(cd -- "$output_root/$TOP_MODULE" && pwd)
}

xrun_args_parser() {
    XRUN_ARGS=()
    if [[ "$RUN_ONLY" == true ]]; then
        XRUN_ARGS+=(-R)
        if [[ -n "$TEST_NAME" ]]; then
            XRUN_ARGS+=("+UVM_TESTNAME=$TEST_NAME")
        fi
        XRUN_ARGS+=(-l xrun.log)
    else
        XRUN_ARGS+=(-64bit)
        XRUN_ARGS+=(-sv)
        if [[ "$EN_UVM" == true ]]; then
            XRUN_ARGS+=(-uvm)
        fi
        if [[ "$COMPILE_ONLY" == true ]]; then
            XRUN_ARGS+=(-compile)
        fi
        XRUN_ARGS+=(-f "$RTL_FILE_LIST")
        if [[ "$EN_MEM" == true ]]; then
            XRUN_ARGS+=(-f "$MEM_FILE_LIST")
        fi
        if [[ "$EN_MEM_DIR" == true ]]; then
            XRUN_ARGS+=("+MEM_DIR=$MEM_DIR/")
        fi
        XRUN_ARGS+=(-top "$TOP_MODULE")
        XRUN_ARGS+=(-l xrun.log)
        XRUN_ARGS+=("$TOP_SOURCE")
        if [[ -n "$TEST_NAME" ]]; then
            XRUN_ARGS+=("+UVM_TESTNAME=$TEST_NAME")
        fi
    fi
}

execute_xrun() {
    local status
    local -a xrun_cmd
    xrun_args_parser
    xrun_cmd=("$xrun_bin" "${XRUN_ARGS[@]}")
    cd -- "$OUTPUT_DIR"
    echo "Running on $(hostname)"
    echo
    echo "===== top $TOP_MODULE: $PWD ====="
    echo "Running: ${xrun_cmd[*]}"
    if "${xrun_cmd[@]}" > console.log 2>&1; then
        cat console.log
        if [[ "$RUN_ONLY" == true ]]; then
            echo "PASS: top $TOP_MODULE ran successfully"
        elif [[ "$COMPILE_ONLY" == true ]]; then
            echo "PASS: top $TOP_MODULE compiled successfully"
        else
            echo "PASS: top $TOP_MODULE compiled and ran successfully"
        fi
    else
        status=$?
        cat console.log
        echo "FAIL: top $TOP_MODULE (xrun exit $status). See $PWD/console.log" >&2
        exit "$status"
    fi
}

main() {
    environment_check
    check_top_file
    update_top_src_and_top_modulde
    check_rtl_files
    check_mem_file_list
    check_mem_dir
    create_output_dir
    execute_xrun
}

main
