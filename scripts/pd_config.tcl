
set LIB_DIR "/tools/eda/pdks/cadence/gpdk045"

# --------------------------------------------------
# Standard Cell Library - GPDK045 SVT
# --------------------------------------------------

set STD_CELL_LIBS [list \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/timing/slow_vdd1v0_basicCells.lib" \
]

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

# Provisional layer selection - verify preferred directions
set RING_HORIZONTAL_LAYER "Metal6"
set RING_VERTICAL_LAYER "Metal7"

set STRIPE_LAYER "Metal6"

set RING_WIDTH 2.0
set RING_SPACING 1.0
set RING_OFFSET 1.0

set STRIPE_WIDTH 2.0
set STRIPE_SPACING 1.0
set STRIPE_PITCH 40.0
set STRIPE_OFFSET 10.0

