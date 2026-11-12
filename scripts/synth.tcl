
# ==========================================
# RV32IM CPU - Cadence Genus Synthesis
# ==========================================

# 1. Set top module
set TOP cpu_rv32im_top

# 2. Technology library
# CHANGE THIS PATH TO YOUR PDK LIBRARY
set LIB "/path/to/your/technology/slow.lib"

set_db library $LIB

# 3. Read SystemVerilog source files
read_hdl -language sv {
    rtl/rv32im_pkg.sv
    rtl/cla_32bit.sv
    rtl/alu_rv32.sv
    rtl/register_file.sv
    rtl/hazard_unit.sv
    rtl/forwarding_unit.sv
    rtl/rv32im_core.sv
    rtl/imem.sv
    rtl/dmem.sv
    rtl/cpu_rv32im_top.sv
}

# 4. Elaborate
elaborate $TOP

# 5. Check design
check_design -unresolved

# 6. Read timing constraints
read_sdc constraints/top.sdc

# 7. Synthesis effort
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

# 8. Run synthesis
syn_generic
syn_map
syn_opt

# 9. Reports
report_area   > output/area.rpt
report_timing > output/timing.rpt
report_power  > output/power.rpt
report_gates  > output/gates.rpt
report_qor    > output/qor.rpt

# 10. Export gate-level netlist
write_hdl > output/cpu_rv32im_netlist.v

# Export constraints
write_sdc > output/cpu_rv32im.sdc

# 11. Finish
puts "================================"
puts "RV32IM SYNTHESIS COMPLETED"
puts "================================"

exit
