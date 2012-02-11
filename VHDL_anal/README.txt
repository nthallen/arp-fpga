Project to analyze FPGA Synthesis by parsing VHDL version of NGC file.

Want to identify:
  FlipFlops with unregistered inputs combined with lots of logic
  FlipFlops with inputs registered with a different clock
  FlipFlops with inputs with lots of dependencies and many levels of logic
  RAM with inputs in any of these categories

Outputs of FlipFlops and RAM are registered, but should note which clock
Outputs of IBUFs are unregistered
Outputs of IOBUFs are unregistered

Look at clocks
      C => dacs_i_Inst_syscon_Ctrl_int_2_BUFG_49,
      C => dacs_i_clk_66_6667MHz,
      C => dacs_i_clk_8_0000MHz,

When parsing, record
  component_declaration
    component_name
    generics
    ports (
      port_name
      port_mode
    )
  Each component defines a namespace for ports

  component_instantiation
    instance_name
    component_name
    generic_maps
    port_maps (
      port_name
      signal_name
    )
  port_name is referenced to the component_name namespace
  signal_name is in the architecture namespace
  
For each signal, recursively calculate its provenance:
  Want to trace back to inputs that are registered with the same clock
  Want to know how many inputs and how many levels of logic
  If there are unregistered inputs (including registered with a different clock),
    I want to know where in the input logic they exist and how many other
    signals have that unregistered signal as an input.
