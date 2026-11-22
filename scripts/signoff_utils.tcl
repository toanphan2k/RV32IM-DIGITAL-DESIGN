# ------------------------------------------------------------------------------
# Shared helper procedures for signoff DRC and LVS TCL flows
# ------------------------------------------------------------------------------

proc pd_find_first_file {configured_path fallback_globs} {
    if {$configured_path ne "" && [file isfile $configured_path]} {
        return [file normalize $configured_path]
    }
    foreach pattern $fallback_globs {
        set matches [lsort [glob -nocomplain -type f $pattern]]
        if {[llength $matches] > 0} {
            return [file normalize [lindex $matches 0]]
        }
    }
    return ""
}

proc pd_find_existing_files {configured_list fallback_globs} {
    set found [list]
    foreach item $configured_list {
        if {$item ne "" && [file isfile $item]} {
            lappend found [file normalize $item]
        }
    }
    if {[llength $found] > 0} {
        return $found
    }
    foreach pattern $fallback_globs {
        foreach match [lsort [glob -nocomplain -type f $pattern]] {
            lappend found [file normalize $match]
        }
    }
    return $found
}

proc pd_restore_innovus_design {enc_file top} {
    set already_loaded 0
    if {![catch {set current_top [dbGet top.name]}]} {
        if {$current_top eq $top} {
            set already_loaded 1
        }
    }
    if {$already_loaded} {
        puts "INFO: Using already-loaded Innovus design '$top'."
        return
    }
    if {![file isfile $enc_file]} {
        error "Run scripts/innovus.tcl first; Innovus checkpoint not found: $enc_file"
    }
    puts "INFO: Restoring Innovus design from $enc_file"
    source $enc_file
}

# Inspect a layer map file: if it is already an Innovus streamOut map (contains
# NET / SPNET / VIA object types), return it directly. If it is a Virtuoso/DFII
# .layermap (<layer> drawing/pin/label <gdsLayer> <gdsDatatype>), automatically
# convert it into a valid Innovus streamOut map filtered to LEF layers in DB so
# all signal nets, special nets, vias, and pins stream out cleanly.
proc pd_prepare_innovus_gds_map {candidate_map out_map_file} {
    if {$candidate_map eq "" || ![file isfile $candidate_map]} {
        return ""
    }
    set fh [open $candidate_map r]
    set raw [read $fh]
    close $fh

    set has_innovus_kw 0
    set has_virtuoso_kw 0
    foreach line [split $raw "\n"] {
        set t [string trim $line]
        if {$t eq "" || [string match "#*" $t]} { continue }
        set toks [regexp -all -inline {\S+} $t]
        if {[llength $toks] >= 4} {
            set obj [lindex $toks 1]
            if {[lsearch -exact {NET SPNET VIA LEFPIN LEFOBS FILL ALL} $obj] >= 0} {
                set has_innovus_kw 1
            }
            if {[lsearch -exact {drawing label net boundary} $obj] >= 0} {
                set has_virtuoso_kw 1
            }
        }
    }

    if {$has_innovus_kw && !$has_virtuoso_kw} {
        return $candidate_map
    }

    # Parse Virtuoso DFII layermap entries
    array unset draw_map
    array unset pin_map
    array unset lbl_map
    foreach line [split $raw "\n"] {
        set t [string trim $line]
        if {$t eq "" || [string match "#*" $t]} { continue }
        set toks [regexp -all -inline {\S+} $t]
        if {[llength $toks] < 4} { continue }
        set lyr [lindex $toks 0]
        set pur [string tolower [lindex $toks 1]]
        set gnum [lindex $toks 2]
        set gdt  [lindex $toks 3]
        if {![string is integer -strict $gnum] || ![string is integer -strict $gdt]} {
            continue
        }
        if {$pur eq "drawing"} {
            set draw_map($lyr) [list $gnum $gdt]
        } elseif {$pur eq "pin"} {
            set pin_map($lyr) [list $gnum $gdt]
        } elseif {$pur eq "label"} {
            set lbl_map($lyr) [list $gnum $gdt]
        }
    }

    # Query valid LEF layers loaded in Innovus DB to avoid IMPOGDS-392 unknown layer warnings
    array unset db_layer_type
    if {![catch {set lyr_ptrs [dbGet -e head.layers]}]} {
        foreach lp $lyr_ptrs {
            if {$lp eq "0x0" || $lp eq ""} { continue }
            set lname [dbGet ${lp}.name]
            set ltype [dbGet ${lp}.type]
            set db_layer_type($lname) $ltype
        }
    }

    file mkdir [file dirname $out_map_file]
    set out [open $out_map_file w]
    puts $out "# Auto-generated Innovus streamOut map converted from Virtuoso map: $candidate_map"
    set mapped_count 0

    foreach lyr [lsort [array names draw_map]] {
        if {[array size db_layer_type] > 0 && ![info exists db_layer_type($lyr)]} {
            continue
        }
        lassign $draw_map($lyr) dnum ddt
        lassign [expr {[info exists pin_map($lyr)] ? $pin_map($lyr) : $draw_map($lyr)}] pnum pdt
        lassign [expr {[info exists lbl_map($lyr)] ? $lbl_map($lyr) : [expr {[info exists pin_map($lyr)] ? $pin_map($lyr) : $draw_map($lyr)}]}] lnum ldt

        set ltype [expr {[info exists db_layer_type($lyr)] ? $db_layer_type($lyr) : ""}]
        if {$ltype eq "routing" || [string match -nocase "metal*" $lyr]} {
            puts $out [format "%-14s %-10s %5d %5d" $lyr "NET"    $dnum $ddt]
            puts $out [format "%-14s %-10s %5d %5d" $lyr "SPNET"  $dnum $ddt]
            puts $out [format "%-14s %-10s %5d %5d" $lyr "VIA"    $dnum $ddt]
            puts $out [format "%-14s %-10s %5d %5d" $lyr "PIN"    $pnum $pdt]
            puts $out [format "%-14s %-10s %5d %5d" $lyr "LEFPIN" $dnum $ddt]
            puts $out [format "%-14s %-10s %5d %5d" $lyr "LEFOBS" $dnum $ddt]
            puts $out [format "%-14s %-10s %5d %5d" $lyr "FILL"   $dnum $ddt]
            puts $out [format "%-14s %-18s %5d %5d" "NAME" "${lyr}/PIN"   $lnum $ldt]
            puts $out [format "%-14s %-18s %5d %5d" "NAME" "${lyr}/NET"   $lnum $ldt]
            puts $out [format "%-14s %-18s %5d %5d" "NAME" "${lyr}/SPNET" $lnum $ldt]
            incr mapped_count
        } elseif {$ltype eq "cut" || [string match -nocase "via*" $lyr] || [string equal -nocase "cont" $lyr]} {
            puts $out [format "%-14s %-10s %5d %5d" $lyr "VIA"    $dnum $ddt]
            puts $out [format "%-14s %-10s %5d %5d" $lyr "LEFPIN" $dnum $ddt]
            puts $out [format "%-14s %-10s %5d %5d" $lyr "LEFOBS" $dnum $ddt]
            incr mapped_count
        } else {
            puts $out [format "%-14s %-10s %5d %5d" $lyr "LEFPIN" $dnum $ddt]
            puts $out [format "%-14s %-10s %5d %5d" $lyr "LEFOBS" $dnum $ddt]
            incr mapped_count
        }
    }
    close $out

    if {$mapped_count == 0} {
        puts "WARNING: Could not extract valid LEF layer mappings from $candidate_map; falling back to Innovus default streamOut map."
        return ""
    }
    puts "INFO: Converted Virtuoso layermap ($candidate_map) -> Innovus streamOut map ($out_map_file, $mapped_count LEF layers)."
    return $out_map_file
}

proc pd_export_gds {gds_file top gds_map std_cell_gds units} {
    file mkdir [file dirname $gds_file]
    set prepared_map ""
    if {$gds_map ne "" && [file isfile $gds_map]} {
        set auto_map_path [file join [file dirname $gds_file] innovus_streamout.map]
        set prepared_map [pd_prepare_innovus_gds_map $gds_map $auto_map_path]
    }

    set cmd [list streamOut $gds_file \
        -libName DesignLib \
        -structureName $top \
        -units $units \
        -mode ALL]
    if {$prepared_map ne "" && [file isfile $prepared_map]} {
        lappend cmd -mapFile $prepared_map
    } else {
        puts "INFO: Running streamOut with Innovus built-in default layer map."
    }
    if {[llength $std_cell_gds] > 0} {
        lappend cmd -merge $std_cell_gds
    } else {
        puts "WARNING: STD_CELL_GDS not found; exported GDS will not contain merged standard-cell layouts."
    }
    puts "INFO: Running: $cmd"
    eval $cmd
}

proc pd_export_lvs_netlist {lvs_netlist exclude_cells} {
    file mkdir [file dirname $lvs_netlist]
    set cmd [list saveNetlist $lvs_netlist -phys -excludeLeafCell -flattenBus]
    if {[llength $exclude_cells] > 0} {
        lappend cmd -excludeCellInst $exclude_cells
    }
    puts "INFO: Running: $cmd"
    eval $cmd
}

# Pure-TCL gate-level Verilog -> SPICE/CDL converter for Cadence Pegasus LVS.
# Reads .SUBCKT pin orders from std_cell_cdl_list and converts saveNetlist -phys
# structural Verilog (including hierarchical clock-gating modules) into a unified CDL.
proc pd_verilog_to_cdl {verilog_file std_cell_cdl_list out_cdl_file top_name pwr_net gnd_net} {
    array unset subckt_pins

    # 1. Parse standard-cell .SUBCKT pin order from CDL libraries
    foreach cdl_file $std_cell_cdl_list {
        if {![file isfile $cdl_file]} { continue }
        set fh [open $cdl_file r]
        set logical_line ""
        while {[gets $fh raw_line] >= 0} {
            set trimmed [string trim $raw_line]
            if {[string match "\\**" $trimmed]} { continue }
            if {[string match "+*" $trimmed]} {
                append logical_line " " [string trim [string range $trimmed 1 end]]
                continue
            }
            if {$logical_line ne ""} {
                if {[regexp -nocase {^\.subckt\s+(\S+)\s+(.*)$} $logical_line -> cname rest]} {
                    set pins [list]
                    foreach tok [regexp -all -inline {\S+} $rest] {
                        if {[string match "*=*" $tok]} { continue }
                        lappend pins $tok
                    }
                    set subckt_pins($cname) $pins
                }
            }
            set logical_line $trimmed
        }
        if {$logical_line ne "" && [regexp -nocase {^\.subckt\s+(\S+)\s+(.*)$} $logical_line -> cname rest]} {
            set pins [list]
            foreach tok [regexp -all -inline {\S+} $rest] {
                if {[string match "*=*" $tok]} { continue }
                lappend pins $tok
            }
            set subckt_pins($cname) $pins
        }
        close $fh
    }

    if {[array size subckt_pins] == 0} {
        puts "WARNING: No .SUBCKT definitions parsed from STD_CELL_CDL; skipping Tcl CDL generation."
        return 0
    }

    # 2. Read structural Verilog netlist, strip comments, and process statement by statement
    set vfh [open $verilog_file r]
    set vtxt [read $vfh]
    close $vfh

    regsub -all {/\*.*?\*/} $vtxt "" vtxt
    set clean_lines [list]
    foreach line [split $vtxt "\n"] {
        regsub {//.*$} $line "" line
        lappend clean_lines $line
    }
    set vtxt [join $clean_lines "\n"]

    file mkdir [file dirname $out_cdl_file]
    set out [open $out_cdl_file w]
    puts $out "* Auto-generated LVS CDL netlist from $verilog_file"
    foreach cdl_file $std_cell_cdl_list {
        if {[file isfile $cdl_file]} {
            puts $out ".INCLUDE \"[file normalize $cdl_file]\""
        }
    }
    puts $out ""

    set in_mod 0
    set cur_mod ""
    set hdr_ports [list]
    array unset bus_bounds
    set mod_inst_stmts [list]
    set unconn_idx 0

    foreach raw_stmt [split $vtxt ";"] {
        set s [string trim $raw_stmt]
        if {$s eq ""} { continue }

        # Handle 'endmodule' attached in front of the next module header
        # (Note: Tcl regex uses \M / whitespace, NOT \b which matches backspace 0x08)
        while {[regexp {^endmodule(?:\s+(.*)|$)} $s -> remainder]} {
            if {$in_mod} {
                # Build expanded port list for cur_mod
                set expanded_ports [list]
                foreach p $hdr_ports {
                    set clean_p $p
                    if {[string index $clean_p 0] eq "\\"} {
                        set clean_p [string range $clean_p 1 end]
                    }
                    regsub -all {\s+} $clean_p "" clean_p
                    if {[info exists bus_bounds($clean_p)]} {
                        lassign $bus_bounds($clean_p) msb lsb
                        set step [expr {$msb >= $lsb ? -1 : 1}]
                        for {set b $msb} {$step < 0 ? ($b >= $lsb) : ($b <= $lsb)} {incr b $step} {
                            lappend expanded_ports "${clean_p}\[$b\]"
                        }
                    } else {
                        lappend expanded_ports $clean_p
                    }
                }
                if {$cur_mod eq $top_name} {
                    if {[lsearch -exact $expanded_ports $pwr_net] < 0} {
                        lappend expanded_ports $pwr_net
                    }
                    if {[lsearch -exact $expanded_ports $gnd_net] < 0} {
                        lappend expanded_ports $gnd_net
                    }
                }
                set subckt_pins($cur_mod) $expanded_ports

                puts $out ".SUBCKT $cur_mod [join $expanded_ports { }]"
                foreach inst_rec $mod_inst_stmts {
                    lassign $inst_rec cell_type inst_name pin_kv_list
                    array unset conn_map
                    foreach {k v} $pin_kv_list {
                        set conn_map($k) $v
                    }
                    if {![info exists subckt_pins($cell_type)]} {
                        set ordered_pins [lsort [array names conn_map]]
                    } else {
                        set ordered_pins $subckt_pins($cell_type)
                    }
                    set net_args [list]
                    foreach pname $ordered_pins {
                        if {[info exists conn_map($pname)] && $conn_map($pname) ne ""} {
                            set net_tok $conn_map($pname)
                        } elseif {$pname eq $pwr_net} {
                            set net_tok $pwr_net
                        } elseif {$pname eq $gnd_net} {
                            set net_tok $gnd_net
                        } else {
                            incr unconn_idx
                            set net_tok "UNCONN_${unconn_idx}"
                        }
                        # Sanitize Verilog escaped identifiers (\foo [0] -> foo[0])
                        if {[string index $net_tok 0] eq "\\"} {
                            set net_tok [string range $net_tok 1 end]
                            regsub -all {\s+} $net_tok "" net_tok
                        }
                        lappend net_args $net_tok
                    }
                    set clean_inst $inst_name
                    if {[string index $clean_inst 0] eq "\\"} {
                        set clean_inst [string range $clean_inst 1 end]
                    }
                    regsub -all {\s+} $clean_inst "" clean_inst
                    puts $out "X${clean_inst} [join $net_args { }] $cell_type"
                }
                puts $out ".ENDS $cur_mod"
                puts $out ""
                set in_mod 0
            }
            set s [string trim $remainder]
        }
        if {$s eq ""} { continue }

        if {!$in_mod} {
            if {[regexp {^module\s+(\S+)\s*\((.*)\)$} $s -> mname plist]} {
                set in_mod 1
                set cur_mod $mname
                set hdr_ports [list]
                array unset bus_bounds
                set mod_inst_stmts [list]
                foreach p [split $plist ","] {
                    set pt [string trim $p]
                    if {$pt ne ""} { lappend hdr_ports $pt }
                }
            }
            continue
        }

        if {[regexp {^(input|output|inout)\s*(?:\[\s*(\d+)\s*:\s*(\d+)\s*\])?\s*(.*)$} $s -> dir msb lsb names_str]} {
            if {$msb ne "" && $lsb ne ""} {
                foreach nm [split $names_str ","] {
                    set nmt [string trim $nm]
                    if {$nmt ne ""} {
                        set bus_bounds($nmt) [list $msb $lsb]
                    }
                }
            }
            continue
        }
        if {[regexp {^wire(?:\s|$)} $s]} {
            continue
        }
        if {[regexp {^assign\s+(\S+)\s*=\s*(\S+)$} $s -> lhs rhs]} {
            # Connect shorted nets via 0V/tiny resistor or star-connect; Innovus -phys rarely emits assign
            incr unconn_idx
            puts $out "RASSIGN_${unconn_idx} $lhs $rhs 0"
            continue
        }

        # Cell / module instantiation: <cell_type> <inst_name> ( .PIN(NET), ... )
        if {[regexp {^(\S+)\s+(.+?)\s*\((.*)\)$} $s -> ctype iname conns_str]} {
            set pin_kv [list]
            foreach {_ pname netexpr} [regexp -all -inline {\.\s*([^\s\(]+)\s*\(\s*([^\)]*?)\s*\)} $conns_str] {
                set clean_pname [string trim $pname]
                if {[string index $clean_pname 0] eq "\\"} {
                    set clean_pname [string range $clean_pname 1 end]
                }
                regsub -all {\s+} $clean_pname "" clean_pname
                lappend pin_kv $clean_pname [string trim $netexpr]
            }
            lappend mod_inst_stmts [list $ctype [string trim $iname] $pin_kv]
        }
    }

    # Flush trailing endmodule if no semicolon followed endmodule
    if {$in_mod} {
        set expanded_ports [list]
        foreach p $hdr_ports {
            set clean_p $p
            if {[string index $clean_p 0] eq "\\"} {
                set clean_p [string range $clean_p 1 end]
            }
            regsub -all {\s+} $clean_p "" clean_p
            if {[info exists bus_bounds($clean_p)]} {
                lassign $bus_bounds($clean_p) msb lsb
                set step [expr {$msb >= $lsb ? -1 : 1}]
                for {set b $msb} {$step < 0 ? ($b >= $lsb) : ($b <= $lsb)} {incr b $step} {
                    lappend expanded_ports "${clean_p}\[$b\]"
                }
            } else {
                lappend expanded_ports $clean_p
            }
        }
        if {$cur_mod eq $top_name} {
            if {[lsearch -exact $expanded_ports $pwr_net] < 0} { lappend expanded_ports $pwr_net }
            if {[lsearch -exact $expanded_ports $gnd_net] < 0} { lappend expanded_ports $gnd_net }
        }
        puts $out ".SUBCKT $cur_mod [join $expanded_ports { }]"
        foreach inst_rec $mod_inst_stmts {
            lassign $inst_rec cell_type inst_name pin_kv_list
            array unset conn_map
            foreach {k v} $pin_kv_list { set conn_map($k) $v }
            set ordered_pins [expr {[info exists subckt_pins($cell_type)] ? $subckt_pins($cell_type) : [lsort [array names conn_map]]}]
            set net_args [list]
            foreach pname $ordered_pins {
                if {[info exists conn_map($pname)] && $conn_map($pname) ne ""} {
                    set net_tok $conn_map($pname)
                } elseif {$pname eq $pwr_net} {
                    set net_tok $pwr_net
                } elseif {$pname eq $gnd_net} {
                    set net_tok $gnd_net
                } else {
                    incr unconn_idx
                    set net_tok "UNCONN_${unconn_idx}"
                }
                if {[string index $net_tok 0] eq "\\"} {
                    set net_tok [string range $net_tok 1 end]
                    regsub -all {\s+} $net_tok "" net_tok
                }
                lappend net_args $net_tok
            }
            set clean_inst $inst_name
            if {[string index $clean_inst 0] eq "\\"} { set clean_inst [string range $clean_inst 1 end] }
            regsub -all {\s+} $clean_inst "" clean_inst
            puts $out "X${clean_inst} [join $net_args { }] $cell_type"
        }
        puts $out ".ENDS $cur_mod"
    }

    close $out
    puts "INFO: Generated LVS SPICE/CDL netlist: $out_cdl_file"
    return 1
}

proc pd_run_external_cmd {run_dir cmd_list log_file} {
    file mkdir $run_dir
    file mkdir [file dirname $log_file]
    set orig_dir [pwd]
    cd $run_dir
    puts "INFO: Executing in $run_dir: $cmd_list"
    set status [catch {exec {*}$cmd_list >& $log_file} err_msg]
    cd $orig_dir
    if {$status != 0} {
        puts "WARNING: External command exited with non-zero status ($err_msg). Check log: $log_file"
    } else {
        puts "INFO: External command completed cleanly. Log: $log_file"
    }
    return $status
}
