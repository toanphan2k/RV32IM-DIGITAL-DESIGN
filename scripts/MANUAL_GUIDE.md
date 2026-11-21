# Manual Physical-Design & Signoff Guide (`RV32IM datapath` — GPDK045)

This guide documents:
1. **How to re-run the clean automated Synthesis + PnR + DRC + LVS flow** on the lab server (`black.doelab.site`), and
2. **How to handle cases that cannot be changed purely inside TCL** (read-only PDK library warnings, server EDA environment paths, Virtuoso/PVS GUI signoff, and manual ECO fixes in Innovus GUI).

---

## 1. Verified Server Run Order (`black.doelab.site`)

Always load the Cadence modules on `black` and run the 4 stages in order (Genus first whenever `scripts/pd_config.tcl`, `constraints/top.sdc`, or `rtl/*.sv` changes):

```bash
# On red.doelab.site -> interactive compute node black:
srun --nodelist=black -c 2 --pty bash -l

cd ~/risc-v-ws/RV32IM-DIGITAL-DESIGN
module load cadence/genus/211 cadence/innovus/211 cadence/pegasus/241

genus   -files scripts/synth.tcl
innovus -files scripts/innovus.tcl
innovus -files scripts/drc.tcl
innovus -files scripts/lvs.tcl
```

> **Verified Signoff Baseline (Pegasus 24.11 + Innovus 21.19 + Genus 21.19):**
> - **Genus Synthesis**: `+442.1 ps` setup slack, `0` timing violations
> - **Innovus Post-Route**: Setup WNS `+0.061 ns` (`0` viols), Hold WNS `+0.030 ns` (`0` viols), DRVs `0`, Density `72.86%` (`100%` w/ fillers), `verify_drc = 0`, `verify_connectivity = 0`, `verifyProcessAntenna = 0`, `verifyPowerVia = 0`
> - **Pegasus 24.11 Foundry DRC (`pvlDRC.rul`)**: **`0 / 562`** rules violated
> - **Pegasus 24.11 Foundry LVS (`pvlLVS.rul`)**: **`MATCH`** (`232/232` pins including `Metal7` `VDD`/`VSS`, `0` ERC, `0` device/net/parameter mismatches)
>
> **Tip:** Do **not** run `genus -files scripts/innovus.tcl` (both scripts check the active tool and exit cleanly if invoked in the wrong tool).

---

## 2. Cases That Require Manual Handling / PDK Waivers

### Case A — Signoff Pegasus / PVS Tool Environment on `black.doelab.site`
**What happened in the earlier log (`output/signoff/drc/pvs_drc.log` & `pvs_lvs.log`):**
- Linux OS has `/usr/sbin/pvs` (the Rocky Linux **LVM2 disk utility**), which printed:
  `File descriptor ... leaked on pvs invocation` and `pvs: invalid option -- 'r'`.
- `scripts/signoff_utils.tcl` now **automatically filters out `/usr/sbin/pvs`** and selects Cadence `pegasus` (`/tools/eda/cadence/PEGASUS241/bin/pegasus`) or `pvs`.

**Recommended setup on `black.doelab.site`:**
```bash
module load cadence/pegasus/241
which pegasus   # -> /tools/eda/cadence/PEGASUS241/bin/pegasus
innovus -files scripts/drc.tcl
innovus -files scripts/lvs.tcl
```

**If running Pegasus / PVS manually from GUI**, use the ready-made files exported by `drc.tcl` / `lvs.tcl`:
- **Merged Layout GDSII:** `output/signoff/datapath.gds` (top cell: `datapath`, exported with official `/tools/eda/pdks/cadence/gpdk045/gpdk045_v_6_0/soce/streamOut.map`)
- **Unified LVS SPICE/CDL Netlist:** `output/signoff/datapath_lvs.cdl` (top `.SUBCKT`: `datapath`, includes `gsclib045.cdl`, power `VDD`, ground `VSS`)
- **DRC Rule Deck:** `/tools/eda/pdks/cadence/gpdk045/gpdk045_v_6_0/pvs/pvlDRC.rul`
- **LVS Rule Deck:** `/tools/eda/pdks/cadence/gpdk045/gpdk045_v_6_0/pvs/pvlLVS.rul` (note: requires `pvs_control_file` in the LVS run directory; `scripts/lvs.tcl` copies it automatically)
- **Ready-made Control Files:** `output/signoff/drc/pvs_drc.ctrl` and `output/signoff/lvs/pvs_lvs.ctrl`

### Case A2 — GPDK045 Foundry Stacked-Via DRC (`VIAk.X.3_VIAk.X.4`)
- GPDK045 `pvlDRC.rul` enforces double-cut vias at every level of a 5-level stacked via pillar (`M1..M6`, `M2..M7`, `M3..M8`, `M4..M9`).
- `scripts/pd_config.tcl` caps signal routing at `TOP_SIGNAL_ROUTING_LAYER 5` (`Metal5`) — reserving `Metal6`/`Metal7` for multi-cut power stripes/rings — and `scripts/innovus.tcl` enables `-routeReserveSpaceForMultiCut true`, `-drouteUseMultiCutViaEffort high`, and `-droutePostRouteSwapVia multiCut`.
- If you ever raise `TOP_SIGNAL_ROUTING_LAYER` above `5`, inspect `output/signoff/drc/drc.sum` for `VIAk.X.3_VIAk.X.4` single-cut pillar violations and swap/reroute those vias in Innovus.

---

### Case B — Read-Only PDK Library Warnings (Cannot Be Fixed in Project TCL; Safe to Waive)
These warnings originate inside the read-only `/tools/eda/pdks/cadence/gpdk045` PDK files on the server and **are not design violations**:

1. **`**WARN: (IMPLF-200): Pin 'A' in macro 'ANTENNA' has no ANTENNAGATEAREA value defined.`**
   - **Why:** `ANTENNA` is a reverse-biased diffusion protection diode (`ANTENNADIFFAREA` is defined, not `ANTENNAGATEAREA`, because a diode has no MOSFET gate oxide).
   - **Action:** Safe to waive; `verifyProcessAntenna` reports `0 Violations`.
2. **`**WARN: (TECHLIB-302)` / `Warning : Library cell has no output pins defined. [LBR-9]` on `DECAP*` and `ANTENNA`**
   - **Why:** Physical-only cells have no logic output pins in `.lib`.
   - **Action:** Expected for all standard-cell libraries; safe to ignore.
3. **`**WARN: (IMPFP-3961): The techSite 'CornerSite' / 'IOSite' has no related standard cells`**
   - **Why:** Block-level PnR uses core standard cells (`CoreSite`) without pad-ring IO cells.
   - **Action:** Safe to ignore for core-level implementation.

---

### Case C — `DECAP3..DECAP10` Internal Metal1 End-Of-Line DRC in `gsclib045_svt_v4.7`
**What happened in the previous server log (`output/innovus/drc.rpt`):**
- NanoRoute finished with **`0` DRC violations**, but post-route `addFiller` inserted `DECAP2..DECAP10`, producing **274 `Metal1 EndOfLine` violations** (`204` were `Pin of Cell FILLER_T_x & Pin of Cell FILLER_T_x` **inside a single `DECAP3..DECAP10` macro itself**).
- `scripts/pd_config.tcl` now sets `DECAP_CELLS [list]` and uses `FILL64..FILL1` + `setFillerMode -ecoMode true` + `ecoRoute`, eliminating all 274 violations automatically.

**If your lab rubric explicitly requires on-chip decoupling capacitors (`DECAP`):**
- Only `DECAP2` had zero internal self-violations in `gsclib045_svt_v4.7`.
- Set `set DECAP_CELLS [list DECAP2]` in `scripts/pd_config.tcl`, and insert decaps **before** `routeDesign` (or let `innovus.tcl`'s `ecoRoute -fix_drc` reroute Metal1 wires around `DECAP2` pins).
- If `DECAP3..DECAP10` are mandated by a course rule, any `Pin of Cell DECAP* & Pin of Cell DECAP*` marker inside the read-only cell abstract must be waived as a PDK standard-cell internal marker (since block-level PnR cannot edit foundry cell GDS/LEF).

---

## 3. How to Fix Residual Violations Manually in Innovus GUI (If Needed Later)

If you later tighten the clock period (e.g., `< 7 ns`), raise `CORE_UTILIZATION` (`> 0.80`), or change pin placements and see a handful of residual DRC or timing violations, open the saved database interactively:

```bash
innovus
```
Then inside the Innovus console:
```tcl
source output/innovus/datapath_final.enc
```

### 3.1 Manual DRC Cleanup in Innovus GUI
1. Open **Tools -> Violation Browser** (or press `Shift+V`) to zoom directly to each DRC marker.
2. **If a `FILLER*` cell touches a `Metal1` wire end-of-line:**
   ```tcl
   # Delete fillers in the local bounding box (x1 y1 x2 y2 in microns), reroute net, re-add FILL1..64:
   deleteFiller -prefix FILLER -area {x1 y1 x2 y2}
   ecoRoute -fix_drc
   addFiller -cell {FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1} -prefix FILLER -fitGap -ecoMode true
   verify_drc -report output/innovus/drc_manual.rpt
   ```
3. **If two signal wires have a Metal1/Metal2 spacing/short/EOL marker:**
   - Select the violating wire segment in the GUI and press `Delete` (or run `editDelete -net <net_name>`), then run:
   ```tcl
   ecoRoute -target
   ecoRoute -fix_drc
   verify_drc
   verify_connectivity -type all
   ```
   - Or manually jog the wire onto the adjacent routing track using **Edit -> Wire -> Edit Wire** (`e` / `s` shortcut in GUI).

### 3.2 Manual Timing / DRV (`max_tran` / `hold` / `setup`) ECO in Innovus
1. **Fix a single `max_tran` violation** (weak `*XL` or `*X1` cell driving a long net):
   ```tcl
   # Upsize the driving instance in-place without disturbing placement/routing:
   ecoChangeCell -inst <driver_inst_name> -cell <stronger_cell_e.g._NAND4X2_or_BUFX4>
   ecoRoute -target
   extractRC
   timeDesign -postRoute -drvReports -outDir output/innovus/postRoute
   ```
2. **Fix a single Hold violation** (e.g., fast register-to-output or register-to-register path):
   ```tcl
   # Insert a delay cell right before the endpoint pin or output port:
   ecoAddRepeater -term <endpoint_inst/D_or_port_name> -cell DLY1X1
   ecoRoute -target
   extractRC
   timeDesign -postRoute -hold -outDir output/innovus/postRoute
   ```
3. **Save after manual edits** before running `scripts/drc.tcl` and `scripts/lvs.tcl`:
   ```tcl
   saveNetlist output/innovus/datapath_pnr.v
   saveDesign  output/innovus/datapath_final.enc
   ```

---

## 4. Verifying Exported GDSII Before Submission

`scripts/signoff_utils.tcl` automatically prefers the official PDK Innovus map (`/tools/eda/pdks/cadence/gpdk045/gpdk045_v_6_0/soce/streamOut.map`, which exports `NET`, `SPNET`, `PIN`, `LEFPIN`, `FILL`, `VIA`, `LEFOBS`, and `NAME Metal*/PIN` on texttype `3` matching `pvlLVS.rul`), falling back to converting Virtuoso `gpdk045.layermap` only if `soce/streamOut.map` is absent.

After running `innovus -files scripts/drc.tcl` and `innovus -files scripts/lvs.tcl` on the server, verify:
- `Stream Out Information Processed` shows non-zero `Nets` (`~281,000`), `Via Instances` (`~161,000`), and `232` ports/pins (`Metal3`/`Metal4` signals + `Metal7` `VDD`/`VSS`), with **zero** `IMPOGDS-1178` warnings.
- `output/signoff/drc/drc.sum`: `Total DRC Results : 0 (0)`
- `output/signoff/lvs/lvs.rep`: `Run Result : MATCH`, `ERC Results: Empty`
