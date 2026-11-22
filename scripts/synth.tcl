if {[info commands read_hdl] eq ""} {
    error "scripts/synth.tcl must be run inside Cadence Genus: genus -files scripts/synth.tcl"
}

set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJECT_DIR [file normalize [file join $SCRIPT_DIR ..]]
source [file join $SCRIPT_DIR pd_config.tcl]

set TOP datapath
set RTL_DIR [file join $PROJECT_DIR rtl]
set RTL_LIST [file join $PROJECT_DIR rtl_files.f]
if {[info exists ::env(PD_SDC_FILE)] && $::env(PD_SDC_FILE) ne ""} {
    if {[file pathtype $::env(PD_SDC_FILE)] eq "absolute"} {
        set SDC_FILE [file normalize $::env(PD_SDC_FILE)]
    } else {
        set SDC_FILE [file normalize [file join $PROJECT_DIR $::env(PD_SDC_FILE)]]
    }
} else {
    set SDC_FILE [file join $PROJECT_DIR constraints top.sdc]
}
if {[info exists ::env(PD_OUTPUT_DIR)] && $::env(PD_OUTPUT_DIR) ne ""} {
    if {[file pathtype $::env(PD_OUTPUT_DIR)] eq "absolute"} {
        set OUTPUT_ROOT [file normalize $::env(PD_OUTPUT_DIR)]
    } else {
        set OUTPUT_ROOT [file normalize [file join $PROJECT_DIR $::env(PD_OUTPUT_DIR)]]
    }
} else {
    set OUTPUT_ROOT [file join $PROJECT_DIR output]
}
set OUTPUT_DIR [file join $OUTPUT_ROOT genus]
set SYNTH_EXCLUDED_RTL [list dmem.sv imem.sv imem_rom.sv memorypath.sv riscv.sv]

if {![info exists STD_CELL_LIBS] || [llength $STD_CELL_LIBS] == 0} {
    error "Set STD_CELL_LIBS in scripts/pd_config.tcl"
}
foreach library $STD_CELL_LIBS {
    if {![file isfile $library]} {
        error "Standard-cell library not found: $library"
    }
}

set_db init_lib_search_path [list $LIB_DIR]
read_libs $STD_CELL_LIBS
foreach cell_pattern $DONT_USE_CELLS {
    set matching_lib_cells [get_db lib_cells */$cell_pattern]
    if {[llength $matching_lib_cells] == 0} {
        puts "INFO: No library cells matched dont_use pattern '$cell_pattern' (skipping)."
    } else {
        set_db $matching_lib_cells .dont_use true
        puts "INFO: Excluded [llength $matching_lib_cells] library cell(s) matching '$cell_pattern'."
    }
}

if {[info exists ENABLE_CLOCK_GATING] && $ENABLE_CLOCK_GATING} {
    set_db lp_insert_clock_gating true
}

set rtl_handle [open $RTL_LIST r]
set RTL_FILES [list]
while {[gets $rtl_handle line] >= 0} {
    set line [string trim $line]
    if {$line eq "" || [string match "#*" $line]} {
        continue
    }
    if {[lsearch -exact $SYNTH_EXCLUDED_RTL [file tail $line]] >= 0} {
        continue
    }
    set source_file [file join $RTL_DIR [file tail $line]]
    if {![file isfile $source_file]} {
        close $rtl_handle
        error "RTL source not found: $source_file"
    }
    lappend RTL_FILES $source_file
}
close $rtl_handle

file mkdir $OUTPUT_DIR
puts "Synthesizing datapath as the generic CPU core; instruction and data memories are external."

read_hdl -language sv $RTL_FILES
elaborate $TOP
check_design -unresolved
read_sdc $SDC_FILE
check_timing_intent > [file join $OUTPUT_DIR check_timing.rpt]
report_timing -lint > [file join $OUTPUT_DIR timing_lint.rpt]

set_db syn_generic_effort high
set_db syn_map_effort high
set_db syn_opt_effort high
syn_generic
syn_map
syn_opt

report_area > [file join $OUTPUT_DIR area.rpt]
report_timing > [file join $OUTPUT_DIR timing.rpt]
report_power > [file join $OUTPUT_DIR power.rpt]
report_gates > [file join $OUTPUT_DIR gates.rpt]
report_qor > [file join $OUTPUT_DIR qor.rpt]
if {[info exists ENABLE_CLOCK_GATING] && $ENABLE_CLOCK_GATING} {
    report_clock_gating > [file join $OUTPUT_DIR clock_gating.rpt]
}

write_hdl -mapped > [file join $OUTPUT_DIR datapath_mapped.v]
write_sdc > [file join $OUTPUT_DIR datapath.sdc]
write_do_lec -revised_design [file join $OUTPUT_DIR datapath_mapped.v] \
    -logfile [file join $OUTPUT_DIR lec_rtl2mapped.log] \
    > [file join $OUTPUT_DIR rtl_to_mapped.do]

exit
