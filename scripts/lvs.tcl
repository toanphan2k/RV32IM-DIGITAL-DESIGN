# ------------------------------------------------------------------------------
# Signoff LVS flow for Cadence Innovus + Cadence Pegasus (GPDK045)
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

# Ensure top-level physical PG pins exist on the Metal7 core ring so GDSII has
# VDD/VSS port labels on layer (38, 3) for Pegasus LVS matching.
foreach pg_net [list $POWER_NET $GROUND_NET] {
    if {[llength [dbGet -e top.terms.name $pg_net]] == 0} {
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
}

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

puts "=== Exporting signoff GDSII ($GDS_FILE), LVS PG Verilog ($LVS_VERILOG), and CDL ($LVS_CDL) ==="
pd_export_gds $GDS_FILE $TOP $resolved_gds_map $resolved_std_gds $STREAMOUT_UNITS
pd_export_lvs_netlist $LVS_VERILOG $LVS_EXCLUDE_CELLS

if {[llength $resolved_std_cdl] > 0} {
    pd_verilog_to_cdl $LVS_VERILOG $resolved_std_cdl $LVS_CDL $TOP $POWER_NET $GROUND_NET
}

# 4. Prepare and run Cadence Pegasus signoff LVS
set pegasus_bin [auto_execok pegasus]
set lvs_rule_deck [pd_find_first_file $PEGASUS_LVS_RULE_DECK [list \
    "$LIB_DIR/gpdk045_v_6_0/pvs/*LVS*.rul" \
    "$LIB_DIR/gpdk045_v_6_0/pvs/*lvs*.rul" \
    "$LIB_DIR/gpdk045_v_6_0/pegasus/*lvs*" \
]]

set lvs_ctrl_file [file join $LVS_DIR pegasus_lvs.ctrl]
set lvs_rep  [file join $LVS_DIR lvs.rep]
set erc_sum  [file join $LVS_DIR erc.sum]
set erc_db   [file join $LVS_DIR erc.db]
set svdb_dir [file join $LVS_DIR svdb]
set layout_spi [file join $LVS_RUN_DIR ${TOP}_layout.spi]

set fh [open $lvs_ctrl_file w]
puts $fh "layout_path \"$GDS_FILE\" gdsii;"
puts $fh "layout_primary \"$TOP\";"
puts $fh "schematic_path \"$LVS_CDL\" cdl;"
puts $fh "schematic_primary \"$TOP\";"
puts $fh "lvs_report_file \"$lvs_rep\";"
puts $fh "report_summary -erc \"$erc_sum\" -replace;"
puts $fh "results_db -erc \"$erc_db\" -ascii;"
puts $fh "mask_svdb_dir \"$svdb_dir\";"
puts $fh "lvs_power_name \"$POWER_NET\";"
puts $fh "lvs_ground_name \"$GROUND_NET\";"
puts $fh "lvs_ignore_ports no;"
puts $fh "lvs_expand_cell_on_error yes;"
puts $fh "abort_on_layout_error yes;"
close $fh
puts "INFO: Generated Pegasus LVS control file: $lvs_ctrl_file"

if {$pegasus_bin eq ""} {
    puts "WARNING: Cadence Pegasus not found. Load it first (e.g. 'module load cadence/pegasus/241') and rerun."
} elseif {$lvs_rule_deck eq "" || ![file isfile $LVS_CDL]} {
    puts "WARNING: Missing Pegasus LVS rule deck or unified CDL ($LVS_CDL). Check scripts/pd_config.tcl."
} else {
    # GPDK045 pvlLVS.rul contains relative `include ./pvs_control_file`
    set deck_ctrl [file join [file dirname $lvs_rule_deck] pvs_control_file]
    if {[file isfile $deck_ctrl]} {
        file copy -force $deck_ctrl [file join $LVS_RUN_DIR pvs_control_file]
    }
    puts "=== Running Cadence Pegasus LVS ($pegasus_bin) ==="
    set cmd [list $pegasus_bin -lvs \
        -gds $GDS_FILE -layout_top_cell $TOP \
        -source_cdl $LVS_CDL -source_top_cell $TOP \
        -spice $layout_spi \
        -dp $PV_CPUS \
        -control $lvs_ctrl_file \
        $lvs_rule_deck]
    pd_run_external_cmd $LVS_RUN_DIR $cmd [file join $LVS_DIR pegasus_lvs.log]
    if {[file isfile $lvs_rep]} {
        puts "INFO: Signoff LVS report written to: $lvs_rep"
    }
}

puts "=== LVS flow finished. Reports in: $LVS_DIR ==="
if {![info exists ::env(INNOVUS_NO_EXIT)]} {
    exit
}
