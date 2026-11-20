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