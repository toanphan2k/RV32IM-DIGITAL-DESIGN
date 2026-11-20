if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name stdcells\
   -timing\
    [list ${::IMEX::libVar}/mmmc/slow_vdd1v0_basicCells.lib]
create_rc_corner -name rc_corner\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -qx_tech_file ${::IMEX::libVar}/mmmc/rc_corner/gpdk045.tch
create_delay_corner -name delay_corner\
   -library_set stdcells\
   -rc_corner rc_corner
create_constraint_mode -name functional\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/functional/functional.sdc]
create_analysis_view -name functional_view -constraint_mode functional -delay_corner delay_corner -latency_file ${::IMEX::dataVar}/mmmc/views/functional_view/latency.sdc
set_analysis_view -setup [list functional_view] -hold [list functional_view]
