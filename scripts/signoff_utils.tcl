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

proc pd_detect_pv_tool {requested_tool} {
    set req [string tolower [string trim $requested_tool]]
    if {$req eq "" || $req eq "auto"} {
        foreach candidate {pegasus pvs calibre} {
            if {[auto_execok $candidate] ne ""} {
                return $candidate
            }
        }
        return "innovus_only"
    }
    if {$req eq "innovus_only"} {
        return "innovus_only"
    }
    if {[lsearch -exact {pegasus pvs calibre} $req] < 0} {
        error "Unsupported PV_TOOL '$requested_tool'. Use auto, pegasus, pvs, calibre, or innovus_only."
    }
    if {[auto_execok $req] eq ""} {
        puts "WARNING: Requested PV_TOOL '$req' was not found in PATH; falling back to innovus_only."
        return "innovus_only"
    }
    return $req
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

proc pd_export_gds {gds_file top gds_map std_cell_gds units} {
    file mkdir [file dirname $gds_file]
    set cmd [list streamOut $gds_file \
        -libName DesignLib \
        -structureName $top \
        -stripes 1 \
        -units $units \
        -mode ALL]
    if {$gds_map ne "" && [file isfile $gds_map]} {
        lappend cmd -mapFile $gds_map
    } else {
        puts "WARNING: GDS_MAP_FILE not set or not found; running streamOut with Innovus default layer map."
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
    set cmd [list saveNetlist $lvs_netlist -phys -excludeLeafCell]
    if {[llength $exclude_cells] > 0} {
        lappend cmd -excludeCellInst $exclude_cells
    }
    puts "INFO: Running: $cmd"
    eval $cmd
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
