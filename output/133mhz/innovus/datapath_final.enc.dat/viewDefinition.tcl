if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name libs_fast\
   -timing\
    [list ${::IMEX::libVar}/mmmc/fast_vdd1v0_basicCells.lib]
create_library_set -name libs_slow\
   -timing\
    [list ${::IMEX::libVar}/mmmc/slow_vdd1v0_basicCells.lib]
create_rc_corner -name rc_fast\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 0\
   -qx_tech_file ${::IMEX::libVar}/mmmc/rc_fast/gpdk045.tch
create_rc_corner -name rc_slow\
   -preRoute_res 1\
   -postRoute_res 1\
   -preRoute_cap 1\
   -postRoute_cap 1\
   -postRoute_xcap 1\
   -preRoute_clkres 0\
   -preRoute_clkcap 0\
   -T 125\
   -qx_tech_file ${::IMEX::libVar}/mmmc/rc_fast/gpdk045.tch
create_delay_corner -name delay_fast\
   -library_set libs_fast\
   -rc_corner rc_fast
create_delay_corner -name delay_slow\
   -library_set libs_slow\
   -rc_corner rc_slow
create_constraint_mode -name functional\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/functional/functional.sdc]
create_analysis_view -name func_fast_view -constraint_mode functional -delay_corner delay_fast -latency_file ${::IMEX::dataVar}/mmmc/views/func_fast_view/latency.sdc
create_analysis_view -name func_slow_view -constraint_mode functional -delay_corner delay_slow -latency_file ${::IMEX::dataVar}/mmmc/views/func_slow_view/latency.sdc
set_analysis_view -setup [list func_slow_view] -hold [list func_fast_view]
