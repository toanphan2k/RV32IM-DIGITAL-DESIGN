# ------------------------------------------------------------------------------
# Signoff LVS flow for Cadence Innovus + Pegasus / PVS / Calibre (GPDK045)
# Usage: innovus -files scripts/lvs.tcl
# ------------------------------------------------------------------------------

if {[info commands restoreDesign] eq ""} {
    error "scripts/lvs.tcl must be run inside Cadence Innovus: innovus -files scripts/lvs.tcl"
}

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJECT_DIR [file normalize [file join $SCRIPT_DIR ..]]
source [file join $SCRIPT_DIR pd_config.tcl]
source [file join $SCRIPT_DIR signoff_utils.tcl]

set TOP datapath
set INNOVUS_OUTPUT_DIR [file join $PROJECT_DIR output innovus]
set DESIGN_ENC [file join $INNOVUS_OUTPUT_DIR datapath_final.enc]
set SIGNOFF_DIR [file join $PROJECT_DIR output signoff]
set LVS_DIR [file join $SIGNOFF_DIR lvs]
set LVS_RUN_DIR [file join $LVS_DIR run]
set GDS_FILE [file join $SIGNOFF_DIR ${TOP}.gds]
set LVS_VERILOG [file join $SIGNOFF_DIR ${TOP}_lvs.v]
set LVS_CDL [file join $SIGNOFF_DIR ${TOP}_lvs.cdl]

file mkdir $LVS_DIR
file mkdir $LVS_RUN_DIR

# 1. Restore routed Innovus database
pd_restore_innovus_design $DESIGN_ENC $TOP

# 2. Run in-Innovus connectivity & power/ground integrity checks
puts "=== Running in-Innovus connectivity check ==="
verify_connectivity -type all -error 1000 -warning 50 \
    -report [file join $LVS_DIR innovus_connectivity.rpt]

# 3. Export merged GDSII, LVS PG Verilog netlist, and unified SPICE/CDL netlist
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

set resolved_std_cdl [pd_find_existing_files $STD_CELL_CDL [list \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/cdl/*.cdl" \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/cdl/*.spi" \
]]

set resolved_std_verilog [pd_find_existing_files $STD_CELL_VERILOG [list \
    "$LIB_DIR/gsclib045_svt_v4.7/gsclib045/verilog/*.v" \
]]

puts "=== Exporting signoff GDSII ($GDS_FILE), LVS PG Verilog ($LVS_VERILOG), and CDL ($LVS_CDL) ==="
pd_export_gds $GDS_FILE $TOP $resolved_gds_map $resolved_std_gds $STREAMOUT_UNITS
pd_export_lvs_netlist $LVS_VERILOG $LVS_EXCLUDE_CELLS

if {[llength $resolved_std_cdl] > 0} {
    pd_verilog_to_cdl $LVS_VERILOG $resolved_std_cdl $LVS_CDL $TOP $POWER_NET $GROUND_NET
}

# 4. Prepare and run external signoff LVS (Pegasus / PVS / Calibre)
if {![info exists PV_SEARCH_DIRS]} { set PV_SEARCH_DIRS [list "/tools/eda/cadence" "/tools/eda"] }
lassign [pd_detect_pv_tool $PV_TOOL $PV_SEARCH_DIRS] pv_engine pv_bin
puts "=== Signoff LVS engine selected: $pv_engine ($pv_bin) ==="

set lvs_rule_deck [pd_find_first_file $PVS_LVS_RULE_DECK [list \
    "$LIB_DIR/gpdk045_v_6_0/pvs/*LVS*.rul" \
    "$LIB_DIR/gpdk045_v_6_0/pvs/*lvs*.rul" \
    "$LIB_DIR/gpdk045_v_6_0/pvs/*lvs*.pvl" \
    "$LIB_DIR/gpdk045_v_6_0/pegasus/*lvs*" \
]]

# Always write a ready-to-run PVS/Pegasus LVS PVL control file using unified CDL
set pvs_ctrl_file [file join $LVS_DIR pvs_lvs.ctrl]
set lvs_rep  [file join $LVS_DIR lvs.rep]
set erc_sum  [file join $LVS_DIR erc.sum]
set erc_db   [file join $LVS_DIR erc.db]
set svdb_dir [file join $LVS_DIR svdb]

set fh [open $pvs_ctrl_file w]
puts $fh "layout_format gdsii;"
puts $fh "layout_path \"$GDS_FILE\";"
puts $fh "layout_primary \"$TOP\";"
if {[file isfile $LVS_CDL]} {
    puts $fh "schematic_format cdl;"
    puts $fh "schematic_path \"$LVS_CDL\";"
} else {
    puts $fh "schematic_format verilog;"
    puts $fh "schematic_path \"$LVS_VERILOG\";"
}
puts $fh "schematic_primary \"$TOP\";"
puts $fh "lvs_report \"$lvs_rep\";"
puts $fh "report_summary -erc \"$erc_sum\" -replace;"
puts $fh "results_db -erc \"$erc_db\" -ascii;"
puts $fh "mask_svdb_dir \"$svdb_dir\";"
puts $fh "lvs_power_name \"$POWER_NET\";"
puts $fh "lvs_ground_name \"$GROUND_NET\";"
puts $fh "lvs_ignore_ports no;"
puts $fh "abort_on_layout_error yes;"
close $fh
puts "INFO: Generated PVS/Pegasus LVS control file: $pvs_ctrl_file"

if {$pv_engine eq "pegasus" || $pv_engine eq "pvs"} {
    if {$lvs_rule_deck eq "" || ![file isfile $LVS_CDL]} {
        if {$lvs_rule_deck eq ""} {
            puts "WARNING: PVS/Pegasus LVS rule deck not found."
            puts "         Find it on the lab server with: find $LIB_DIR -iname '*lvs*'"
            puts "         Then set PVS_LVS_RULE_DECK in scripts/pd_config.tcl."
        }
        if {![file isfile $LVS_CDL]} {
            puts "WARNING: Unified LVS CDL netlist ($LVS_CDL) could not be generated; check STD_CELL_CDL in scripts/pd_config.tcl."
        }
    } else {
        set cmd [list $pv_bin -lvs -dp $PV_CPUS -control $pvs_ctrl_file $lvs_rule_deck]
        pd_run_external_cmd $LVS_RUN_DIR $cmd [file join $LVS_DIR ${pv_engine}_lvs.log]
        if {[file isfile $lvs_rep]} {
            puts "INFO: Signoff LVS report written to: $lvs_rep"
        }
    }
} elseif {$pv_engine eq "calibre"} {
    set cal_rule_deck [pd_find_first_file $CALIBRE_LVS_RULE_DECK [list \
        "$LIB_DIR/gpdk045_v_6_0/calibre/*lvs*" \
        "$LIB_DIR/gpdk045_v_6_0/calibre/*LVS*" \
    ]]

    if {![file isfile $LVS_CDL] && [auto_execok v2lvs] ne "" && [llength $resolved_std_cdl] > 0} {
        set v2lvs_cmd [list v2lvs -v $LVS_VERILOG -o $LVS_CDL -s1 $POWER_NET -s0 $GROUND_NET]
        foreach vlib $resolved_std_verilog {
            lappend v2lvs_cmd -l $vlib
        }
        foreach cdl_file $resolved_std_cdl {
            lappend v2lvs_cmd -s $cdl_file
        }
        pd_run_external_cmd $LVS_RUN_DIR $v2lvs_cmd [file join $LVS_DIR v2lvs.log]
    }

    set runset_file [file join $LVS_DIR calibre_lvs.runset]
    set cal_rep [file join $LVS_DIR ${TOP}.lvs.report]
    set fh [open $runset_file w]
    puts $fh "LAYOUT PATH \"$GDS_FILE\""
    puts $fh "LAYOUT PRIMARY \"$TOP\""
    puts $fh "LAYOUT SYSTEM GDSII"
    puts $fh "SOURCE PATH \"$LVS_CDL\""
    puts $fh "SOURCE PRIMARY \"$TOP\""
    puts $fh "SOURCE SYSTEM SPICE"
    puts $fh "LVS REPORT \"$cal_rep\""
    puts $fh "MASK SVDB DIRECTORY \"$svdb_dir\" QUERY"
    puts $fh "LVS POWER NAME \"$POWER_NET\""
    puts $fh "LVS GROUND NAME \"$GROUND_NET\""
    if {$cal_rule_deck ne ""} {
        puts $fh "INCLUDE \"$cal_rule_deck\""
    }
    close $fh
    puts "INFO: Generated Calibre LVS runset: $runset_file"

    if {$cal_rule_deck eq "" || ![file isfile $LVS_CDL]} {
        puts "WARNING: Missing Calibre LVS rule deck or converted CDL ($LVS_CDL). Check scripts/pd_config.tcl."
    } else {
        set cmd [list $pv_bin -lvs -hier -turbo $PV_CPUS $runset_file]
        pd_run_external_cmd $LVS_RUN_DIR $cmd [file join $LVS_DIR calibre_lvs.log]
    }
} else {
    puts "INFO: No external EDA PV binary (pegasus/pvs/calibre) found (OS /usr/sbin/pvs LVM2 ignored)."
    puts "      In-Innovus connectivity report, merged GDSII ($GDS_FILE), and LVS CDL ($LVS_CDL) are ready."
    puts "      See scripts/MANUAL_GUIDE.md for running Cadence PVS/Pegasus LVS on the lab server."
}

puts "=== LVS flow finished. Reports in: $LVS_DIR ==="
if {![info exists ::env(INNOVUS_NO_EXIT)]} {
    exit
}
