# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.19-s055_1 on Sun Nov 22 17:30:02 +07 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design datapath

create_clock -name "clk" -period 7.5 -waveform {0.0 3.75} [get_ports clk]
set_clock_transition 0.1 [get_clocks clk]
set_load -pin_load 0.05 [get_ports {c_pc_f[31]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[30]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[29]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[28]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[27]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[26]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[25]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[24]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[23]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[22]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[21]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[20]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[19]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[18]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[17]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[16]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[15]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[14]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[13]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[12]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[11]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[10]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[9]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[8]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[7]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[6]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[5]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[4]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[3]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[2]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[1]}]
set_load -pin_load 0.05 [get_ports {c_pc_f[0]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[31]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[30]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[29]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[28]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[27]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[26]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[25]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[24]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[23]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[22]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[21]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[20]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[19]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[18]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[17]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[16]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[15]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[14]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[13]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[12]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[11]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[10]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[9]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[8]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[7]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[6]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[5]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[4]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[3]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[2]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[1]}]
set_load -pin_load 0.05 [get_ports {store_addr_dmem[0]}]
set_load -pin_load 0.05 [get_ports {store_we_dmem[3]}]
set_load -pin_load 0.05 [get_ports {store_we_dmem[2]}]
set_load -pin_load 0.05 [get_ports {store_we_dmem[1]}]
set_load -pin_load 0.05 [get_ports {store_we_dmem[0]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[31]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[30]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[29]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[28]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[27]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[26]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[25]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[24]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[23]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[22]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[21]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[20]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[19]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[18]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[17]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[16]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[15]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[14]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[13]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[12]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[11]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[10]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[9]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[8]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[7]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[6]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[5]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[4]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[3]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[2]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[1]}]
set_load -pin_load 0.05 [get_ports {d_store_dmem_m[0]}]
set_load -pin_load 0.05 [get_ports {trace_pc[31]}]
set_load -pin_load 0.05 [get_ports {trace_pc[30]}]
set_load -pin_load 0.05 [get_ports {trace_pc[29]}]
set_load -pin_load 0.05 [get_ports {trace_pc[28]}]
set_load -pin_load 0.05 [get_ports {trace_pc[27]}]
set_load -pin_load 0.05 [get_ports {trace_pc[26]}]
set_load -pin_load 0.05 [get_ports {trace_pc[25]}]
set_load -pin_load 0.05 [get_ports {trace_pc[24]}]
set_load -pin_load 0.05 [get_ports {trace_pc[23]}]
set_load -pin_load 0.05 [get_ports {trace_pc[22]}]
set_load -pin_load 0.05 [get_ports {trace_pc[21]}]
set_load -pin_load 0.05 [get_ports {trace_pc[20]}]
set_load -pin_load 0.05 [get_ports {trace_pc[19]}]
set_load -pin_load 0.05 [get_ports {trace_pc[18]}]
set_load -pin_load 0.05 [get_ports {trace_pc[17]}]
set_load -pin_load 0.05 [get_ports {trace_pc[16]}]
set_load -pin_load 0.05 [get_ports {trace_pc[15]}]
set_load -pin_load 0.05 [get_ports {trace_pc[14]}]
set_load -pin_load 0.05 [get_ports {trace_pc[13]}]
set_load -pin_load 0.05 [get_ports {trace_pc[12]}]
set_load -pin_load 0.05 [get_ports {trace_pc[11]}]
set_load -pin_load 0.05 [get_ports {trace_pc[10]}]
set_load -pin_load 0.05 [get_ports {trace_pc[9]}]
set_load -pin_load 0.05 [get_ports {trace_pc[8]}]
set_load -pin_load 0.05 [get_ports {trace_pc[7]}]
set_load -pin_load 0.05 [get_ports {trace_pc[6]}]
set_load -pin_load 0.05 [get_ports {trace_pc[5]}]
set_load -pin_load 0.05 [get_ports {trace_pc[4]}]
set_load -pin_load 0.05 [get_ports {trace_pc[3]}]
set_load -pin_load 0.05 [get_ports {trace_pc[2]}]
set_load -pin_load 0.05 [get_ports {trace_pc[1]}]
set_load -pin_load 0.05 [get_ports {trace_pc[0]}]
set_load -pin_load 0.05 [get_ports {trace_inst[31]}]
set_load -pin_load 0.05 [get_ports {trace_inst[30]}]
set_load -pin_load 0.05 [get_ports {trace_inst[29]}]
set_load -pin_load 0.05 [get_ports {trace_inst[28]}]
set_load -pin_load 0.05 [get_ports {trace_inst[27]}]
set_load -pin_load 0.05 [get_ports {trace_inst[26]}]
set_load -pin_load 0.05 [get_ports {trace_inst[25]}]
set_load -pin_load 0.05 [get_ports {trace_inst[24]}]
set_load -pin_load 0.05 [get_ports {trace_inst[23]}]
set_load -pin_load 0.05 [get_ports {trace_inst[22]}]
set_load -pin_load 0.05 [get_ports {trace_inst[21]}]
set_load -pin_load 0.05 [get_ports {trace_inst[20]}]
set_load -pin_load 0.05 [get_ports {trace_inst[19]}]
set_load -pin_load 0.05 [get_ports {trace_inst[18]}]
set_load -pin_load 0.05 [get_ports {trace_inst[17]}]
set_load -pin_load 0.05 [get_ports {trace_inst[16]}]
set_load -pin_load 0.05 [get_ports {trace_inst[15]}]
set_load -pin_load 0.05 [get_ports {trace_inst[14]}]
set_load -pin_load 0.05 [get_ports {trace_inst[13]}]
set_load -pin_load 0.05 [get_ports {trace_inst[12]}]
set_load -pin_load 0.05 [get_ports {trace_inst[11]}]
set_load -pin_load 0.05 [get_ports {trace_inst[10]}]
set_load -pin_load 0.05 [get_ports {trace_inst[9]}]
set_load -pin_load 0.05 [get_ports {trace_inst[8]}]
set_load -pin_load 0.05 [get_ports {trace_inst[7]}]
set_load -pin_load 0.05 [get_ports {trace_inst[6]}]
set_load -pin_load 0.05 [get_ports {trace_inst[5]}]
set_load -pin_load 0.05 [get_ports {trace_inst[4]}]
set_load -pin_load 0.05 [get_ports {trace_inst[3]}]
set_load -pin_load 0.05 [get_ports {trace_inst[2]}]
set_load -pin_load 0.05 [get_ports {trace_inst[1]}]
set_load -pin_load 0.05 [get_ports {trace_inst[0]}]
set_false_path -from [get_ports rst_n]
group_path -weight 1.000000 -name cg_enable_group_clk -through [list \
  [get_pins RC_CG_HIER_INST0/enable]  \
  [get_pins RC_CG_HIER_INST0/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST1/enable]  \
  [get_pins RC_CG_HIER_INST1/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST2/enable]  \
  [get_pins RC_CG_HIER_INST2/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST3/enable]  \
  [get_pins RC_CG_HIER_INST3/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST4/enable]  \
  [get_pins RC_CG_HIER_INST4/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST5/enable]  \
  [get_pins RC_CG_HIER_INST5/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST6/enable]  \
  [get_pins RC_CG_HIER_INST6/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST7/enable]  \
  [get_pins RC_CG_HIER_INST7/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST8/enable]  \
  [get_pins RC_CG_HIER_INST8/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST9/enable]  \
  [get_pins RC_CG_HIER_INST9/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST10/enable]  \
  [get_pins RC_CG_HIER_INST10/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST11/enable]  \
  [get_pins RC_CG_HIER_INST11/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST12/enable]  \
  [get_pins RC_CG_HIER_INST12/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST13/enable]  \
  [get_pins RC_CG_HIER_INST13/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST14/enable]  \
  [get_pins RC_CG_HIER_INST14/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST15/enable]  \
  [get_pins RC_CG_HIER_INST15/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST16/enable]  \
  [get_pins RC_CG_HIER_INST16/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST17/enable]  \
  [get_pins RC_CG_HIER_INST17/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST18/enable]  \
  [get_pins RC_CG_HIER_INST18/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST19/enable]  \
  [get_pins RC_CG_HIER_INST19/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST20/enable]  \
  [get_pins RC_CG_HIER_INST20/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST21/enable]  \
  [get_pins RC_CG_HIER_INST21/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST22/enable]  \
  [get_pins RC_CG_HIER_INST22/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST23/enable]  \
  [get_pins RC_CG_HIER_INST23/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST24/enable]  \
  [get_pins RC_CG_HIER_INST24/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST25/enable]  \
  [get_pins RC_CG_HIER_INST25/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST26/enable]  \
  [get_pins RC_CG_HIER_INST26/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST27/enable]  \
  [get_pins RC_CG_HIER_INST27/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST28/enable]  \
  [get_pins RC_CG_HIER_INST28/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST29/enable]  \
  [get_pins RC_CG_HIER_INST29/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST30/enable]  \
  [get_pins RC_CG_HIER_INST30/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST31/enable]  \
  [get_pins RC_CG_HIER_INST31/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST32/enable]  \
  [get_pins RC_CG_HIER_INST32/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST33/enable]  \
  [get_pins RC_CG_HIER_INST33/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST34/enable]  \
  [get_pins RC_CG_HIER_INST34/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST35/enable]  \
  [get_pins RC_CG_HIER_INST35/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST36/enable]  \
  [get_pins RC_CG_HIER_INST36/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST37/enable]  \
  [get_pins RC_CG_HIER_INST37/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST38/enable]  \
  [get_pins RC_CG_HIER_INST38/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST39/enable]  \
  [get_pins RC_CG_HIER_INST39/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST40/enable]  \
  [get_pins RC_CG_HIER_INST40/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST0/enable]  \
  [get_pins RC_CG_HIER_INST0/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST1/enable]  \
  [get_pins RC_CG_HIER_INST1/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST2/enable]  \
  [get_pins RC_CG_HIER_INST2/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST3/enable]  \
  [get_pins RC_CG_HIER_INST3/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST4/enable]  \
  [get_pins RC_CG_HIER_INST4/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST5/enable]  \
  [get_pins RC_CG_HIER_INST5/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST6/enable]  \
  [get_pins RC_CG_HIER_INST6/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST7/enable]  \
  [get_pins RC_CG_HIER_INST7/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST8/enable]  \
  [get_pins RC_CG_HIER_INST8/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST9/enable]  \
  [get_pins RC_CG_HIER_INST9/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST10/enable]  \
  [get_pins RC_CG_HIER_INST10/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST11/enable]  \
  [get_pins RC_CG_HIER_INST11/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST12/enable]  \
  [get_pins RC_CG_HIER_INST12/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST13/enable]  \
  [get_pins RC_CG_HIER_INST13/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST14/enable]  \
  [get_pins RC_CG_HIER_INST14/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST15/enable]  \
  [get_pins RC_CG_HIER_INST15/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST16/enable]  \
  [get_pins RC_CG_HIER_INST16/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST17/enable]  \
  [get_pins RC_CG_HIER_INST17/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST18/enable]  \
  [get_pins RC_CG_HIER_INST18/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST19/enable]  \
  [get_pins RC_CG_HIER_INST19/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST20/enable]  \
  [get_pins RC_CG_HIER_INST20/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST21/enable]  \
  [get_pins RC_CG_HIER_INST21/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST22/enable]  \
  [get_pins RC_CG_HIER_INST22/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST23/enable]  \
  [get_pins RC_CG_HIER_INST23/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST24/enable]  \
  [get_pins RC_CG_HIER_INST24/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST25/enable]  \
  [get_pins RC_CG_HIER_INST25/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST26/enable]  \
  [get_pins RC_CG_HIER_INST26/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST27/enable]  \
  [get_pins RC_CG_HIER_INST27/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST28/enable]  \
  [get_pins RC_CG_HIER_INST28/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST29/enable]  \
  [get_pins RC_CG_HIER_INST29/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST30/enable]  \
  [get_pins RC_CG_HIER_INST30/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST31/enable]  \
  [get_pins RC_CG_HIER_INST31/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST32/enable]  \
  [get_pins RC_CG_HIER_INST32/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST33/enable]  \
  [get_pins RC_CG_HIER_INST33/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST34/enable]  \
  [get_pins RC_CG_HIER_INST34/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST35/enable]  \
  [get_pins RC_CG_HIER_INST35/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST36/enable]  \
  [get_pins RC_CG_HIER_INST36/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST37/enable]  \
  [get_pins RC_CG_HIER_INST37/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST38/enable]  \
  [get_pins RC_CG_HIER_INST38/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST39/enable]  \
  [get_pins RC_CG_HIER_INST39/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST40/enable]  \
  [get_pins RC_CG_HIER_INST40/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST0/enable]  \
  [get_pins RC_CG_HIER_INST0/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST1/enable]  \
  [get_pins RC_CG_HIER_INST1/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST2/enable]  \
  [get_pins RC_CG_HIER_INST2/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST3/enable]  \
  [get_pins RC_CG_HIER_INST3/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST4/enable]  \
  [get_pins RC_CG_HIER_INST4/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST5/enable]  \
  [get_pins RC_CG_HIER_INST5/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST6/enable]  \
  [get_pins RC_CG_HIER_INST6/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST7/enable]  \
  [get_pins RC_CG_HIER_INST7/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST8/enable]  \
  [get_pins RC_CG_HIER_INST8/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST9/enable]  \
  [get_pins RC_CG_HIER_INST9/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST10/enable]  \
  [get_pins RC_CG_HIER_INST10/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST11/enable]  \
  [get_pins RC_CG_HIER_INST11/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST12/enable]  \
  [get_pins RC_CG_HIER_INST12/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST13/enable]  \
  [get_pins RC_CG_HIER_INST13/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST14/enable]  \
  [get_pins RC_CG_HIER_INST14/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST15/enable]  \
  [get_pins RC_CG_HIER_INST15/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST16/enable]  \
  [get_pins RC_CG_HIER_INST16/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST17/enable]  \
  [get_pins RC_CG_HIER_INST17/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST18/enable]  \
  [get_pins RC_CG_HIER_INST18/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST19/enable]  \
  [get_pins RC_CG_HIER_INST19/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST20/enable]  \
  [get_pins RC_CG_HIER_INST20/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST21/enable]  \
  [get_pins RC_CG_HIER_INST21/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST22/enable]  \
  [get_pins RC_CG_HIER_INST22/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST23/enable]  \
  [get_pins RC_CG_HIER_INST23/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST24/enable]  \
  [get_pins RC_CG_HIER_INST24/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST25/enable]  \
  [get_pins RC_CG_HIER_INST25/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST26/enable]  \
  [get_pins RC_CG_HIER_INST26/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST27/enable]  \
  [get_pins RC_CG_HIER_INST27/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST28/enable]  \
  [get_pins RC_CG_HIER_INST28/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST29/enable]  \
  [get_pins RC_CG_HIER_INST29/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST30/enable]  \
  [get_pins RC_CG_HIER_INST30/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST31/enable]  \
  [get_pins RC_CG_HIER_INST31/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST32/enable]  \
  [get_pins RC_CG_HIER_INST32/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST33/enable]  \
  [get_pins RC_CG_HIER_INST33/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST34/enable]  \
  [get_pins RC_CG_HIER_INST34/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST35/enable]  \
  [get_pins RC_CG_HIER_INST35/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST36/enable]  \
  [get_pins RC_CG_HIER_INST36/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST37/enable]  \
  [get_pins RC_CG_HIER_INST37/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST38/enable]  \
  [get_pins RC_CG_HIER_INST38/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST39/enable]  \
  [get_pins RC_CG_HIER_INST39/RC_CGIC_INST/E]  \
  [get_pins RC_CG_HIER_INST40/enable]  \
  [get_pins RC_CG_HIER_INST40/RC_CGIC_INST/E] ]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 0.0 [get_ports rst_n]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[31]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[30]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[29]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[28]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[27]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[26]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[25]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[24]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[23]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[22]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[21]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[20]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[19]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[18]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[17]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[16]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[15]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[14]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[13]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[12]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[11]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[10]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[9]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[8]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[7]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {f_inst[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[31]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[30]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[29]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[28]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[27]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[26]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[25]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[24]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[23]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[22]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[21]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[20]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[19]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[18]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[17]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[16]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[15]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[14]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[13]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[12]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[11]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[10]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[9]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[8]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[7]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_load_dmem[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[31]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[30]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[29]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[28]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[27]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[26]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[25]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[24]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[23]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[22]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[21]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[20]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[19]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[18]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[17]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[16]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[15]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[14]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[13]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[12]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[11]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[10]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[9]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[8]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[7]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {f_inst[0]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[31]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[30]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[29]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[28]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[27]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[26]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[25]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[24]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[23]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[22]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[21]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[20]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[19]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[18]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[17]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[16]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[15]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[14]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[13]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[12]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[11]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[10]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[9]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[8]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[7]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.2 [get_ports {d_load_dmem[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[31]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[30]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[29]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[28]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[27]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[26]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[25]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[24]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[23]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[22]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[21]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[20]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[19]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[18]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[17]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[16]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[15]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[14]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[13]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[12]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[11]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[10]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[9]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {c_pc_f[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[31]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[30]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[29]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[28]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[27]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[26]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[25]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[24]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[23]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[22]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[21]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[20]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[19]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[18]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[17]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[16]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[15]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[14]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[13]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[12]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[11]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[10]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[9]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_addr_dmem[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_we_dmem[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_we_dmem[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_we_dmem[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {store_we_dmem[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[31]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[30]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[29]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[28]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[27]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[26]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[25]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[24]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[23]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[22]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[21]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[20]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[19]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[18]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[17]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[16]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[15]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[14]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[13]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[12]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[11]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[10]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[9]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {d_store_dmem_m[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[31]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[30]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[29]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[28]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[27]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[26]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[25]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[24]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[23]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[22]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[21]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[20]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[19]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[18]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[17]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[16]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[15]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[14]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[13]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[12]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[11]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[10]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[9]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_pc[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[31]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[30]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[29]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[28]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[27]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[26]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[25]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[24]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[23]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[22]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[21]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[20]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[19]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[18]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[17]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[16]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[15]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[14]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[13]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[12]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[11]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[10]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[9]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -max 1.0 [get_ports {trace_inst[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[31]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[30]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[29]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[28]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[27]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[26]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[25]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[24]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[23]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[22]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[21]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[20]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[19]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[18]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[17]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[16]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[15]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[14]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[13]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[12]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[11]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[10]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[9]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {c_pc_f[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[31]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[30]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[29]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[28]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[27]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[26]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[25]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[24]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[23]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[22]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[21]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[20]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[19]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[18]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[17]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[16]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[15]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[14]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[13]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[12]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[11]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[10]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[9]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_addr_dmem[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_we_dmem[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_we_dmem[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_we_dmem[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {store_we_dmem[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[31]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[30]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[29]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[28]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[27]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[26]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[25]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[24]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[23]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[22]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[21]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[20]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[19]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[18]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[17]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[16]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[15]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[14]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[13]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[12]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[11]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[10]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[9]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {d_store_dmem_m[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[31]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[30]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[29]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[28]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[27]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[26]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[25]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[24]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[23]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[22]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[21]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[20]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[19]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[18]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[17]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[16]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[15]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[14]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[13]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[12]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[11]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[10]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[9]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_pc[0]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[31]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[30]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[29]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[28]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[27]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[26]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[25]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[24]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[23]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[22]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[21]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[20]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[19]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[18]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[17]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[16]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[15]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[14]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[13]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[12]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[11]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[10]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[9]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[8]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[7]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[6]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[5]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[4]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[3]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[2]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[1]}]
set_output_delay -clock [get_clocks clk] -add_delay -min 0.0 [get_ports {trace_inst[0]}]
set_max_transition 0.4 [current_design]
set_input_transition 0.1 [get_ports rst_n]
set_input_transition 0.1 [get_ports {f_inst[31]}]
set_input_transition 0.1 [get_ports {f_inst[30]}]
set_input_transition 0.1 [get_ports {f_inst[29]}]
set_input_transition 0.1 [get_ports {f_inst[28]}]
set_input_transition 0.1 [get_ports {f_inst[27]}]
set_input_transition 0.1 [get_ports {f_inst[26]}]
set_input_transition 0.1 [get_ports {f_inst[25]}]
set_input_transition 0.1 [get_ports {f_inst[24]}]
set_input_transition 0.1 [get_ports {f_inst[23]}]
set_input_transition 0.1 [get_ports {f_inst[22]}]
set_input_transition 0.1 [get_ports {f_inst[21]}]
set_input_transition 0.1 [get_ports {f_inst[20]}]
set_input_transition 0.1 [get_ports {f_inst[19]}]
set_input_transition 0.1 [get_ports {f_inst[18]}]
set_input_transition 0.1 [get_ports {f_inst[17]}]
set_input_transition 0.1 [get_ports {f_inst[16]}]
set_input_transition 0.1 [get_ports {f_inst[15]}]
set_input_transition 0.1 [get_ports {f_inst[14]}]
set_input_transition 0.1 [get_ports {f_inst[13]}]
set_input_transition 0.1 [get_ports {f_inst[12]}]
set_input_transition 0.1 [get_ports {f_inst[11]}]
set_input_transition 0.1 [get_ports {f_inst[10]}]
set_input_transition 0.1 [get_ports {f_inst[9]}]
set_input_transition 0.1 [get_ports {f_inst[8]}]
set_input_transition 0.1 [get_ports {f_inst[7]}]
set_input_transition 0.1 [get_ports {f_inst[6]}]
set_input_transition 0.1 [get_ports {f_inst[5]}]
set_input_transition 0.1 [get_ports {f_inst[4]}]
set_input_transition 0.1 [get_ports {f_inst[3]}]
set_input_transition 0.1 [get_ports {f_inst[2]}]
set_input_transition 0.1 [get_ports {f_inst[1]}]
set_input_transition 0.1 [get_ports {f_inst[0]}]
set_input_transition 0.1 [get_ports {d_load_dmem[31]}]
set_input_transition 0.1 [get_ports {d_load_dmem[30]}]
set_input_transition 0.1 [get_ports {d_load_dmem[29]}]
set_input_transition 0.1 [get_ports {d_load_dmem[28]}]
set_input_transition 0.1 [get_ports {d_load_dmem[27]}]
set_input_transition 0.1 [get_ports {d_load_dmem[26]}]
set_input_transition 0.1 [get_ports {d_load_dmem[25]}]
set_input_transition 0.1 [get_ports {d_load_dmem[24]}]
set_input_transition 0.1 [get_ports {d_load_dmem[23]}]
set_input_transition 0.1 [get_ports {d_load_dmem[22]}]
set_input_transition 0.1 [get_ports {d_load_dmem[21]}]
set_input_transition 0.1 [get_ports {d_load_dmem[20]}]
set_input_transition 0.1 [get_ports {d_load_dmem[19]}]
set_input_transition 0.1 [get_ports {d_load_dmem[18]}]
set_input_transition 0.1 [get_ports {d_load_dmem[17]}]
set_input_transition 0.1 [get_ports {d_load_dmem[16]}]
set_input_transition 0.1 [get_ports {d_load_dmem[15]}]
set_input_transition 0.1 [get_ports {d_load_dmem[14]}]
set_input_transition 0.1 [get_ports {d_load_dmem[13]}]
set_input_transition 0.1 [get_ports {d_load_dmem[12]}]
set_input_transition 0.1 [get_ports {d_load_dmem[11]}]
set_input_transition 0.1 [get_ports {d_load_dmem[10]}]
set_input_transition 0.1 [get_ports {d_load_dmem[9]}]
set_input_transition 0.1 [get_ports {d_load_dmem[8]}]
set_input_transition 0.1 [get_ports {d_load_dmem[7]}]
set_input_transition 0.1 [get_ports {d_load_dmem[6]}]
set_input_transition 0.1 [get_ports {d_load_dmem[5]}]
set_input_transition 0.1 [get_ports {d_load_dmem[4]}]
set_input_transition 0.1 [get_ports {d_load_dmem[3]}]
set_input_transition 0.1 [get_ports {d_load_dmem[2]}]
set_input_transition 0.1 [get_ports {d_load_dmem[1]}]
set_input_transition 0.1 [get_ports {d_load_dmem[0]}]
set_wire_load_mode "enclosed"
set_dont_use true [get_lib_cells slow_vdd1v0/BUFX2]
set_dont_use true [get_lib_cells slow_vdd1v0/CLKBUFX2]
set_dont_use true [get_lib_cells slow_vdd1v0/NAND4BBXL]
set_dont_use true [get_lib_cells slow_vdd1v0/NAND4BXL]
set_dont_use true [get_lib_cells slow_vdd1v0/NAND4XL]
set_dont_use true [get_lib_cells slow_vdd1v0/NOR4BBXL]
set_dont_use true [get_lib_cells slow_vdd1v0/NOR4BXL]
set_dont_use true [get_lib_cells slow_vdd1v0/NOR4XL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFHQX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFHQX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFHQX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFHQX8]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFNSRX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFNSRX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFNSRX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFNSRXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFQX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFQX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFQX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFQXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRHQX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRHQX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRHQX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRHQX8]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFRXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSHQX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSHQX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSHQX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSHQX8]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRHQX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRHQX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRHQX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRHQX8]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSRXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFSXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFTRX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFTRX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFTRX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFTRXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SDFFXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFHQX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFHQX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFHQX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFHQX8]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFTRX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFTRX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFTRX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFTRXL]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFX1]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFX2]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFX4]
set_dont_use true [get_lib_cells slow_vdd1v0/SEDFFXL]
set_clock_uncertainty -setup 0.25 [get_clocks clk]
set_clock_uncertainty -hold 0.1 [get_clocks clk]
