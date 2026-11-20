set SCRIPT_DIR [file dirname [file normalize [info script]]]
source [file join $SCRIPT_DIR pd_config.tcl]

set PROJECT_DIR [file normalize [file join $SCRIPT_DIR ..]]
set OUTPUT_DIR [file join $PROJECT_DIR output genus]
set SDC_FILE [file join $OUTPUT_DIR datapath.sdc]
if {![file isfile $SDC_FILE]} {
    error "Run scripts/synth.tcl first; Genus SDC not found: $SDC_FILE"
}

create_library_set -name stdcells -timing $STD_CELL_LIBS
create_rc_corner -name rc_corner -qx_tech_file $QRC_TECH_FILE
create_delay_corner -name delay_corner -library_set stdcells -rc_corner rc_corner
create_constraint_mode -name functional -sdc_files [list $SDC_FILE]
create_analysis_view -name functional_view -constraint_mode functional -delay_corner delay_corner
set_analysis_view -setup {functional_view} -hold {functional_view}