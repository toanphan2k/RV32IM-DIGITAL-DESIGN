# Tasks

Task: Set PDK paths and physical-design settings.

Command: `code scripts/pd_config.tcl`

Task: RTL synthesis with Cadence Genus.

Command: `genus -files scripts/synth.tcl`

`imem.sv` instantiates `imem_rom`. Simulation uses `rtl/imem_rom.sv`, which
loads `imem.mem`; Genus ignores that RTL `initial` / `$readmemh` construct.
The synthesis script substitutes a synthesizable ROM generated from
`tb/mem/imem.mem`. Change that image before synthesis to select a different
instruction program. Addresses not specified in the image synthesize as zero.

Task: Floorplan, power plan, placement, CTS, routing, and physical optimization with Cadence Innovus.

Command: `innovus -files scripts/innovus.tcl`