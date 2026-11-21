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
and excludes `BUFX2` (`CoreSiteDouble`), scan flip-flops (`SDFF*`/`SEDFF*`,
since DFT scan chains are not inserted), and ultra-weak 4-input `XL` gates
that trigger `max_tran` violations. **Always rerun Genus before Innovus** after
changing `scripts/pd_config.tcl`, `constraints/top.sdc`, or `rtl/*.sv`.

Task: Floorplan, power plan, placement, CTS, routing, and physical optimization with Cadence Innovus.

Command: `innovus -files scripts/innovus.tcl`

Task: Signoff DRC (in-Innovus DRC/antenna/via checks, merged GDSII export, and Pegasus/PVS/Calibre DRC).

Command: `innovus -files scripts/drc.tcl`

Task: Signoff LVS (in-Innovus connectivity check, PG Verilog + unified SPICE/CDL export, and Pegasus/PVS/Calibre LVS).

Command: `innovus -files scripts/lvs.tcl`

`drc.tcl` and `lvs.tcl` restore `output/innovus/datapath_final.enc`, auto-convert Virtuoso `gpdk045.layermap` into an Innovus `streamOut` map (`output/signoff/innovus_streamout.map`) if needed, generate a unified SPICE/CDL netlist (`output/signoff/datapath_lvs.cdl`), and run Pegasus, PVS, or Calibre automatically when found in `PATH` or `PV_SEARCH_DIRS` (ignoring Linux OS `/usr/sbin/pvs` LVM2).

For manual ECO fixes in Innovus GUI, PVS/Virtuoso setup on the lab server, and PDK library waivers, see [MANUAL_GUIDE.md](MANUAL_GUIDE.md).
