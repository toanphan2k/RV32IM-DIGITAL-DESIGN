#!/usr/bin/env bash
set -euo pipefail

# Full signoff flow @ 125 MHz (8.000 ns)
# Runs: Genus -> Innovus PnR -> Innovus + Pegasus DRC -> Innovus + Pegasus LVS
# Outputs are isolated under output/125mhz/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

export PD_SDC_FILE="${PROJECT_DIR}/constraints/top_125mhz.sdc"
export PD_OUTPUT_DIR="${PROJECT_DIR}/output/125mhz"
LOG_DIR="${PD_OUTPUT_DIR}/logs"
mkdir -p "${LOG_DIR}"

if ! type module >/dev/null 2>&1 && [ -f /etc/profile.d/modules.sh ]; then
    # shellcheck disable=SC1091
    source /etc/profile.d/modules.sh
fi
module load cadence/genus/211 cadence/innovus/211 cadence/pegasus/241

echo "================================================================"
echo " RV32IM Full Signoff @ 125 MHz (8.000 ns)"
echo " SDC    : ${PD_SDC_FILE}"
echo " Output : ${PD_OUTPUT_DIR}"
echo "================================================================"

cd "${LOG_DIR}"

echo "=== [1/4] Genus Synthesis (125 MHz) ==="
genus -no_gui -files "${PROJECT_DIR}/scripts/synth.tcl" | tee "${LOG_DIR}/1_genus.log"

echo "=== [2/4] Innovus PnR (125 MHz) ==="
innovus -no_gui -files "${PROJECT_DIR}/scripts/innovus.tcl" | tee "${LOG_DIR}/2_innovus.log"

echo "=== [3/4] Innovus + Pegasus Signoff DRC (125 MHz) ==="
innovus -no_gui -files "${PROJECT_DIR}/scripts/drc.tcl" | tee "${LOG_DIR}/3_drc.log"

echo "=== [4/4] Innovus + Pegasus Signoff LVS (125 MHz) ==="
innovus -no_gui -files "${PROJECT_DIR}/scripts/lvs.tcl" | tee "${LOG_DIR}/4_lvs.log"

echo ""
echo "==================== SIGNOFF SUMMARY (125 MHz) ===================="
echo "--- Genus QoR ---"
grep -E "^(clk|cg_enable_group_clk|Cell Area|Total Area)" "${PD_OUTPUT_DIR}/genus/qor.rpt" || true
echo "--- Innovus Post-Route Setup & DRVs ---"
zcat "${PD_OUTPUT_DIR}/innovus/postRoute/datapath_postRoute.summary.gz" || true
echo "--- Innovus Post-Route Hold ---"
zcat "${PD_OUTPUT_DIR}/innovus/postRoute/datapath_postRoute_hold.summary.gz" || true
echo "--- Innovus DRC ---"
tail -n 5 "${PD_OUTPUT_DIR}/innovus/drc.rpt" || true
echo "--- Pegasus Foundry DRC ---"
grep -E "Total DRC Results" "${PD_OUTPUT_DIR}/signoff/drc/drc.sum" || true
echo "--- Pegasus Foundry LVS ---"
grep -E "Run Result|ERC Results|Cells matched|Cells which mismatch" "${PD_OUTPUT_DIR}/signoff/lvs/lvs.rep.cls" || true
echo "==================================================================="
