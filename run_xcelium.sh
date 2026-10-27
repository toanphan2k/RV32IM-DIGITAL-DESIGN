#!/usr/bin/env bash
set -euo pipefail

usage() {
    printf '%s\n' \
        'Usage: bash run_xcelium.sh --top <testbench.sv> [--waves] [--trace]' \
        'Run from any directory on a Linux host with xrun on PATH.' \
        'The simulator top is the testbench filename without .sv.' \
        'Testbench files can be in the current directory or tb/.' \
        'Optional: XRUN_BIN=/path/to/xrun SIM_OUT=/path/to/results'
}

top_file=
waves=0
trace=0
while (($#)); do
    argument=$1
    shift
    case "$argument" in
        --top)
            if (($# == 0)) || [[ -z "$1" ]] || [[ -n "$top_file" ]]; then
                usage >&2
                exit 2
            fi
            top_file=$1
            shift
            ;;
        --waves) waves=1 ;;
        --trace) trace=1 ;;
        -h|--help) usage; exit 0 ;;
        *) usage >&2; exit 2 ;;
    esac
done

if [[ -z "$top_file" || "$top_file" != *.sv ]]; then
    usage >&2
    exit 2
fi

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
if [[ -f "$top_file" ]]; then
    top_source="$(cd -- "$(dirname -- "$top_file")" && pwd)/${top_file##*/}"
elif [[ -f "$project_dir/tb/$top_file" ]]; then
    top_source="$project_dir/tb/$top_file"
elif [[ -f "$project_dir/$top_file" ]]; then
    top_source="$project_dir/$top_file"
else
    printf 'Cannot find testbench source file: %s\n' "$top_file" >&2
    exit 2
fi

top_module=${top_file##*/}
top_module=${top_module%.sv}

xrun_bin=${XRUN_BIN:-xrun}
if ! command -v "$xrun_bin" >/dev/null 2>&1; then
    printf 'Cannot find %s. Load the Cadence environment on the remote host first.\n' "$xrun_bin" >&2
    exit 127
fi
xrun_bin=$(command -v "$xrun_bin")
if [[ "$xrun_bin" != /* ]]; then
    xrun_bin="$PWD/$xrun_bin"
fi

rtl_file_list="$project_dir/rtl_files.f"
if [[ ! -f "$rtl_file_list" ]]; then
    printf 'Cannot find RTL file list: %s\n' "$rtl_file_list" >&2
    exit 2
fi

output_dir=${SIM_OUT:-"$project_dir/sim/xcelium"}
mkdir -p -- "$output_dir/$top_module"
output_dir=$(cd -- "$output_dir/$top_module" && pwd)

options=()
if (( trace )); then
    options+=(+TRACE)
fi
if (( waves )); then
    options+=(-access +rwc -input "$project_dir/tb/xcelium_waves.tcl")
fi

cd -- "$output_dir"
printf '\n===== top %s: %s =====\n' "$top_module" "$PWD"
if "$xrun_bin" -64bit -sv -top "$top_module" -l xrun.log \
    -f "$rtl_file_list" "$top_source" "${options[@]}" > console.log 2>&1; then
    cat console.log
    printf 'PASS: top %s compiled and ran successfully\n' "$top_module"
else
    status=$?
    cat console.log
    printf 'FAIL: top %s (xrun exit %s). See %s/console.log\n' "$top_module" "$status" "$PWD" >&2
    exit "$status"
fi
