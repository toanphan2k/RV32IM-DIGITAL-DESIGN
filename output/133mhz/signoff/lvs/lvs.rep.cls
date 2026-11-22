##############################################################################################################
#####  
#####                                       Pegasus LVS COMPARISON
#####  
#####  Version                       :   24.11-s021
#####  NVN Run Start                 :   Sun Nov 22 17:55:46 2026
#####  ERC Summary File              :   erc.sum
#####  Extraction Report File        :   lvs.rep
#####  Comparison Report File        :   /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/lvs/lvs.rep.cls
#####  Top Cell                      :   datapath  <vs>  datapath
#####  
#####  Run Result                    :   MATCH
#####  
#####  Run Summary                   :   [INFO]  ERC Results: Empty
#####                                :   [INFO]  Extraction Clean
#####                                :   [INFO]  Some Sections Have Been Truncated
#####  
#####  Layout Design                 :   /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath.gds (GDSII)
#####  Layout File                   :   /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/lvs/run/datapath_layout.spi (cdl)
#####  Schematic File                :   /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath_lvs.cdl (cdl)
#####  Rules File                    :   /tools/eda/pdks/cadence/gpdk045/gpdk045_v_6_0/pvs/pvlLVS.rul
#####  Pin Swap File                 :   lvs.rep.cps
#####  
#####  Extraction CPU Time           :   0h 1m 0s - (60s)
#####  Extraction Exec Time          :   0h 1m 9s - (69s)
#####  Extraction Peak Memory Usage  :   226.00MB
#####  NVN CPU Time                  :   0h 0m 4s - (4s)                 
#####  NVN Exec Time                 :   0h 0m 12s - (12s)               
#####  NVN Peak Memory Usage         :   812.36MB
#####  LVS Total CPU Time            :   0h 1m 4s - (64s)                
#####  LVS Total Exec Time           :   0h 1m 21s - (81s)               
#####  LVS Total Peak Memory Usage   :   812.36MB
#####  
##############################################################################################################


##############################################################################################################
#
#                                            CELL MATCH STATISTICS                                            
#
##############################################################################################################

Cell Statistic Descriptions                  | Count
---------------------------------------------+----------
Cells matched                                |         1
Cells expanded                               |         0
Cells not run                                |         0
Cells which mismatch                         |         0
---------------------------------------------+----------
Total                                        |         1


Cell Statistic Detail                        | Count
---------------------------------------------+----------
Cells with parameter mismatches              |         0
Cells with mismatched instance subtypes      |         0
Cells that have been blackboxed              |         0


##############################################################################################################
#
#                                             CELL MATCH SUMMARY                                              
#
##############################################################################################################

             |     Initial Pins     |     Compare Pins     |            | 
Cell         |   lay    :    sch    |   lay    :    sch    | Status     | Detail
-------------+----------+-----------+----------+-----------+------------+--------------
datapath     |      232 :       232 |      232 :       232 | match      | truncated


##############################################################################################################
#
#                                                  LVS RULES                                                  
#
##############################################################################################################

Command Line LVS Rule Values
----------------------------

    layout_primary                          datapath {-layout_top_cell datapath}
    layout_path                             /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath.gds
                                            {-gds
                                            /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath.gds}
    layout_format                           GDSII {-gds
                                            /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath.gds}
    schematic_primary                       datapath {-source_top_cell datapath}
    schematic_path                          /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath_lvs.cdl
                                            {-source_cdl
                                            /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath_lvs.cdl}
    schematic_format                        CDL {-source_cdl
                                            /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath_lvs.cdl}

LVS Rules Given in the Rules File
---------------------------------

    layout_path                             /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath.gds
                                            gdsii
    layout_primary                          datapath
    schematic_path                          /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath_lvs.cdl
                                            cdl
    schematic_primary                       datapath
    lvs_netlist                             yes -allow_inconsistent_model
                                             
    lvs_power_name                          VDD 
    lvs_ground_name                         VSS 
    lvs_ignore_ports                        no  
    lvs_filter_option                       AG RC RE RG -source_layout
    lvs_reduce_device                       C ( g45cmim ) -parallel yes ...
    lvs_expand_cell_on_error                yes 
    lvs_check_property                      MN ( g45n1svt ) l l -tolerance 0
    lvs_check_property                      MN ( g45n1svt ) w w -tolerance 0
    lvs_check_property                      MN ( g45n1hvt ) l l -tolerance 0
    lvs_check_property                      MN ( g45n1hvt ) w w -tolerance 0
    lvs_check_property                      MN ( g45n1lvt ) l l -tolerance 0
    lvs_check_property                      MN ( g45n1lvt ) w w -tolerance 0
    lvs_check_property                      MN ( g45n1nvt ) l l -tolerance 0
    lvs_check_property                      MN ( g45n1nvt ) w w -tolerance 0
    lvs_check_property                      MN ( g45n2svt ) l l -tolerance 0
    lvs_check_property                      MN ( g45n2svt ) w w -tolerance 0
    lvs_check_property                      MN ( g45n2nvt ) l l -tolerance 0
    lvs_check_property                      MN ( g45n2nvt ) w w -tolerance 0
    lvs_check_property                      MN ( g45ncap1 ) l l -tolerance 0
    lvs_check_property                      MN ( g45ncap1 ) w w -tolerance 0
    lvs_check_property                      MN ( g45ncap2 ) l l -tolerance 0
    lvs_check_property                      MN ( g45ncap2 ) w w -tolerance 0
    lvs_check_property                      MP ( g45p1svt ) l l -tolerance 0
    lvs_check_property                      MP ( g45p1svt ) w w -tolerance 0
    lvs_check_property                      MP ( g45p1hvt ) l l -tolerance 0
    lvs_check_property                      MP ( g45p1hvt ) w w -tolerance 0
    lvs_check_property                      MP ( g45p1lvt ) l l -tolerance 0
    lvs_check_property                      MP ( g45p1lvt ) w w -tolerance 0
    lvs_check_property                      MP ( g45p2svt ) l l -tolerance 0
    lvs_check_property                      MP ( g45p2svt ) w w -tolerance 0
    lvs_check_property                      MP ( g45pcap1 ) l l -tolerance 0
    lvs_check_property                      MP ( g45pcap1 ) w w -tolerance 0
    lvs_check_property                      MP ( g45pcap2 ) l l -tolerance 0
    lvs_check_property                      MP ( g45pcap2 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm1 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm1 ) l l -tolerance 0
    lvs_check_property                      R ( g45rm2 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm2 ) l l -tolerance 0
    lvs_check_property                      R ( g45rm3 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm3 ) l l -tolerance 0
    lvs_check_property                      R ( g45rm4 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm4 ) l l -tolerance 0
    lvs_check_property                      R ( g45rm5 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm5 ) l l -tolerance 0
    lvs_check_property                      R ( g45rm6 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm6 ) l l -tolerance 0
    lvs_check_property                      R ( g45rm7 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm7 ) l l -tolerance 0
    lvs_check_property                      R ( g45rm8 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm8 ) l l -tolerance 0
    lvs_check_property                      R ( g45rm9 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm9 ) l l -tolerance 0
    lvs_check_property                      R ( g45rm10 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm10 ) l l -tolerance 0
    lvs_check_property                      R ( g45rm11 ) w w -tolerance 0
    lvs_check_property                      R ( g45rm11 ) l l -tolerance 0
    lvs_check_property                      R ( g45rsnd ) w w -tolerance 0
    lvs_check_property                      R ( g45rsnd ) l l -tolerance 0
    lvs_check_property                      R ( g45rnsnd ) w w -tolerance 0
    lvs_check_property                      R ( g45rnsnd ) l l -tolerance 0
    lvs_check_property                      R ( g45rsnp ) w w -tolerance 0
    lvs_check_property                      R ( g45rsnp ) l l -tolerance 0
    lvs_check_property                      R ( g45rnsnp ) w w -tolerance 0
    lvs_check_property                      R ( g45rnsnp ) l l -tolerance 0
    lvs_check_property                      R ( g45rspd ) w w -tolerance 0
    lvs_check_property                      R ( g45rspd ) l l -tolerance 0
    lvs_check_property                      R ( g45rnspd ) w w -tolerance 0
    lvs_check_property                      R ( g45rnspd ) l l -tolerance 0
    lvs_check_property                      R ( g45rspp ) w w -tolerance 0
    lvs_check_property                      R ( g45rspp ) l l -tolerance 0
    lvs_check_property                      R ( g45rnspp ) w w -tolerance 0
    lvs_check_property                      R ( g45rnspp ) l l -tolerance 0
    lvs_check_property                      R ( g45rnws ) w w -tolerance 0
    lvs_check_property                      R ( g45rnws ) l l -tolerance 0
    lvs_check_property                      R ( g45rnwo ) w w -tolerance 0
    lvs_check_property                      R ( g45rnwo ) l l -tolerance 0
    lvs_check_property                      D ( g45nd1svt ) A A -tolerance 0
    lvs_check_property                      D ( g45nd1svt ) P P -tolerance 0
    lvs_check_property                      D ( g45nd1lvt ) A A -tolerance 0
    lvs_check_property                      D ( g45nd1lvt ) P P -tolerance 0
    lvs_check_property                      D ( g45nd1hvt ) A A -tolerance 0
    lvs_check_property                      D ( g45nd1hvt ) P P -tolerance 0
    lvs_check_property                      D ( g45nd1nvt ) A A -tolerance 0
    lvs_check_property                      D ( g45nd1nvt ) P P -tolerance 0
    lvs_check_property                      D ( g45nd2svt ) A A -tolerance 0
    lvs_check_property                      D ( g45nd2svt ) P P -tolerance 0
    lvs_check_property                      D ( g45nd2nvt ) A A -tolerance 0
    lvs_check_property                      D ( g45nd2nvt ) P P -tolerance 0
    lvs_check_property                      D ( g45pd1svt ) A A -tolerance 0
    lvs_check_property                      D ( g45pd1svt ) P P -tolerance 0
    lvs_check_property                      D ( g45pd1lvt ) A A -tolerance 0
    lvs_check_property                      D ( g45pd1lvt ) P P -tolerance 0
    lvs_check_property                      D ( g45pd1hvt ) A A -tolerance 0
    lvs_check_property                      D ( g45pd1hvt ) P P -tolerance 0
    lvs_check_property                      D ( g45pd2svt ) A A -tolerance 0
    lvs_check_property                      D ( g45pd2svt ) P P -tolerance 0
    lvs_check_property                      Q ( g45vpnp2 ) A A -tolerance 0
    lvs_check_property                      Q ( g45vpnp5 ) A A -tolerance 0
    lvs_check_property                      Q ( g45vpnp10 ) A A -tolerance 0
    lvs_check_property                      Q ( g45vnpn2 ) A A -tolerance 0
    lvs_check_property                      Q ( g45vnpn5 ) A A -tolerance 0
    lvs_check_property                      Q ( g45vnpn10 ) A A -tolerance 0
    lvs_check_property                      C ( g45cmim ) l l -tolerance 0
    lvs_check_property                      C ( g45cmim ) w w -tolerance 0
    lvs_check_property                      L ( g45inda ) width width -tolerance 0
    lvs_check_property                      L ( g45inda ) space space -tolerance 0
    lvs_check_property                      L ( g45inda ) nr nr -tolerance 0
    lvs_check_property                      L ( g45inda ) rad rad -tolerance 0
    lvs_check_property                      L ( g45inds ) width width -tolerance 0
    lvs_check_property                      L ( g45inds ) space space -tolerance 0
    lvs_check_property                      L ( g45inds ) nr nr -tolerance 0
    lvs_check_property                      L ( g45inds ) rad rad -tolerance 0
    lvs_report_file                         /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/lvs/lvs.rep
    lvs_map_device                          M ( g45n1svt ) MN ( g45n1svt ) -source_layout
    lvs_map_device                          M ( g45n1hvt ) MN ( g45n1hvt ) -source_layout
    lvs_map_device                          M ( g45n1lvt ) MN ( g45n1lvt ) -source_layout
    lvs_map_device                          M ( g45n1nvt ) MN ( g45n1nvt ) -source_layout
    lvs_map_device                          M ( g45n2svt ) MN ( g45n2svt ) -source_layout
    lvs_map_device                          M ( g45n2nvt ) MN ( g45n2nvt ) -source_layout
    lvs_map_device                          M ( g45p1svt ) MP ( g45p1svt ) -source_layout
    lvs_map_device                          M ( g45p1hvt ) MP ( g45p1hvt ) -source_layout
    lvs_map_device                          M ( g45p1lvt ) MP ( g45p1lvt ) -source_layout
    lvs_map_device                          M ( g45p2svt ) MP ( g45p2svt ) -source_layout
    unit                                    -length u
    input_scale                             2000
    text_depth                              -primary

Default LVS Rule Values
-----------------------

    lvs_abort                               -softchk no
    lvs_abort                               -supply_error no
    lvs_abort                               -check_device_for_property_rule no
    lvs_abort                               -missing_hcell no
    lvs_abort                               -erc_error yes
    lvs_abort                               -inconsistent_reduction yes
    layout_case_sensitive                   no
    // layout_cpf_file                       
    // schematic_cpf_file                    
    schematic_case_sensitive                no
    // hcell_file                            
    // hcell                                 
    // lvs_exclude_hcell                     
    // lvs_gen_hcells                        
    // lvs_delete_cell                       
    lvs_push_devices                        yes
    lvs_push_devices_properties             no
    lvs_netlist                             yes -substrate_comment
    lvs_netlist                             yes -box_contents
    lvs_netlist                             yes -unnamed_box_pins
    lvs_netlist                             yes -properties_comment
    // lvs_write_netlist                     
    // lvs_write_netlist_reduced             
    // lvs_delete_cell_pin                   
    // lvs_black_box                         
    // lvs_interposer                        
    lvs_spice                               yes -allow_floating_pins
    lvs_spice                               yes -allow_duplicate_subcircuit_names
    lvs_spice                               no  -conditional_ldd
    lvs_spice                               no  -prefer_pins
    lvs_spice                               no  -override_globals
    lvs_spice                               no  -redefine_param
    lvs_spice                               no  -replicate_devices
    lvs_spice                               no  -replicate_devices_enhanced
    lvs_spice                               yes -slash_is_space
    lvs_spice                               yes -keep_back_slash
    lvs_spice                               no  -allow_unquoted_strings
    lvs_spice                               no  -allow_inline_parameters
    lvs_spice                               no  -calculate_mos_area
    lvs_spice                               no  -strict_wl
    lvs_spice                               no  -cull_primitive_subcircuits
    lvs_spice                               no  -ignore_option_scale
    lvs_spice                               no  -show_neg_param_warning
    lvs_spice                               no  -scale_x_parameters
    lvs_spice                               yes -strict_subckts_order
    lvs_spice                               no  -ignore_higher_include_for_inst_master
    lvs_spice                               no  -ignore_black_box_connect
    // lvs_spice_option                      
    lvs_reverse_wl                          no
    // lvs_spice_multiplier_name             
                                             
    lvs_compare_case                        no
    lvs_cname                               no  -cell
    lvs_cname                               yes -pin
    lvs_cname                               yes -net
    lvs_cname                               no  -instance
    lvs_non_user_name                       -port "^[0-9]+$"
    lvs_non_user_name                       -net  "^[0-9]+$"
    // lvs_non_user_name                    -instance 
    lvs_out_of_range_exclude_zero           no
    // lvs_group_models                      
    lvs_strict_subtypes                     no
    lvs_exact_subtypes                      no
    lvs_preserve_box_ports                  no
    // lvs_cpoint                            
    // lvs_cell_list                         
    // lvs_device_type                       
    lvs_auto_pin_swap                       yes -swap_threshold 4000000
    lvs_swap_non_cpoint_pins                yes
    // lvs_swap_pins                         
    lvs_all_cap_pins_swappable              no
    lvs_builtin_device_pin_swap             yes
    // lvs_join_nets                         
    lvs_compare_port_names                  no
    lvs_find_shorts                         no
    lvs_global_sigs_are_ports               yes
    lvs_discard_pins                        no
    lvs_break_ambig_max                     32
    lvs_filter                              no  -bipolar
    lvs_filter                              no  -capacitors
    lvs_filter                              no  -diodes
    lvs_filter                              no  -mos
    lvs_filter                              no  -resistors
    // lvs_filter_device                     
    // lvs_filter_device_keep_net            
    lvs_reduction_priority                  -parallel
    lvs_reduce_split_gates                  yes
    lvs_derive_logic                        yes -sram
    lvs_derive_logic                        no  -dram
    lvs_derive_logic                        no  -rom
    lvs_recognize_gates                     -all  
    // lvs_recognize_gates_tolerance         
    lvs_reduce                              yes -parallel_bipolar
    lvs_reduce                              yes -parallel_caps
    lvs_reduce                              yes -series_caps
    lvs_reduce                              yes -parallel_diodes
    lvs_reduce                              no  -series_diodes
    lvs_reduce                              yes -parallel_mos
    lvs_reduce                              no  -series_mos
    lvs_reduce                              yes -parallel_resistors
    lvs_reduce                              yes -series_resistors
    // lvs_reduce_do_not_merge               
    lvs_expand_on_device_climbing           no
    lvs_expand_unbalanced_cells             yes
    // lvs_check_all_properties_by_name      
    // lvs_property_map                      
    // lvs_transfer_property                 
    lvs_report_max                          50 -mismatched_net_limit 100
    lvs_warn_max                            50
    lvs_inconsistent_reduction_threshold    1000000
    // lvs_report_opt                        
    lvs_report_units                        yes
    // lvs_short_equivalent_nodes            
    lvs_keep_data                           no
    lvs_keep_source_cells                   no
    lvs_create_match_db                     no
    unit                                    -resistance ohm
    unit                                    -capacitance pf
    lvs_verilog_bus_map_by_position         no
    lvs_verilog_keep_backslash              no
    lvs_verilog_detect_buses                no
    lvs_do_not_normalize                    no
    // lvs_generic_device                    
    virtual_connect                         no  -colon
    virtual_connect                         yes -semicolon_as_colon
    virtual_connect                         -depth primary
    // virtual_connect                      -name 
    virtual_connect                         no -report
    virtual_connect                         no -incremental
    lvs_preserve_parameterized_cells        no
    lvs_check_color                         no
    // lvs_schematic_color_path              
    // lvs_assign_conflict_layer             
    // lvs_conflict_layer_check             
    lvs_check_color_label                   no
    // lvs_preserve_cells                    
    port                                    -depth -primary
    lvs_high_shorts_max                     10000000

Effective LVS Rule Values
-------------------------

    lvs_swap_non_cpoint_pins                yes -unbound_pin_threshold 10000
    layout_path                             /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath.gds
    layout_primary                          datapath
    schematic_path                          /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/133mhz/signoff/datapath_lvs.cdl
    schematic_primary                       datapath
    lvs_filter_option                       AG RC RE RG -source
    lvs_filter_option                       AG RC RE RG -layout


##############################################################################################################
#
#                                               CELL COMPARISON                                               
#
##############################################################################################################

                              +------------------------------------------------+
                              |                                                |
                              |        ------->>>   MATCH   <<<-------         |
                              |                                                |
                              |            datapath  <vs>  datapath            |
                              |                                                |
                              |                                                |
                              +------------------------------------------------+
                              | * Some sections truncated                      |
                              +------------------------------------------------+

+===[datapath]================================================================================================
|                                                 STATISTICS                                                  
+=============================================================================================================


                  |          Original          |          Filtered          |         Reduced          
Cell              |     lay      :     sch     |     lay      :     sch     |     lay     :    sch
------------------+--------------+-------------+--------------+-------------+-------------+------------
MP [4 pins]       |              :             |              :             |             :            
 MP(G45P1SVT)     |     *137,662 :     123,260 |     *137,662 :     123,260 |       4,749 :       4,749
 MP:ParMos2#1     |            - :           - |            - :           - |       3,869 :       3,869
 MP:ParMos3#1 .  .|.  .  .  .  - :.  .  .  . - |.  .  .  .  - :.  .  .  . - |.  .  .  606 :.  .  .  606
 MP:SerMos2#1     |            - :           - |            - :           - |      11,922 :      11,922
 MP:SerMos3#1 .  .|.  .  .  .  - :.  .  .  . - |.  .  .  .  - :.  .  .  . - |.  .   5,081 :.  .   5,081
MN [4 pins]       |              :             |              :             |             :            
 MN(G45N1SVT) .  .|.  . *137,658 :.  . 123,260 |.  . *137,658 :.  . 123,260 |.  .   4,749 :.  .   4,749
 MN:ParMos2#1     |            - :           - |            - :           - |         606 :         606
 MN:ParMos3#1 .  .|.  .  .  .  - :.  .  .  . - |.  .  .  .  - :.  .  .  . - |.  .  .  606 :.  .  .  606
 MN:SerMos2#1     |            - :           - |            - :           - |      11,922 :      11,922
 MN:SerMos3#1 .  .|.  .  .  .  - :.  .  .  . - |.  .  .  .  - :.  .  .  . - |.  .   5,081 :.  .   5,081
INV##             |            - :           - |            - :           - |      34,161 :      34,161
NAND##2 .  .  .  .|.  .  .  .  - :.  .  .  . - |.  .  .  .  - :.  .  .  . - |.  .   8,057 :.  .   8,057
NAND##3           |            - :           - |            - :           - |         119 :         119
NAND##4 .  .  .  .|.  .  .  .  - :.  .  .  . - |.  .  .  .  - :.  .  .  . - |.  .  .  296 :.  .  .  296
NOR##2            |            - :           - |            - :           - |       3,520 :       3,520
NOR##3  .  .  .  .|.  .  .  .  - :.  .  .  . - |.  .  .  .  - :.  .  .  . - |.  .  .  121 :.  .  .  121
NOR##4            |            - :           - |            - :           - |         155 :         155
OR##2   .  .  .  .|.  .  .  .  - :.  .  .  . - |.  .  .  .  - :.  .  .  . - |.  .   2,052 :.  .   2,052
OR##3             |            - :           - |            - :           - |          22 :          22
AND##2  .  .  .  .|.  .  .  .  - :.  .  .  . - |.  .  .  .  - :.  .  .  . - |.  .   6,467 :.  .   6,467
AND##3            |            - :           - |            - :           - |          20 :          20
OAI##2  .  .  .  .|.  .  .  .  - :.  .  .  . - |.  .  .  .  - :.  .  .  . - |.  .   1,090 :.  .   1,090
OAI##3            |            - :           - |            - :           - |         278 :         278
AOI##2            |            - :           - |            - :           - |       3,222 :       3,222
AOI##3            |            - :           - |            - :           - |         306 :         306
------------------+--------------+-------------+--------------+-------------+-------------+------------
Total             |      275,320 :     246,520 |      275,320 :     246,520 |     109,077 :     109,077
==================+==============+=============+==============+=============+=============+============
Pins              |              :             |              :             |         232 :         232
Nets              |              :             |              :             |      63,564 :      63,564
==================+==============+=============+==============+=============+=============+============

+===[datapath]================================================================================================
|                                      DEVICES REMOVED DURING REDUCTION                                       
+=============================================================================================================


                  |       Parallel       |      Series       |     Split Gate      |     Deleted Nets     
Cell              |    lay     :   sch   |   lay   :   sch   |    lay    :   sch   |    lay     :   sch
------------------+------------+---------+---------+---------+-----------+---------+------------+---------
MP [4 pins]       |            :         |         :         |           :         |            :         
 MP(G45P1SVT)     |     12,739 :       - |       - :       - |     1,663 :       - |        893 :        0
MN [4 pins]       |            :         |         :         |           :         |            :         
 MN(G45N1SVT)     |     11,218 :       - |       - :       - |     3,180 :       - |      1,779 :        0
------------------+------------+---------+---------+---------+-----------+---------+------------+---------

+===[datapath]================================================================================================
|                                           INITIAL CORRESPONDENCES                                           
+====================================================================================================truncated

Type | Name
-----+--------------------------------------------------------------------------------------------------------
Pin  | c_pc_f[0] c_pc_f[10] c_pc_f[11] c_pc_f[12] c_pc_f[13] c_pc_f[14] c_pc_f[15] c_pc_f[16] c_pc_f[17]
     | c_pc_f[18] c_pc_f[19] c_pc_f[1] c_pc_f[20] c_pc_f[21] c_pc_f[22] c_pc_f[23] c_pc_f[24] c_pc_f[25]
     | c_pc_f[26] c_pc_f[27] c_pc_f[28] c_pc_f[29] c_pc_f[2] c_pc_f[30] c_pc_f[31] c_pc_f[3] c_pc_f[4]
     | c_pc_f[5] c_pc_f[6] c_pc_f[7] c_pc_f[8] c_pc_f[9] clk d_load_dmem[0] d_load_dmem[10] d_load_dmem[11]
     | d_load_dmem[12] d_load_dmem[13] d_load_dmem[14] d_load_dmem[15] d_load_dmem[16] d_load_dmem[17]
     | d_load_dmem[18] d_load_dmem[19] d_load_dmem[1] d_load_dmem[20] d_load_dmem[21] d_load_dmem[22]
     | d_load_dmem[23] d_load_dmem[24]


++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++ Section truncated to 50 issues, adjust this using the lvs_report_max rule +++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


##############################################################################################################
#
#                                                END OF REPORT                                                
#
##############################################################################################################

