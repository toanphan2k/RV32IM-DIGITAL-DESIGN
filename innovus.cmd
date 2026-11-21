#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Sat Nov 21 10:58:47 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v21.19-s058_1 (64bit) 04/04/2024 09:59 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 21.19-s058_1 NR231113-0413/21_19-UB (database version 18.20.605) {superthreading v2.17}
#@(#)CDS: AAE 21.19-s004 (64bit) 04/04/2024 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 21.19-s010_1 () Mar 27 2024 01:55:37 ( )
#@(#)CDS: SYNTECH 21.19-s002_1 () Sep  6 2023 22:17:00 ( )
#@(#)CDS: CPE v21.19-s026
#@(#)CDS: IQuantus/TQuantus 21.1.1-s966 (64bit) Wed Mar 8 10:22:20 PST 2023 (Linux 3.10.0-693.el7.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
set init_lef_file {/tools/eda/pdks/cadence/gpdk045/gsclib045_svt_v4.7/gsclib045_tech/lef/gsclib045_tech.lef /tools/eda/pdks/cadence/gpdk045/gsclib045_svt_v4.7/gsclib045/lef/gsclib045_macro.lef}
set init_verilog /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/genus/datapath_mapped.v
set init_top_cell datapath
set init_pwr_net VDD
set init_gnd_net VSS
set init_mmmc_file /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/scripts/mmmc.tcl
init_design
setDesignMode -process 45
setMultiCpuUsage -localCpu 2
set_dont_use [get_lib_cells */$cell]
setAnalysisMode -analysisType onChipVariation -cppr both
setPlaceMode -place_global_ignore_scan true
floorPlan -site CoreSite -r 1.0 0.65 10.0 10.0 10.0 10.0
setPinAssignMode -pinEditInBatch true
editPin -pin {clk rst_n c_pc_f[31] c_pc_f[30] c_pc_f[29] c_pc_f[28] c_pc_f[27] c_pc_f[26] c_pc_f[25] c_pc_f[24] c_pc_f[23] c_pc_f[22] c_pc_f[21] c_pc_f[20] c_pc_f[19] c_pc_f[18] c_pc_f[17] c_pc_f[16] c_pc_f[15] c_pc_f[14] c_pc_f[13] c_pc_f[12] c_pc_f[11] c_pc_f[10] c_pc_f[9] c_pc_f[8] c_pc_f[7] c_pc_f[6] c_pc_f[5] c_pc_f[4] c_pc_f[3] c_pc_f[2] c_pc_f[1] c_pc_f[0] f_inst[31] f_inst[30] f_inst[29] f_inst[28] f_inst[27] f_inst[26] f_inst[25] f_inst[24] f_inst[23] f_inst[22] f_inst[21] f_inst[20] f_inst[19] f_inst[18] f_inst[17] f_inst[16] f_inst[15] f_inst[14] f_inst[13] f_inst[12] f_inst[11] f_inst[10] f_inst[9] f_inst[8] f_inst[7] f_inst[6] f_inst[5] f_inst[4] f_inst[3] f_inst[2] f_inst[1] f_inst[0]} -side LEFT -layer Metal3 -spreadType SIDE -fixOverlap 1 -fixedPin 1
editPin -pin {store_addr_dmem[31] store_addr_dmem[30] store_addr_dmem[29] store_addr_dmem[28] store_addr_dmem[27] store_addr_dmem[26] store_addr_dmem[25] store_addr_dmem[24] store_addr_dmem[23] store_addr_dmem[22] store_addr_dmem[21] store_addr_dmem[20] store_addr_dmem[19] store_addr_dmem[18] store_addr_dmem[17] store_addr_dmem[16] store_addr_dmem[15] store_addr_dmem[14] store_addr_dmem[13] store_addr_dmem[12] store_addr_dmem[11] store_addr_dmem[10] store_addr_dmem[9] store_addr_dmem[8] store_addr_dmem[7] store_addr_dmem[6] store_addr_dmem[5] store_addr_dmem[4] store_addr_dmem[3] store_addr_dmem[2] store_addr_dmem[1] store_addr_dmem[0] store_we_dmem[3] store_we_dmem[2] store_we_dmem[1] store_we_dmem[0] d_store_dmem_m[31] d_store_dmem_m[30] d_store_dmem_m[29] d_store_dmem_m[28] d_store_dmem_m[27] d_store_dmem_m[26] d_store_dmem_m[25] d_store_dmem_m[24] d_store_dmem_m[23] d_store_dmem_m[22] d_store_dmem_m[21] d_store_dmem_m[20] d_store_dmem_m[19] d_store_dmem_m[18] d_store_dmem_m[17] d_store_dmem_m[16] d_store_dmem_m[15] d_store_dmem_m[14] d_store_dmem_m[13] d_store_dmem_m[12] d_store_dmem_m[11] d_store_dmem_m[10] d_store_dmem_m[9] d_store_dmem_m[8] d_store_dmem_m[7] d_store_dmem_m[6] d_store_dmem_m[5] d_store_dmem_m[4] d_store_dmem_m[3] d_store_dmem_m[2] d_store_dmem_m[1] d_store_dmem_m[0] d_load_dmem[31] d_load_dmem[30] d_load_dmem[29] d_load_dmem[28] d_load_dmem[27] d_load_dmem[26] d_load_dmem[25] d_load_dmem[24] d_load_dmem[23] d_load_dmem[22] d_load_dmem[21] d_load_dmem[20] d_load_dmem[19] d_load_dmem[18] d_load_dmem[17] d_load_dmem[16] d_load_dmem[15] d_load_dmem[14] d_load_dmem[13] d_load_dmem[12] d_load_dmem[11] d_load_dmem[10] d_load_dmem[9] d_load_dmem[8] d_load_dmem[7] d_load_dmem[6] d_load_dmem[5] d_load_dmem[4] d_load_dmem[3] d_load_dmem[2] d_load_dmem[1] d_load_dmem[0]} -side RIGHT -layer Metal3 -spreadType SIDE -fixOverlap 1 -fixedPin 1
editPin -pin {trace_pc[31] trace_pc[30] trace_pc[29] trace_pc[28] trace_pc[27] trace_pc[26] trace_pc[25] trace_pc[24] trace_pc[23] trace_pc[22] trace_pc[21] trace_pc[20] trace_pc[19] trace_pc[18] trace_pc[17] trace_pc[16] trace_pc[15] trace_pc[14] trace_pc[13] trace_pc[12] trace_pc[11] trace_pc[10] trace_pc[9] trace_pc[8] trace_pc[7] trace_pc[6] trace_pc[5] trace_pc[4] trace_pc[3] trace_pc[2] trace_pc[1] trace_pc[0] trace_inst[31] trace_inst[30] trace_inst[29] trace_inst[28] trace_inst[27] trace_inst[26] trace_inst[25] trace_inst[24] trace_inst[23] trace_inst[22] trace_inst[21] trace_inst[20] trace_inst[19] trace_inst[18] trace_inst[17] trace_inst[16] trace_inst[15] trace_inst[14] trace_inst[13] trace_inst[12] trace_inst[11] trace_inst[10] trace_inst[9] trace_inst[8] trace_inst[7] trace_inst[6] trace_inst[5] trace_inst[4] trace_inst[3] trace_inst[2] trace_inst[1] trace_inst[0]} -side BOTTOM -layer Metal4 -spreadType SIDE -fixOverlap 1 -fixedPin 1
setPinAssignMode -pinEditInBatch false
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -override
globalNetConnect VSS -type pgpin -pin VSS -inst * -override
globalNetConnect VDD -type tiehi -inst * -override
globalNetConnect VSS -type tielo -inst * -override
globalNetConnect VDD -type net -net VDD -override
globalNetConnect VSS -type net -net VSS -override
addRing -nets {VDD VSS} -type core_rings -follow core -layer {top Metal7 bottom Metal7 left Metal6 right Metal6} -width 2.0 -spacing 1.0 -offset 1.0
addStripe -nets {VDD VSS} -layer Metal6 -direction vertical -width 2.0 -spacing 1.0 -set_to_set_distance 40.0 -start_from left -start_offset 10.0
sroute -connect {corePin floatingStripe} -layerChangeRange {Metal1 Metal7} -nets {VDD VSS} -allowJogging 1 -allowLayerChange 1
verifyPowerVia -report /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/power_via.rpt
getPlaceMode -place_hierarchical_flow -quiet
report_message -start_cmd
getRouteMode -maxRouteLayer -quiet
getRouteMode -user -maxRouteLayer
getPlaceMode -place_global_place_io_pins -quiet
getPlaceMode -user -maxRouteLayer
getPlaceMode -quiet -adaptiveFlowMode
getPlaceMode -timingDriven -quiet
getPlaceMode -adaptive -quiet
getPlaceMode -relaxSoftBlockageMode -quiet
getPlaceMode -user -relaxSoftBlockageMode
getPlaceMode -ignoreScan -quiet
getPlaceMode -user -ignoreScan
getPlaceMode -repairPlace -quiet
getPlaceMode -user -repairPlace
getPlaceMode -inPlaceOptMode -quiet
getPlaceMode -quiet -bypassFlowEffortHighChecking
getDesignMode -quiet -siPrevention
getPlaceMode -quiet -place_global_exp_enable_3d
getPlaceMode -exp_slack_driven -quiet
um::push_snapshot_stack
getDesignMode -quiet -flowEffort
getDesignMode -highSpeedCore -quiet
getPlaceMode -quiet -adaptive
set spgFlowInInitialPlace 1
getPlaceMode -sdpAlignment -quiet
getPlaceMode -softGuide -quiet
getPlaceMode -useSdpGroup -quiet
getPlaceMode -sdpAlignment -quiet
getPlaceMode -enableDbSaveAreaPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
getPlaceMode -sdpPlace -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -sdpPlace -quiet
getPlaceMode -groupHighLevelClkGate -quiet
setvar spgRptErrorForScanConnection 0
getPlaceMode -place_global_exp_allow_missing_scan_chain -quiet
getPlaceMode -ignoreScan -quiet
setvar spgRptErrorForScanConnection 1
getPlaceMode -place_design_floorplan_mode -quiet
getPlaceMode -place_global_timing_effort -quiet
getPlaceMode -place_check_library -quiet
getPlaceMode -trimView -quiet
getPlaceMode -expTrimOptBeforeTDGP -quiet
getPlaceMode -quiet -useNonTimingDeleteBufferTree
getPlaceMode -congEffort -quiet
getPlaceMode -relaxSoftBlockageMode -quiet
getPlaceMode -user -relaxSoftBlockageMode
getPlaceMode -ignoreScan -quiet
getPlaceMode -user -ignoreScan
getPlaceMode -repairPlace -quiet
getPlaceMode -user -repairPlace
getPlaceMode -congEffort -quiet
getPlaceMode -fp -quiet
getPlaceMode -timingDriven -quiet
getPlaceMode -user -timingDriven
getPlaceMode -fastFp -quiet
getPlaceMode -clusterMode -quiet
get_proto_model -type_match {flex_module flex_instgroup} -committed -name -tcl
getPlaceMode -inPlaceOptMode -quiet
getPlaceMode -quiet -bypassFlowEffortHighChecking
getPlaceMode -ultraCongEffortFlow -quiet
getPlaceMode -forceTiming -quiet
getPlaceMode -fp -quiet
getPlaceMode -fastfp -quiet
getPlaceMode -timingDriven -quiet
getPlaceMode -fp -quiet
getPlaceMode -fastfp -quiet
getPlaceMode -powerDriven -quiet
getExtractRCMode -quiet -engine
getAnalysisMode -quiet -clkSrcPath
getAnalysisMode -quiet -clockPropagation
getAnalysisMode -quiet -cppr
setExtractRCMode -engine preRoute
setAnalysisMode -clkSrcPath false -clockPropagation forcedIdeal
getPlaceMode -exp_slack_driven -quiet
isAnalysisModeSetup
getPlaceMode -quiet -place_global_exp_solve_unbalance_path
getPlaceMode -quiet -NMPsuppressInfo
getPlaceMode -quiet -place_global_exp_wns_focus_v2
getPlaceMode -quiet -place_incr_exp_isolation_flow
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -clusterMode
getPlaceMode -wl_budget_mode -quiet
setPlaceMode -reset -place_global_exp_balance_buffer_chain
getPlaceMode -wl_budget_mode -quiet
setPlaceMode -reset -place_global_exp_balance_pipeline
getPlaceMode -place_global_exp_balance_buffer_chain -quiet
getPlaceMode -place_global_exp_balance_pipeline -quiet
getPlaceMode -tdgpMemFlow -quiet
getPlaceMode -user -resetCombineRFLevel
getPlaceMode -quiet -resetCombineRFLevel
setPlaceMode -resetCombineRFLevel 1000
setvar spgSpeedupBuildVSM 1
getPlaceMode -tdgpResetCteTG -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -place_global_replace_QP -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -place_global_ignore_spare -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -expNewFastMode
setPlaceMode -expHiddenFastMode 1
setPlaceMode -ignoreScan 1
getPlaceMode -quiet -place_global_exp_auto_finish_floorplan
getPlaceMode -quiet -IOSlackAdjust
getPlaceMode -tdgpCteZeroDelayModeDelBuf -quiet
set_global timing_enable_zero_delay_analysis_mode true
getPlaceMode -quiet -useNonTimingDeleteBufferTree
getPlaceMode -quiet -prePlaceOptSimplifyNetlist
getPlaceMode -quiet -enablePrePlaceOptimizations
getPlaceMode -quiet -prePlaceOptDecloneInv
deleteBufferTree -decloneInv
getPlaceMode -tdgpCteZeroDelayModeDelBuf -quiet
set_global timing_enable_zero_delay_analysis_mode false
getAnalysisMode -quiet -honorClockDomains
getPlaceMode -honorUserPathGroup -quiet
getAnalysisMode -quiet -honorClockDomains
set delaycal_use_default_delay_limit 101
set delaycal_default_net_delay 0
set delaycal_default_net_load 0
set delaycal_default_net_load_ignore_for_ilm 0
set delaycal_input_transition_delay 1ps
getAnalysisMode -clkSrcPath -quiet
getAnalysisMode -clockPropagation -quiet
getAnalysisMode -checkType -quiet
buildTimingGraph
getDelayCalMode -ignoreNetLoad -quiet
getDelayCalMode -ignoreNetLoad -quiet
setDelayCalMode -ignoreNetLoad true -quiet
get_global timing_enable_path_group_priority
get_global timing_constraint_enable_group_path_resetting
set_global timing_enable_path_group_priority false
set_global timing_constraint_enable_group_path_resetting false
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2reg_tmp.2754774 -from {0x488 0x48b} -to 0x48c -ignore_source_of_trigger_arc
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2out_tmp.2754774 -from {0x491 0x494} -to 0x495 -ignore_source_of_trigger_arc
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2reg_tmp.2754774 -from 0x499 -to 0x49c
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2out_tmp.2754774 -from 0x4a3 -to 0x4a6
set_global _is_ipo_interactive_path_groups 1
group_path -name clkgate_tmp.2754774 -to 0x4a8
setPathGroupOptions reg2reg_tmp.2754774 -effortLevel high
get_capacitance_unit
isAnalysisModeSetup
getAnalysisMode -analysisType -quiet
isAnalysisModeSetup
all_setup_analysis_views
all_hold_analysis_views
get_analysis_view $view -delay_corner
get_delay_corner $dcCorner -power_domain_list
get_delay_corner $dcCorner -library_set
get_library_set $libSetName -si
get_delay_corner $dcCorner -late_library_set
get_delay_corner $dcCorner -early_library_set
get_analysis_view $view -delay_corner
get_delay_corner $dcCorner -power_domain_list
get_delay_corner $dcCorner -library_set
get_library_set $libSetName -si
get_delay_corner $dcCorner -late_library_set
get_delay_corner $dcCorner -early_library_set
reset_path_group -name reg2out_tmp.2754774
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name in2reg_tmp.2754774
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name in2out_tmp.2754774
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name clkgate_tmp.2754774
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name reg2reg_tmp.2754774
set_global _is_ipo_interactive_path_groups 0
setDelayCalMode -ignoreNetLoad false
set delaycal_use_default_delay_limit 1000
set delaycal_default_net_delay 1000ps
set delaycal_input_transition_delay 0ps
set delaycal_default_net_load 0.5pf
set delaycal_default_net_load_ignore_for_ilm 0
all_setup_analysis_views
getPlaceMode -place_global_exp_ignore_low_effort_path_groups -quiet
getPlaceMode -exp_slack_driven -quiet
getAnalysisMode -quiet -honorClockDomains
getPlaceMode -quiet -place_global_exp_inverter_rewiring
getPlaceMode -ignoreUnproperPowerInit -quiet
getPlaceMode -quiet -expSkipGP
setDelayCalMode -engine feDc
createBasicPathGroups -quiet
psp::embedded_egr_init_
psp::embedded_egr_term_
psp::embedded_egr_init_
psp::embedded_egr_term_
psp::embedded_egr_init_
psp::embedded_egr_term_
reset_path_group
set_global _is_ipo_interactive_path_groups 0
scanReorder
setDelayCalMode -engine aae
all_setup_analysis_views
getPlaceMode -exp_slack_driven -quiet
set_global timing_enable_path_group_priority $gpsPrivate::optSave_ctePGPriority
set_global timing_constraint_enable_group_path_resetting $gpsPrivate::optSave_ctePGResetting
getPlaceMode -quiet -tdgpAdjustNetWeightBySlack
get_ccopt_clock_trees *
getPlaceMode -exp_insert_guidance_clock_tree -quiet
getPlaceMode -exp_cluster_based_high_fanout_buffering -quiet
getPlaceMode -place_global_exp_incr_skp_preserve_mode_v2 -quiet
getPlaceMode -quiet -place_global_exp_netlist_balance_flow
getPlaceMode -quiet -timingEffort
getAnalysisMode -quiet -honorClockDomains
getPlaceMode -honorUserPathGroup -quiet
getAnalysisMode -quiet -honorClockDomains
set delaycal_use_default_delay_limit 101
set delaycal_default_net_delay 0
set delaycal_default_net_load 0
set delaycal_default_net_load_ignore_for_ilm 0
getAnalysisMode -clkSrcPath -quiet
getAnalysisMode -clockPropagation -quiet
getAnalysisMode -checkType -quiet
buildTimingGraph
getDelayCalMode -ignoreNetLoad -quiet
getDelayCalMode -ignoreNetLoad -quiet
setDelayCalMode -ignoreNetLoad true -quiet
get_global timing_enable_path_group_priority
get_global timing_constraint_enable_group_path_resetting
set_global timing_enable_path_group_priority false
set_global timing_constraint_enable_group_path_resetting false
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2reg_tmp.2754774 -from {0x4c6 0x4c9} -to 0x4ca -ignore_source_of_trigger_arc
getOptMode -allowPreCTSClkSrcPaths -quiet
set_global _is_ipo_interactive_path_groups 1
group_path -name in2out_tmp.2754774 -from {0x4cf 0x4d2} -to 0x4d3 -ignore_source_of_trigger_arc
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2reg_tmp.2754774 -from 0x4d7 -to 0x4da
set_global _is_ipo_interactive_path_groups 1
group_path -name reg2out_tmp.2754774 -from 0x4e1 -to 0x4e4
set_global _is_ipo_interactive_path_groups 1
group_path -name clkgate_tmp.2754774 -to 0x4e6
setPathGroupOptions reg2reg_tmp.2754774 -effortLevel high
reset_path_group -name reg2out_tmp.2754774
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name in2reg_tmp.2754774
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name in2out_tmp.2754774
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name clkgate_tmp.2754774
set_global _is_ipo_interactive_path_groups 0
reset_path_group -name reg2reg_tmp.2754774
set_global _is_ipo_interactive_path_groups 0
setDelayCalMode -ignoreNetLoad false
set delaycal_use_default_delay_limit 1000
set delaycal_default_net_delay 1000ps
set delaycal_default_net_load 0.5pf
set delaycal_default_net_load_ignore_for_ilm 0
all_setup_analysis_views
getPlaceMode -place_global_exp_ignore_low_effort_path_groups -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -quiet -cong_repair_commit_clock_net_route_attr
getPlaceMode -enableDbSaveAreaPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
setPlaceMode -reset -improveWithPsp
getPlaceMode -quiet -debugGlobalPlace
getPlaceMode -congRepair -quiet
getPlaceMode -fp -quiet
getPlaceMode -user -rplaceIncrNPClkGateAwareMode
getPlaceMode -user -congRepairMaxIter
getPlaceMode -quiet -congRepairPDClkGateMode4
setPlaceMode -rplaceIncrNPClkGateAwareMode 4
getPlaceMode -quiet -expCongRepairPDOneLoop
setPlaceMode -congRepairMaxIter 1
getPlaceMode -quickCTS -quiet
get_proto_model -type_match {flex_module flex_instgroup} -committed -name -tcl
getPlaceMode -congRepairForceTrialRoute -quiet
getPlaceMode -user -congRepairForceTrialRoute
setPlaceMode -congRepairForceTrialRoute true
::goMC::is_advanced_metrics_collection_running
congRepair
::goMC::is_advanced_metrics_collection_running
::goMC::is_advanced_metrics_collection_running
::goMC::is_advanced_metrics_collection_running
setPlaceMode -reset -congRepairForceTrialRoute
getPlaceMode -quiet -congRepairPDClkGateMode4
setPlaceMode -reset -rplaceIncrNPClkGateAwareMode
setPlaceMode -reset -congRepairMaxIter
getPlaceMode -congRepairCleanupPadding -quiet
getPlaceMode -quiet -wireLenOptEffort
all_setup_analysis_views
getPlaceMode -exp_slack_driven -quiet
set_global timing_enable_path_group_priority $gpsPrivate::optSave_ctePGPriority
set_global timing_constraint_enable_group_path_resetting $gpsPrivate::optSave_ctePGResetting
getPlaceMode -place_global_exp_incr_skp_preserve_mode_v2 -quiet
getPlaceMode -quiet -place_global_exp_netlist_balance_flow
getPlaceMode -quiet -timingEffort
getPlaceMode -tdgpDumpStageTiming -quiet
getPlaceMode -quiet -tdgpAdjustNetWeightBySlack
setvar spgRptErrorForScanConnection 0
getPlaceMode -trimView -quiet
getOptMode -quiet -viewOptPolishing
getOptMode -quiet -fastViewOpt
spInternalUse deleteViewOptManager
spInternalUse tdgp clearSkpData
setAnalysisMode -clkSrcPath true -clockPropagation sdcControl
getPlaceMode -exp_slack_driven -quiet
setExtractRCMode -engine preRoute
setPlaceMode -reset -relaxSoftBlockageMode
setPlaceMode -ignoreScan true -quiet
setPlaceMode -reset -repairPlace
getPlaceMode -quiet -NMPsuppressInfo
setvar spgSpeedupBuildVSM 0
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -place_global_replace_QP -quiet
getPlaceMode -macroPlaceMode -quiet
getPlaceMode -exp_slack_driven -quiet
getPlaceMode -enableDistPlace -quiet
getPlaceMode -place_global_ignore_spare -quiet
getPlaceMode -tdgpMemFlow -quiet
setPlaceMode -reset -resetCombineRFLevel
getPlaceMode -enableDistPlace -quiet
getPlaceMode -quiet -clusterMode
getPlaceMode -quiet -place_global_exp_solve_unbalance_path
getPlaceMode -enableDistPlace -quiet
setPlaceMode -reset -expHiddenFastMode
getPlaceMode -tcg2Pass -quiet
getPlaceMode -quiet -wireLenOptEffort
getPlaceMode -fp -quiet
getPlaceMode -fastfp -quiet
getPlaceMode -doRPlace -quiet
getPlaceMode -RTCPlaceDesignFlow -quiet
getPlaceMode -quickCTS -quiet
set spgFlowInInitialPlace 0
getPlaceMode -user -maxRouteLayer
spInternalUse TDGP resetIgnoreNetLoad
getPlaceMode -place_global_exp_balance_pipeline -quiet
getDesignMode -quiet -flowEffort
report_message -end_cmd
um::create_snapshot -name final -auto min
um::pop_snapshot_stack
um::create_snapshot -name place_design
getPlaceMode -exp_slack_driven -quiet
setTieHiLoMode -cell {TIEHI TIELO} -maxFanout 10 -maxDistance 100
addTieHiLo -cell {TIEHI TIELO} -prefix TIE
optDesign -preCTS
set_ccopt_property buffer_cells {CLKBUFX2 CLKBUFX3 CLKBUFX4 CLKBUFX6 CLKBUFX8 CLKBUFX12 CLKBUFX16 CLKBUFX20}
set_ccopt_property inverter_cells {CLKINVX1 CLKINVX2 CLKINVX3 CLKINVX4 CLKINVX6 CLKINVX8 CLKINVX12 CLKINVX16 CLKINVX20}
ccopt_design
report_ccopt_clock_trees -file /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/cts_trees.rpt
report_ccopt_skew_groups -file /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/cts_skew.rpt
optDesign -postCTS
optDesign -postCTS -hold
setNanoRouteMode -routeWithTimingDriven true
setNanoRouteMode -routeWithSiDriven true
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -droutePostRouteSwapVia multiCut
setNanoRouteMode -routeInsertAntennaDiode true
setNanoRouteMode -routeAntennaCellName ANTENNA
routeDesign -globalDetail
setExtractRCMode -engine postRoute -effortLevel medium
setDelayCalMode -SIAware true
extractRC
optDesign -postRoute
optDesign -postRoute -hold
extractRC
addFiller -cell {DECAP10 DECAP9 DECAP8 DECAP7 DECAP6 DECAP5 DECAP4 DECAP3 DECAP2 FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1} -prefix FILLER -fitGap
timeDesign -postRoute -outDir /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/postRoute
timeDesign -postRoute -hold -outDir /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/postRoute
checkPlace /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/check_place.rpt
verify_drc -report /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/drc.rpt
verify_connectivity -type all -report /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/connectivity.rpt
verifyProcessAntenna -report /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/antenna.rpt
report_area > /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/area.rpt
report_power > /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/power.rpt
report_timing -late > [file join $INNOVUS_OUTPUT_DIR timing_setup.rpt]
report_timing -early > [file join $INNOVUS_OUTPUT_DIR timing_hold.rpt]
rcOut -spef /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/datapath_slow.spef -rc_corner rc_slow
rcOut -spef /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/datapath_fast.spef -rc_corner rc_fast
write_sdf -view func_slow_view [file join $INNOVUS_OUTPUT_DIR ${TOP}.sdf]
defOut -floorplan -netlist -routing /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/datapath.def
saveNetlist /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/datapath_pnr.v
saveDesign /home/yellow/ee5303_05/risc-v-ws/RV32IM-DIGITAL-DESIGN/output/innovus/datapath_final.enc
