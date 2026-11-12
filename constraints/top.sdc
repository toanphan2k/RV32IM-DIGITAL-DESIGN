
# Clock: 100 MHz
create_clock -name clk -period 10.000 [get_ports clk]

# Clock uncertainty
set_clock_uncertainty 0.2 [get_clocks clk]

# Input delay
set_input_delay 1.0 -clock clk [remove_from_collection [all_inputs] [get_ports clk]]

# Output delay
set_output_delay 1.0 -clock clk [all_outputs]

# Output load (example)
set_load 0.05 [all_outputs]
