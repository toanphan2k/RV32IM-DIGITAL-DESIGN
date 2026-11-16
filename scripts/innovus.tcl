set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJECT_DIR [file normalize [file join $SCRIPT_DIR ..]]
source [file join $SCRIPT_DIR pd_config.tcl]

set TOP datapath
set NETLIST [file join $SCRIPT_DIR output genus datapath_mapped.v]
set OUTPUT_DIR [file join $SCRIPT_DIR output innovus]
set LEF_FILES [concat [list $TECH_LEF] $CELL_LEFS]

foreach required_var {STD_CELL_LIBS TECH_LEF CELL_LEFS QRC_TECH_FILE CORE_SITE RING_HORIZONTAL_LAYER RING_VERTICAL_LAYER STRIPE_LAYER} {
    if {![info exists $required_var] || [set $required_var] eq ""} {
        error "Set $required_var in scripts/pd_config.tcl"
    }
}
foreach physical_file [concat $STD_CELL_LIBS [list $TECH_LEF $QRC_TECH_FILE] $CELL_LEFS] {
    if {![file isfile $physical_file]} {
        error "PDK input file not found: $physical_file"
    }
}
if {![file isfile $NETLIST]} {
    error "Run scripts/synth.tcl first; netlist not found: $NETLIST"
}

file mkdir $OUTPUT_DIR
set init_lef_file $LEF_FILES
set init_verilog $NETLIST
set init_top_cell $TOP
set init_mmmc_file [file join $SCRIPT_DIR mmmc.tcl]
init_design

floorPlan -site $CORE_SITE -r $CORE_ASPECT_RATIO $CORE_UTILIZATION $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN

globalNetConnect $POWER_NET -type pgpin -pin $POWER_PIN -inst * -override
globalNetConnect $GROUND_NET -type pgpin -pin $GROUND_PIN -inst * -override
addRing -nets [list $POWER_NET $GROUND_NET] -type core_rings -follow core \
    -layer [list top $RING_HORIZONTAL_LAYER bottom $RING_HORIZONTAL_LAYER left $RING_VERTICAL_LAYER right $RING_VERTICAL_LAYER] \
    -width $RING_WIDTH -spacing $RING_SPACING -offset $RING_OFFSET
addStripe -nets [list $POWER_NET $GROUND_NET] -layer $STRIPE_LAYER -direction vertical \
    -width $STRIPE_WIDTH -spacing $STRIPE_SPACING -set_to_set_distance $STRIPE_PITCH \
    -start_from left -start_offset $STRIPE_OFFSET
sroute -connect {corePin} -nets [list $POWER_NET $GROUND_NET] -allowJogging 1 -allowLayerChange 1

placeDesign
optDesign -preCTS
ccopt_design
optDesign -postCTS
routeDesign -global
routeDesign -detail
optDesign -postRoute

report_area > [file join $OUTPUT_DIR area.rpt]
report_timing > [file join $OUTPUT_DIR timing.rpt]
saveNetlist [file join $OUTPUT_DIR datapath_pnr.v]
saveDesign [file join $OUTPUT_DIR datapath_final.enc]

exit