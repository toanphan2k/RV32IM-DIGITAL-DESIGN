# ------------------------------------------------------------------------------
# Signoff DRC flow for Cadence Innovus + Pegasus / PVS / Calibre (GPDK045)
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
set INNOVUS_OUTPUT_DIR [file join $PROJECT_DIR output innovus]
set DESIGN_ENC [file join $INNOVUS_OUTPUT_DIR datapath_final.enc]
set SIGNOFF_DIR [file join $PROJECT_DIR output signoff]
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

# 3. Export merged GDSII for foundry/PDK signoff DRC
# Prefer Innovus/SOCE streamOut map first; if only Virtuoso .layermap is found,
# pd_export_gds converts it automatically so NET/SPNET/VIA shapes are preserved.
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

# 4. Prepare and run external signoff DRC (Pegasus / PVS / Calibre)
if {![info exists PV_SEARCH_DIRS]} { set PV_SEARCH_DIRS [list "/tools/eda/cadence" "/tools/eda"] }
lassign [pd_detect_pv_tool $PV_TOOL $PV_SEARCH_DIRS] pv_engine pv_bin
puts "=== Signoff DRC engine selected: $pv_engine ($pv_bin) ==="

set drc_rule_deck [pd_find_first_file $PVS_DRC_RULE_DECK [list \
    "$LIB_DIR/gpdk045_v_6_0/pvs/*DRC*.rul" \
    "$LIB_DIR/gpdk045_v_6_0/pvs/*drc*.rul" \
    "$LIB_DIR/gpdk045_v_6_0/pvs/*drc*.pvl" \
    "$LIB_DIR/gpdk045_v_6_0/pegasus/*drc*" \
]]

# Always write a clean PVS/Pegasus PVL control file so manual runs can reuse it directly
set pvs_ctrl_file [file join $DRC_DIR pvs_drc.ctrl]
set drc_sum [file join $DRC_DIR drc.sum]
set drc_db  [file join $DRC_DIR drc.db]
set fh [open $pvs_ctrl_file w]
puts $fh "layout_path \"$GDS_FILE\" gdsii;"
puts $fh "layout_primary \"$TOP\";"
puts $fh "results_db -drc \"$drc_db\" -ascii;"
puts $fh "report_summary -drc \"$drc_sum\" -replace;"
puts $fh "max_results -drc 1000;"
puts $fh "abort_on_layout_error yes;"
close $fh
puts "INFO: Generated PVS/Pegasus DRC control file: $pvs_ctrl_file"

if {$pv_engine eq "pegasus" || $pv_engine eq "pvs"} {
    if {$drc_rule_deck eq ""} {
        puts "WARNING: PVS/Pegasus DRC rule deck not found."
        puts "         Find it on the lab server with: find $LIB_DIR -iname '*drc*'"
        puts "         Then set PVS_DRC_RULE_DECK in scripts/pd_config.tcl and rerun."
    } else {
        set cmd [list $pv_bin -drc -top_cell $TOP -gds $GDS_FILE -ascrdb $drc_db -dp $PV_CPUS -control $pvs_ctrl_file $drc_rule_deck]
        pd_run_external_cmd $DRC_RUN_DIR $cmd [file join $DRC_DIR ${pv_engine}_drc.log]
        if {[file isfile $drc_sum]} {
            puts "INFO: Signoff DRC summary written to: $drc_sum"
        }
    }
} elseif {$pv_engine eq "calibre"} {
    set cal_rule_deck [pd_find_first_file $CALIBRE_DRC_RULE_DECK [list \
        "$LIB_DIR/gpdk045_v_6_0/calibre/*drc*" \
        "$LIB_DIR/gpdk045_v_6_0/calibre/*DRC*" \
    ]]

    set runset_file [file join $DRC_DIR calibre_drc.runset]
    set cal_sum [file join $DRC_DIR drc.summary]
    set cal_db  [file join $DRC_DIR drc.results]
    set fh [open $runset_file w]
    puts $fh "LAYOUT PATH \"$GDS_FILE\""
    puts $fh "LAYOUT PRIMARY \"$TOP\""
    puts $fh "LAYOUT SYSTEM GDSII"
    puts $fh "DRC RESULTS DATABASE \"$cal_db\" ASCII"
    puts $fh "DRC SUMMARY REPORT \"$cal_sum\" REPLACE"
    puts $fh "DRC MAXIMUM RESULTS 1000"
    if {$cal_rule_deck ne ""} {
        puts $fh "INCLUDE \"$cal_rule_deck\""
    }
    close $fh
    puts "INFO: Generated Calibre DRC runset: $runset_file"

    if {$cal_rule_deck eq ""} {
        puts "WARNING: Calibre DRC rule deck not found. Set CALIBRE_DRC_RULE_DECK in scripts/pd_config.tcl."
    } else {
        set cmd [list $pv_bin -drc -hier -turbo $PV_CPUS $runset_file]
        pd_run_external_cmd $DRC_RUN_DIR $cmd [file join $DRC_DIR calibre_drc.log]
    }
} else {
    puts "INFO: No external EDA PV binary (pegasus/pvs/calibre) found (OS /usr/sbin/pvs LVM2 ignored)."
    puts "      In-Innovus DRC reports, merged GDSII ($GDS_FILE), and PVS control file ($pvs_ctrl_file) are ready."
    puts "      See scripts/MANUAL_GUIDE.md for running Cadence PVS/Pegasus DRC on the lab server."
}

puts "=== DRC flow finished. Reports in: $DRC_DIR ==="
if {![info exists ::env(INNOVUS_NO_EXIT)]} {
    exit
}
