
set SCRIPT_DIR [file dirname [file normalize [info script]]]
set PROJECT_DIR [file normalize [file join $SCRIPT_DIR ..]]
source [file join $SCRIPT_DIR pd_config.tcl]

set TOP riscv
set RTL_DIR [file join $PROJECT_DIR rtl]
set RTL_LIST [file join $PROJECT_DIR rtl_files.f]
set SDC_FILE [file join $PROJECT_DIR constraints top.sdc]
set OUTPUT_DIR [file join $SCRIPT_DIR output genus]
set IMEM_IMAGE [file join $PROJECT_DIR tb mem imem.mem]
set IMEM_ROM [file join $OUTPUT_DIR imem_rom.sv]

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

set rtl_handle [open $RTL_LIST r]
set RTL_FILES [list]
while {[gets $rtl_handle line] >= 0} {
    set line [string trim $line]
    if {$line eq "" || [string match "#*" $line]} {
        continue
    }
    # Genus ignores $readmemh, so replace the simulation ROM implementation.
    if {[file tail $line] eq "imem_rom.sv"} {
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
if {![file isfile $IMEM_IMAGE]} {
    error "Instruction memory image not found: $IMEM_IMAGE"
}

set package_handle [open [file join $RTL_DIR def_pkg.sv] r]
set package_source [read $package_handle]
close $package_handle
if {![regexp {localparam\s+int\s+NUM_WORDS\s*=\s*([0-9]+)\s*;} $package_source -> imem_depth]} {
    error "Could not read NUM_WORDS from rtl/def_pkg.sv"
}

set imem_words [dict create]
set imem_address 0
set imem_handle [open $IMEM_IMAGE r]
while {[gets $imem_handle line] >= 0} {
    set line [string trim [regsub {//.*$} $line ""]]
    foreach token [regexp -all -inline {\S+} $line] {
        if {[regexp {^@([0-9a-fA-F]+)$} $token -> hex_address]} {
            if {[scan $hex_address %x imem_address] != 1} {
                close $imem_handle
                error "Invalid address in instruction memory image: $token"
            }
            continue
        }

        set word [string map {_ ""} $token]
        if {![regexp {^[0-9a-fA-F]+$} $word] || [string length $word] > 8} {
            close $imem_handle
            error "Invalid 32-bit hex word in instruction memory image: $token"
        }
        if {$imem_address >= $imem_depth} {
            close $imem_handle
            error "Instruction memory image exceeds NUM_WORDS ($imem_depth)"
        }
        dict set imem_words $imem_address $word
        incr imem_address
    }
}
close $imem_handle
if {[dict size $imem_words] == 0} {
    error "Instruction memory image is empty: $IMEM_IMAGE"
}

set rom_handle [open $IMEM_ROM w]
puts $rom_handle "import RV32_PKG::*;"
puts $rom_handle "module imem_rom ("
puts $rom_handle "    input logic \[\$clog2(NUM_WORDS) - 1:0\] addr,"
puts $rom_handle "    output logic \[INST_SIZE - 1:0\] data"
puts $rom_handle ");"
puts $rom_handle "    always_comb begin"
puts $rom_handle "        case (addr)"
foreach address [lsort -integer [dict keys $imem_words]] {
    puts $rom_handle "            $address: data = 32'h[dict get $imem_words $address];"
}
puts $rom_handle "            default: data = '0;"
puts $rom_handle "        endcase"
puts $rom_handle "    end"
puts $rom_handle "endmodule"
close $rom_handle
lappend RTL_FILES $IMEM_ROM
puts "Generated instruction ROM from $IMEM_IMAGE"

read_hdl -language sv $RTL_FILES
cd [file join $PROJECT_DIR tb mem]
elaborate $TOP
check_design -unresolved
read_sdc $SDC_FILE

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium
syn_generic
syn_map
syn_opt

report_area > [file join $OUTPUT_DIR area.rpt]
report_timing > [file join $OUTPUT_DIR timing.rpt]
report_power > [file join $OUTPUT_DIR power.rpt]
report_gates > [file join $OUTPUT_DIR gates.rpt]
report_qor > [file join $OUTPUT_DIR qor.rpt]
write_hdl -mapped > [file join $OUTPUT_DIR riscv_mapped.v]
write_sdc > [file join $OUTPUT_DIR riscv.sdc]

exit
