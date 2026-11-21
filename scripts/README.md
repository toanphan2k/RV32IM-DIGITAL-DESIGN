# Tasks

Task: Set PDK paths and physical-design settings.

Command: `code scripts/pd_config.tcl`

Task: RTL synthesis with Cadence Genus.

Command: `genus -files scripts/synth.tcl`

Genus synthesizes `datapath` as the generic CPU core. Its instruction and data
memory ports are external, so the selected simulation program cannot cause
Genus to optimize away unused processor logic. The resulting area excludes
instruction/data memory implementation. The mapped netlist is
`output/genus/datapath_mapped.v`; Innovus uses the same top and netlist.
Innovus uses the SDC exported by Genus at `output/genus/datapath.sdc`
and excludes `BUFX2`, whose LEF entry uses an incompatible `CoreSiteDouble`
site. Rerun Genus before Innovus so the mapped netlist also excludes it.

Task: Floorplan, power plan, placement, CTS, routing, and physical optimization with Cadence Innovus.

Command: `innovus -files scripts/innovus.tcl`

Task: Signoff DRC (in-Innovus DRC/antenna/via checks, merged GDSII export, and Pegasus/PVS/Calibre DRC).

Command: `innovus -files scripts/drc.tcl`

Task: Signoff LVS (in-Innovus connectivity check, PG Verilog/CDL export, and Pegasus/PVS/Calibre LVS).

Command: `innovus -files scripts/lvs.tcl`

`drc.tcl` and `lvs.tcl` restore `output/innovus/datapath_final.enc`, export signoff collateral to `output/signoff/`, and run Pegasus, PVS, or Calibre automatically when loaded in `PATH` (configured via `PV_TOOL`, `GDS_MAP_FILE`, `STD_CELL_GDS`, `STD_CELL_CDL`, `PVS_DRC_RULE_DECK`, and `PVS_LVS_RULE_DECK` in `scripts/pd_config.tcl`).