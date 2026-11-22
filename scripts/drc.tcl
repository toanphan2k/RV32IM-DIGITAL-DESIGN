# ------------------------------------------------------------------------------
# Signoff DRC flow for Cadence Innovus + Cadence Pegasus (GPDK045)
# Usage: innovus -files scripts/drc.tcl
# ------------------------------------------------------------------------------

if {[info commands restoreDesign] eq ""} {
    error "scripts/drc.tcl must be run inside Cadence Innovus: innovus -files scripts/drc.tcl"
}

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJECT_DIR [file normalize [file join $SCRIPT_DIR ..]]
source [file join $SCRIPT_DIR pd_config.tcl]
source [file join $SCRIPT_DIR signoff_utils.tcl]

set TOP datapath
if {[info exists ::env(PD_OUTPUT_DIR)] && $::env(PD_OUTPUT_DIR) ne ""} {
    if {[file pathtype $::env(PD_OUTPUT_DIR)] eq "absolute"} {
        set OUTPUT_ROOT [file normalize $::env(PD_OUTPUT_DIR)]
    } else {
        set OUTPUT_ROOT [file normalize [file join $PROJECT_DIR $::env(PD_OUTPUT_DIR)]]
    }
} else {
    set OUTPUT_ROOT [file join $PROJECT_DIR output]
}
set INNOVUS_OUTPUT_DIR [file join $OUTPUT_ROOT innovus]
set DESIGN_ENC [file join $INNOVUS_OUTPUT_DIR datapath_final.enc]
set SIGNOFF_DIR [file join $OUTPUT_ROOT signoff]
set DRC_DIR [file join $SIGNOFF_DIR drc]
set DRC_RUN_DIR [file join $DRC_DIR run]
set GDS_FILE [file join $SIGNOFF_DIR ${TOP}.gds]

file mkdir $DRC_DIR
file mkdir $DRC_RUN_DIR

# 1. Restore routed Innovus database
pd_restore_innovus_design $DESIGN_ENC $TOP

# 2. Run in-Innovus physical verification checks
puts "=== Running in-Innovus DRC, Antenna, Placement, and Power-Via checks ==="
checkPlace [file join $DRC_DIR check_place.rpt]
verify_drc -limit 1000 -report [file join $DRC_DIR innovus_drc.rpt]
verifyProcessAntenna -report [file join $DRC_DIR antenna.rpt]
verifyPowerVia -report [file join $DRC_DIR power_via.rpt]

# 3. Export merged GDSII for Pegasus foundry signoff DRC
set resolved_gds_map [pd_find_first_file $GDS_MAP_FILE [list \
    "$LIB_DIR/gpdk045_v_6_0/soce/*map*" \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045_tech/*/*map*" \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/techfile/*map*" \
    "$LIB_DIR/gpdk045_v_6_0/gpdk045/gpdk045.layermap" \
]]

set resolved_std_gds [pd_find_existing_files $STD_CELL_GDS [list \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/gds/*.gds" \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/gds/*.gds2" \
]]

puts "=== Exporting signoff GDSII to $GDS_FILE ==="
pd_export_gds $GDS_FILE $TOP $resolved_gds_map $resolved_std_gds $STREAMOUT_UNITS

# 4. Prepare and run Cadence Pegasus signoff DRC
set pegasus_bin [auto_execok pegasus]
set drc_rule_deck [pd_find_first_file $PEGASUS_DRC_RULE_DECK [list \
    "$LIB_DIR/gpdk045_v_6_0/pvs/*DRC*.rul" \
    "$LIB_DIR/gpdk045_v_6_0/pvs/*drc*.rul" \
    "$LIB_DIR/gpdk045_v_6_0/pegasus/*drc*" \
]]

set drc_ctrl_file [file join $DRC_DIR pegasus_drc.ctrl]
set drc_sum [file join $DRC_DIR drc.sum]
set drc_db  [file join $DRC_DIR drc.db]
set fh [open $drc_ctrl_file w]
puts $fh "layout_path \"$GDS_FILE\" gdsii;"
puts $fh "layout_primary \"$TOP\";"
puts $fh "results_db -drc \"$drc_db\" -ascii;"
puts $fh "report_summary -drc \"$drc_sum\" -replace;"
puts $fh "max_results -drc 1000;"
puts $fh "abort_on_layout_error yes;"
close $fh
puts "INFO: Generated Pegasus DRC control file: $drc_ctrl_file"

if {$pegasus_bin eq ""} {
    puts "WARNING: Cadence Pegasus not found. Load it first (e.g. 'module load cadence/pegasus/241') and rerun."
} elseif {$drc_rule_deck eq ""} {
    puts "WARNING: Pegasus DRC rule deck not found. Set PEGASUS_DRC_RULE_DECK in scripts/pd_config.tcl."
} else {
    puts "=== Running Cadence Pegasus DRC ($pegasus_bin) ==="
    set cmd [list $pegasus_bin -drc \
        -top_cell $TOP \
        -gds $GDS_FILE \
        -ascrdb $drc_db \
        -dp $PV_CPUS \
        -control $drc_ctrl_file \
        $drc_rule_deck]
    pd_run_external_cmd $DRC_RUN_DIR $cmd [file join $DRC_DIR pegasus_drc.log]
    if {[file isfile $drc_sum]} {
        puts "INFO: Signoff DRC summary written to: $drc_sum"
    }
}

puts "=== DRC flow finished. Reports in: $DRC_DIR ==="
if {![info exists ::env(INNOVUS_NO_EXIT)]} {
    exit
}
