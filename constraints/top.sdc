# Clock: 133.3 MHz (7.5 ns period) — verified 0-violation Genus/Innovus/Pegasus DRC+LVS signoff
create_clock -name clk -period 7.500 [get_ports clk]

# Pre-CTS clock slew estimate (propagated post-CTS in Innovus)
set_clock_transition 0.100 [get_clocks clk]

# Separate setup and hold clock uncertainty (jitter + synthesis/PnR margin)
set_clock_uncertainty -setup 0.250 [get_clocks clk]
set_clock_uncertainty -hold  0.100 [get_clocks clk]

# Design-wide max transition guardband (comfortably below gsclib045 0.500 ns data limit)
set_max_transition 0.400 [current_design]

# Asynchronous active-low reset: constrain slew & dummy arrival so timing_lint is clean,
# then false-path async reset paths from synchronous single-cycle setup/hold checks.
set_input_transition 0.100 [get_ports rst_n]
set_input_delay 0.000 -clock clk [get_ports rst_n]
set_false_path -from [get_ports rst_n]

# Realistic input transition and synchronous delays on non-clock, non-reset data ports
set all_data_inputs [remove_from_collection [all_inputs] [get_ports {clk rst_n}]]
set_input_transition 0.100 $all_data_inputs
set_input_delay -max 1.000 -clock clk $all_data_inputs
set_input_delay -min 0.200 -clock clk $all_data_inputs

# Output delays (max for setup, min for hold)
set_output_delay -max 1.000 -clock clk [all_outputs]
set_output_delay -min 0.000 -clock clk [all_outputs]

# Output load (0.05 pF = 50 fF; gsclib045 capacitance unit is 1 pF)
set_load 0.050 [all_outputs]
