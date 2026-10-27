#!/usr/bin/env bash
set -euo pipefail

#DEFAULTS
TOP_FILE=""
PROJECT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
TOP_SOURCE=""
TOP_MODULE=""
usage() {
    cat <<EOF
Usage:
  run_xcelium.sh --top <testbench.sv>
  run_xcelium.sh --top <tb/testbench.sv>

Options:
  -h, --help      Show this help message
      --top FILE  Compile and run FILE; its filename without .sv is the top module

Examples:
  run_xcelium.sh --top tb_riscv_programs.sv
  run_xcelium.sh --top tb_alu.sv

Testbench files can be in the current directory, the workspace root, or tb/.
The RTL paths in rtl_files.f are relative to sim/xcelium/<top>.
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
        -h|--help) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
    esac
done

environment_check() {
    if ! xrun_bin=$(which xrun 2>/dev/null); then
        printf 'Cannot find xrun. Load the Cadence environment on the remote host first.\n' >&2
        exit 127
    fi
}

check_top_file() {
    if [[ -z "$TOP_FILE" || "$TOP_FILE" != *.sv ]]; then
        usage >&2
        exit 2
    fi

    if [[ ! -f "$TOP_FILE" ]]; then
        printf 'Cannot find top file: %s\n' "$TOP_FILE" >&2
        exit 2
    fi
}

update_top_src_and_top_modulde() {
    TOP_SOURCE=$(realpath -- "$TOP_FILE")
    TOP_MODULE=${TOP_FILE##*/}
    TOP_MODULE=${TOP_MODULE%.sv}
}

check_rtl_files() {
    RTL_FILE_LIST="$PROJECT_DIR/rtl_files.f"
    if [[ ! -f "$RTL_FILE_LIST" ]]; then
        printf 'Cannot find RTL file list: %s\n' "$RTL_FILE_LIST" >&2
        exit 2
    fi
}

create_output_dir() {
    local output_root="$PROJECT_DIR/sim/xcelium"
    mkdir -p -- "$output_root/$TOP_MODULE"
    OUTPUT_DIR=$(cd -- "$output_root/$TOP_MODULE" && pwd)
}

run_behavioral_sim() {
    local status
    cd -- "$OUTPUT_DIR"
    printf '\n===== top %s: %s =====\n' "$TOP_MODULE" "$PWD"
    if "$xrun_bin" -64bit -sv -top "$TOP_MODULE" -l xrun.log \
        -f "$RTL_FILE_LIST" "$TOP_SOURCE" > console.log 2>&1; then
        cat console.log
        printf 'PASS: top %s compiled and ran successfully\n' "$TOP_MODULE"
    else
        status=$?
        cat console.log
        printf 'FAIL: top %s (xrun exit %s). See %s/console.log\n' "$TOP_MODULE" "$status" "$PWD" >&2
        exit "$status"
    fi
}

main() {
    environment_check
    check_top_file
    update_top_src_and_top_modulde
    check_rtl_files
    create_output_dir
    run_behavioral_sim
}

main
