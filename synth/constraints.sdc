create_clock -period [expr [getenv ECE411_CLOCK_PERIOD_PS] / 1000.0] -name clk0 clk0
set_fix_hold [get_clocks clk0]

set_input_delay  1.7 [get_ports csb0]  -clock clk0
set_input_delay  1.7 [get_ports web0] -clock clk0
set_input_delay  1.7 [get_ports wmask0] -clock clk0
set_input_delay  1.7 [get_ports addr0] -clock clk0
set_input_delay  1.7 [get_ports din0] -clock clk0
set_output_delay 0.7 [get_ports dout0] -clock clk0

set_load 0.1 [all_outputs]
set_max_fanout 1 [all_inputs]
set_fanout_load 8 [all_outputs]
