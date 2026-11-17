# Tasks

Task: Set PDK paths and physical-design settings.

Command: `code scripts/pd_config.tcl`

Task: RTL synthesis with Cadence Genus.

Command: `genus -files scripts/synth.tcl`

Genus synthesizes `datapath` as the generic CPU core. Its instruction and data
memory ports are external, so the selected simulation program cannot cause
Genus to optimize away unused processor logic. The resulting area excludes
instruction/data memory implementation. The mapped netlist is
`scripts/output/genus/datapath_mapped.v`; Innovus uses the same top and netlist.
The slow-corner SVT library set includes the matching multi-bit DFF Liberty and
LEF files; check `gates.rpt` to see whether Genus actually selected those cells.

Task: Floorplan, power plan, placement, CTS, routing, and physical optimization with Cadence Innovus.

Command: `innovus -files scripts/innovus.tcl`