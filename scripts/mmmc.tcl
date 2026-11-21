set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR pd_config.tcl]

set PROJECT_DIR [file normalize [file join $SCRIPT_DIR ..]]
set OUTPUT_DIR [file join $PROJECT_DIR output genus]
set SDC_FILE [file join $OUTPUT_DIR datapath.sdc]
if {![file isfile $SDC_FILE]} {
    error "Run scripts/synth.tcl first; Genus SDC not found: $SDC_FILE"
}

# Dual-corner MMMC: slow/worst-case for setup, fast/best-case for hold
create_library_set -name libs_slow -timing $STD_CELL_LIBS_SLOW
create_library_set -name libs_fast -timing $STD_CELL_LIBS_FAST

create_rc_corner -name rc_slow -qx_tech_file $QRC_TECH_FILE -T 125
create_rc_corner -name rc_fast -qx_tech_file $QRC_TECH_FILE -T 0

create_delay_corner -name delay_slow -library_set libs_slow -rc_corner rc_slow
create_delay_corner -name delay_fast -library_set libs_fast -rc_corner rc_fast

create_constraint_mode -name functional -sdc_files [list $SDC_FILE]

create_analysis_view -name func_slow_view -constraint_mode functional -delay_corner delay_slow
create_analysis_view -name func_fast_view -constraint_mode functional -delay_corner delay_fast

set_analysis_view -setup {func_slow_view} -hold {func_fast_view}
