set LIB_DIR "/tools/eda/pdks/cadence/gpdk045"
set PROCESS_NODE 45

# --------------------------------------------------
# Standard Cell Library - GPDK045 SVT (Setup & Hold)
# --------------------------------------------------

set STD_CELL_LIBS_SLOW [list \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/timing/slow_vdd1v0_basicCells.lib" \
]

set STD_CELL_LIBS_FAST [list \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/timing/fast_vdd1v0_basicCells.lib" \
]

# Alias used by synthesis (worst-case setup library)
set STD_CELL_LIBS $STD_CELL_LIBS_SLOW

# Excluded library cells:
# - BUFX2: uses incompatible CoreSiteDouble site in gsclib045 LEF
# - SDFF* / SEDFF*: scan flip-flops; no scan chain/DFT is inserted, so allowing them
#   triggers Innovus ERROR IMPSP-9099 and slow /SE setup paths (235 ps setup time)
# - CLKBUFX2 / NAND4*XL / NOR4*XL: ultra-weak 4-series-transistor XL drivers into
#   tight 0.280 ns clock-buffer pins caused post-route max_tran DRV violations
set DONT_USE_CELLS [list \
    BUFX2 \
    CLKBUFX2 \
    SDFF* \
    SEDFF* \
    NAND4XL NAND4BXL NAND4BBXL \
    NOR4XL NOR4BXL NOR4BBXL \
]
set ENABLE_CLOCK_GATING 1

# Physical & CTS helper cell lists (filtered against loaded LEF/lib in Innovus)
set TIE_CELLS [list TIEHI TIELO]

# NOTE: gsclib045_svt_v4.7 DECAP3..DECAP10 macros have internal Metal1 Pin-to-Pin
# EndOfLine spacing geometry that violates gsclib045_tech.lef (causing 274 DRC
# violations in verify_drc). Keep DECAP_CELLS empty by default and fill 100% of
# core gaps cleanly with FILL64..FILL1 (0 Metal1 signal pins, 0 DRC violations).
# See scripts/MANUAL_GUIDE.md if decoupling capacitors are explicitly required.
set DECAP_CELLS [list]
set FILLER_CELLS [list FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1]
set ANTENNA_CELL "ANTENNA"
set CTS_BUF_CELLS [list CLKBUFX3 CLKBUFX4 CLKBUFX6 CLKBUFX8 CLKBUFX12 CLKBUFX16 CLKBUFX20]
set CTS_INV_CELLS [list CLKINVX1 CLKINVX2 CLKINVX3 CLKINVX4 CLKINVX6 CLKINVX8 CLKINVX12 CLKINVX16 CLKINVX20]

# Optimization guardbands (ns / ratio) to prevent 0.000 ns rounding/filler hold/DRV slips
set SETUP_TARGET_SLACK 0.050
set HOLD_TARGET_SLACK  0.030
set DRC_MARGIN         0.15

# --------------------------------------------------
# Physical Technology
# --------------------------------------------------

set TECH_LEF "$LIB_DIR/gsclib045_svt_v4.7/gsclib045_tech/lef/gsclib045_tech.lef"

set CELL_LEFS [list \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/lef/gsclib045_macro.lef" \
]

set QRC_TECH_FILE \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/qrc/qx/gpdk045.tch"

# --------------------------------------------------
# Floorplanning
# --------------------------------------------------

set CORE_SITE "CoreSite"
set CORE_UTILIZATION 0.65
set CORE_ASPECT_RATIO 1.0
set CORE_MARGIN 10.0

# --------------------------------------------------
# Power Planning
# --------------------------------------------------

set POWER_NET "VDD"
set POWER_PIN "VDD"
set GROUND_NET "VSS"
set GROUND_PIN "VSS"

# Verified GPDK045 preferred routing directions:
# odd metals (Metal1,3,5,7,9,11) = Horizontal; even metals (Metal2,4,6,8,10) = Vertical
set RING_HORIZONTAL_LAYER "Metal7"
set RING_VERTICAL_LAYER "Metal6"

set STRIPE_LAYER "Metal6"

set RING_WIDTH 2.0
set RING_SPACING 1.0
set RING_OFFSET 1.0

set STRIPE_WIDTH 2.0
set STRIPE_SPACING 1.0
set STRIPE_PITCH 40.0
set STRIPE_OFFSET 10.0

# --------------------------------------------------
# Signoff Physical Verification (DRC / LVS)
# --------------------------------------------------

# PV_TOOL: "auto" (prefers pegasus -> pvs -> calibre -> innovus_only),
#          "pegasus", "pvs", "calibre", or "innovus_only"
set PV_TOOL "auto"
set PV_CPUS 2

# Additional EDA install directories searched when PV tools are not in $PATH
# (signoff_utils.tcl also filters out Linux OS /usr/sbin/pvs LVM2 utility)
set PV_SEARCH_DIRS [list \
    "/tools/eda/cadence" \
    "/tools/eda/mentor" \
    "/tools/eda/siemens" \
    "/tools/eda" \
]

set STREAMOUT_UNITS 2000

# Optional Innovus streamOut GDS layer map (leave empty for auto-discovery /
# automatic conversion of Virtuoso gpdk045.layermap into Innovus NET/SPNET/VIA format)
set GDS_MAP_FILE ""

# Standard-cell physical/schematic collateral for GDS merge and LVS
set STD_CELL_GDS [list \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/gds/gsclib045.gds" \
]

set STD_CELL_CDL [list \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/cdl/gsclib045.cdl" \
]

# Optional Verilog cell definitions (used by v2lvs when PV_TOOL is calibre)
set STD_CELL_VERILOG [list \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/verilog/slow_vdd1v0_basicCells.v" \
]

# Physical-only filler cells without active devices (excluded from LVS netlist)
set LVS_EXCLUDE_CELLS [list \
    FILL1 FILL2 FILL4 FILL8 FILL16 FILL32 FILL64 \
]

# PDK signoff rule decks (scripts also auto-search $LIB_DIR/gpdk045_v_6_0 if missing)
set PVS_DRC_RULE_DECK "$LIB_DIR/gpdk045_v_6_0/pvs/pvlDRC.rul"
set PVS_LVS_RULE_DECK "$LIB_DIR/gpdk045_v_6_0/pvs/pvlLVS.rul"
set CALIBRE_DRC_RULE_DECK ""
set CALIBRE_LVS_RULE_DECK ""
