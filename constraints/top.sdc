# Clock: 100 MHz (10 ns period)
create_clock -name clk -period 10.000 [get_ports clk]

# Pre-CTS clock slew estimate (propagated post-CTS in Innovus)
set_clock_transition 0.100 [get_clocks clk]

# Separate setup and hold clock uncertainty (jitter + synthesis/PnR margin)
set_clock_uncertainty -setup 0.250 [get_clocks clk]
set_clock_uncertainty -hold  0.100 [get_clocks clk]

# Realistic input transition on non-clock ports
set all_data_inputs [remove_from_collection [all_inputs] [get_ports clk]]
set_input_transition 0.100 $all_data_inputs

# Input delays (max for setup, min for hold)
set_input_delay -max 1.000 -clock clk $all_data_inputs
set_input_delay -min 0.200 -clock clk $all_data_inputs

# Output delays (max for setup, min for hold)
set_output_delay -max 1.000 -clock clk [all_outputs]
set_output_delay -min 0.000 -clock clk [all_outputs]

# Output load (0.05 pF = 50 fF; gsclib045 capacitance unit is 1 pF)
set_load 0.050 [all_outputs]
