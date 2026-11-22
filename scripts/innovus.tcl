if {[info commands init_design] eq ""} {
    error "scripts/innovus.tcl must be run inside Cadence Innovus: innovus -files scripts/innovus.tcl"
}

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJECT_DIR [file normalize [file join $SCRIPT_DIR ..]]
source [file join $SCRIPT_DIR pd_config.tcl]

set TOP datapath
set NETLIST [file join $PROJECT_DIR output genus datapath_mapped.v]
set INNOVUS_OUTPUT_DIR [file join $PROJECT_DIR output innovus]
set LEF_FILES [concat [list $TECH_LEF] $CELL_LEFS]

foreach required_var {STD_CELL_LIBS_SLOW STD_CELL_LIBS_FAST TECH_LEF CELL_LEFS QRC_TECH_FILE CORE_SITE RING_HORIZONTAL_LAYER RING_VERTICAL_LAYER STRIPE_LAYER PROCESS_NODE} {
    if {![info exists $required_var] || [set $required_var] eq ""} {
        error "Set $required_var in scripts/pd_config.tcl"
    }
}
foreach physical_file [concat $STD_CELL_LIBS_SLOW $STD_CELL_LIBS_FAST [list $TECH_LEF $QRC_TECH_FILE] $CELL_LEFS] {
    if {![file isfile $physical_file]} {
        error "PDK input file not found: $physical_file"
    }
}
if {![file isfile $NETLIST]} {
    error "Run scripts/synth.tcl first; netlist not found: $NETLIST"
}

proc pd_filter_lib_cells {candidates} {
    set valid [list]
    foreach cell $candidates {
        if {[llength [dbGet -p head.libCells.name $cell]] > 0} {
            lappend valid $cell
        }
    }
    return $valid
}

# 1. Design initialization
file mkdir $INNOVUS_OUTPUT_DIR
cd $INNOVUS_OUTPUT_DIR
set init_lef_file $LEF_FILES
set init_verilog $NETLIST
set init_top_cell $TOP
set init_pwr_net $POWER_NET
set init_gnd_net $GROUND_NET
set init_mmmc_file [file join $SCRIPT_DIR mmmc.tcl]
init_design

setDesignMode -process $PROCESS_NODE
if {[info exists TOP_SIGNAL_ROUTING_LAYER] && $TOP_SIGNAL_ROUTING_LAYER ne ""} {
    setDesignMode -topRoutingLayer $TOP_SIGNAL_ROUTING_LAYER
}
if {[info exists PV_CPUS] && $PV_CPUS > 1} {
    setMultiCpuUsage -localCpu $PV_CPUS
}
foreach cell_pattern $DONT_USE_CELLS {
    set matching_cells [get_lib_cells -quiet */$cell_pattern]
    if {[sizeof_collection $matching_cells] > 0} {
        set_dont_use $matching_cells true
    }
}

setAnalysisMode -analysisType onChipVariation -cppr both
setPlaceMode -place_global_ignore_scan true

# Create standard timing path groups (reg2reg, reg2cgate, in2reg, reg2out) cleanly
createBasicPathGroups -expanded

# Configure setup/hold slack & DRV guardbands so post-filler extraction stays violation-free
if {![info exists SETUP_TARGET_SLACK]} { set SETUP_TARGET_SLACK 0.050 }
if {![info exists HOLD_TARGET_SLACK]}  { set HOLD_TARGET_SLACK  0.030 }
if {![info exists DRC_MARGIN]}         { set DRC_MARGIN         0.15  }
setOptMode -fixDrc true -fixFanoutLoad true \
    -setupTargetSlack $SETUP_TARGET_SLACK \
    -holdTargetSlack  $HOLD_TARGET_SLACK \
    -drcMargin        $DRC_MARGIN
set valid_hold_cells [pd_filter_lib_cells [list DLY1X1 DLY2X1 DLY3X1 DLY4X1 BUFX3 BUFX4 BUFX6 BUFX8]]
if {[llength $valid_hold_cells] > 0} {
    setOptMode -holdFixingCells $valid_hold_cells
}

# 2. Floorplanning & IO pin assignment
floorPlan -site $CORE_SITE -r $CORE_ASPECT_RATIO $CORE_UTILIZATION \
    $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN $CORE_MARGIN

# Place block pins on preferred-direction edges: Metal3 (H) on LEFT/RIGHT, Metal4 (V) on BOTTOM
set left_pins   [get_object_name [get_ports {clk rst_n c_pc_f* f_inst*}]]
set right_pins  [get_object_name [get_ports {store_addr_dmem* store_we_dmem* d_store_dmem_m* d_load_dmem*}]]
set bottom_pins [get_object_name [get_ports {trace_pc* trace_inst*}]]

setPinAssignMode -pinEditInBatch true
editPin -pin $left_pins   -side LEFT   -layer Metal3 -spreadType SIDE -fixOverlap 1 -fixedPin 1
editPin -pin $right_pins  -side RIGHT  -layer Metal3 -spreadType SIDE -fixOverlap 1 -fixedPin 1
editPin -pin $bottom_pins -side BOTTOM -layer Metal4 -spreadType SIDE -fixOverlap 1 -fixedPin 1
setPinAssignMode -pinEditInBatch false

# 3. Power planning (rings, vertical stripes, standard-cell rails)
clearGlobalNets
globalNetConnect $POWER_NET  -type pgpin -pin $POWER_PIN  -inst * -override
globalNetConnect $GROUND_NET -type pgpin -pin $GROUND_PIN -inst * -override
globalNetConnect $POWER_NET  -type tiehi -inst * -override
globalNetConnect $GROUND_NET -type tielo -inst * -override
globalNetConnect $POWER_NET  -type net   -net $POWER_NET  -override
globalNetConnect $GROUND_NET -type net   -net $GROUND_NET -override

addRing -nets [list $POWER_NET $GROUND_NET] -type core_rings -follow core \
    -layer [list top $RING_HORIZONTAL_LAYER bottom $RING_HORIZONTAL_LAYER left $RING_VERTICAL_LAYER right $RING_VERTICAL_LAYER] \
    -width $RING_WIDTH -spacing $RING_SPACING -offset $RING_OFFSET

addStripe -nets [list $POWER_NET $GROUND_NET] -layer $STRIPE_LAYER -direction vertical \
    -width $STRIPE_WIDTH -spacing $STRIPE_SPACING -set_to_set_distance $STRIPE_PITCH \
    -start_from left -start_offset $STRIPE_OFFSET

sroute -connect {corePin floatingStripe} \
    -layerChangeRange [list Metal1 $RING_HORIZONTAL_LAYER] \
    -nets [list $POWER_NET $GROUND_NET] \
    -allowJogging 1 -allowLayerChange 1

# Create top-level physical PG pins on the Metal7 core ring so GDSII exports
# VDD/VSS port labels on layer (38, 3) for Pegasus/PVS LVS matching.
foreach pg_net [list $POWER_NET $GROUND_NET] {
    set pg_net_ptr [dbGet -p1 top.nets.name $pg_net -e]
    set box ""
    if {$pg_net_ptr ne "" && $pg_net_ptr ne "0x0"} {
        foreach sw [dbGet -e ${pg_net_ptr}.sWires] {
            if {[dbGet ${sw}.layer.name] eq $RING_HORIZONTAL_LAYER} {
                set box [dbGet ${sw}.box]
                break
            }
        }
    }
    if {$box ne "" && [llength [lindex $box 0]] == 4} {
        lassign [lindex $box 0] x1 y1 x2 y2
        set cx [expr {($x1 + $x2) / 2.0}]
        set half_w [expr {min(1.0, ($x2 - $x1) / 4.0)}]
        createPGPin $pg_net -net $pg_net -geom $RING_HORIZONTAL_LAYER \
            [expr {$cx - $half_w}] $y1 [expr {$cx + $half_w}] $y2
    }
}

verifyPowerVia -report [file join $INNOVUS_OUTPUT_DIR power_via.rpt]

# 4. Placement, tie-cell insertion, and pre-CTS optimization
placeDesign
set valid_tie_cells [pd_filter_lib_cells $TIE_CELLS]
if {[llength $valid_tie_cells] > 0} {
    setTieHiLoMode -cell $valid_tie_cells -maxFanout 10 -maxDistance 100
    addTieHiLo -cell $valid_tie_cells -prefix TIE
}
optDesign -preCTS

# 5. Clock tree synthesis and post-CTS setup/hold optimization
set valid_cts_bufs [pd_filter_lib_cells $CTS_BUF_CELLS]
set valid_cts_invs [pd_filter_lib_cells $CTS_INV_CELLS]
if {[llength $valid_cts_bufs] > 0} {
    set_ccopt_property buffer_cells $valid_cts_bufs
}
if {[llength $valid_cts_invs] > 0} {
    set_ccopt_property inverter_cells $valid_cts_invs
}
ccopt_design
report_ccopt_clock_trees -file [file join $INNOVUS_OUTPUT_DIR cts_trees.rpt]
report_ccopt_skew_groups -file [file join $INNOVUS_OUTPUT_DIR cts_skew.rpt]
optDesign -postCTS
optDesign -postCTS -hold

# 6. Timing/SI-driven routing with antenna fixing and multi-cut vias
setNanoRouteMode -routeWithTimingDriven true
setNanoRouteMode -routeWithSiDriven true
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeReserveSpaceForMultiCut true
setNanoRouteMode -drouteUseMultiCutViaEffort high
setNanoRouteMode -droutePostRouteSwapVia multiCut
if {[info exists TOP_SIGNAL_ROUTING_LAYER] && $TOP_SIGNAL_ROUTING_LAYER ne ""} {
    setNanoRouteMode -routeTopRoutingLayer $TOP_SIGNAL_ROUTING_LAYER
}
set valid_antenna_cells [pd_filter_lib_cells [list $ANTENNA_CELL]]
if {[llength $valid_antenna_cells] > 0} {
    setNanoRouteMode -routeInsertAntennaDiode true
    setNanoRouteMode -routeAntennaCellName [lindex $valid_antenna_cells 0]
}
routeDesign -globalDetail

# 7. Post-route SI-aware extraction and setup/hold timing closure
setExtractRCMode -engine postRoute -effortLevel medium
setDelayCalMode -SIAware true
extractRC
optDesign -postRoute
optDesign -postRoute -hold
optDesign -postRoute -drv

# 8. DRC-aware filler insertion + post-filler ECO route cleanup + final extraction
set valid_fillers [pd_filter_lib_cells [concat $DECAP_CELLS $FILLER_CELLS]]
if {[llength $valid_fillers] > 0} {
    setFillerMode -core $valid_fillers -corePrefix FILLER -fitGap true -ecoMode true
    addFiller
    ecoRoute -target
}

verify_drc -limit 1000 -report [file join $INNOVUS_OUTPUT_DIR drc.rpt]
set drc_markers [llength [dbGet -e top.markers]]
if {$drc_markers > 0} {
    puts "INFO: $drc_markers DRC marker(s) detected after filler insertion; running ecoRoute -fix_drc ..."
    ecoRoute -fix_drc
    verify_drc -limit 1000 -report [file join $INNOVUS_OUTPUT_DIR drc.rpt]
}

extractRC

# 9. Post-route signoff timing, physical verification, and deliverables
set POST_ROUTE_REPORT_DIR [file join $INNOVUS_OUTPUT_DIR postRoute]
file mkdir $POST_ROUTE_REPORT_DIR
timeDesign -postRoute -outDir $POST_ROUTE_REPORT_DIR
timeDesign -postRoute -hold -outDir $POST_ROUTE_REPORT_DIR

checkPlace [file join $INNOVUS_OUTPUT_DIR check_place.rpt]
verify_connectivity -type all -report [file join $INNOVUS_OUTPUT_DIR connectivity.rpt]
verifyProcessAntenna -report [file join $INNOVUS_OUTPUT_DIR antenna.rpt]

report_area > [file join $INNOVUS_OUTPUT_DIR area.rpt]
report_power > [file join $INNOVUS_OUTPUT_DIR power.rpt]
report_timing -late > [file join $INNOVUS_OUTPUT_DIR timing_setup.rpt]
report_timing -early > [file join $INNOVUS_OUTPUT_DIR timing_hold.rpt]

rcOut -spef [file join $INNOVUS_OUTPUT_DIR ${TOP}_slow.spef] -rc_corner rc_slow
rcOut -spef [file join $INNOVUS_OUTPUT_DIR ${TOP}_fast.spef] -rc_corner rc_fast
write_sdf -view func_slow_view [file join $INNOVUS_OUTPUT_DIR ${TOP}.sdf]
defOut -floorplan -netlist -routing [file join $INNOVUS_OUTPUT_DIR ${TOP}.def]
saveNetlist [file join $INNOVUS_OUTPUT_DIR ${TOP}_pnr.v]
saveDesign [file join $INNOVUS_OUTPUT_DIR ${TOP}_final.enc]

exit
