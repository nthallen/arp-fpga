<?xml version="1.0" encoding="utf-8"?>
<?xml-stylesheet ekr_test?>
<leo_file>
<leo_header file_format="2" tnodes="0" max_tnode_index="0" clone_windows="0"/>
<globals body_outline_ratio="0.5" body_secondary_ratio="0.5">
	<global_window_position top="50" left="50" height="500" width="700"/>
	<global_log_window_position top="0" left="0" height="0" width="0"/>
</globals>
<preferences/>
<find_panel_settings/>
<vnodes>
<v t="ntallen.20120211141043.1566"><vh>@chapters</vh></v>
<v t="ntallen.20120211141043.1565" a="E"><vh>VHDL Analysis</vh>
<v t="ntallen.20120211142024.1245"><vh>Summary</vh></v>
<v t="ntallen.20120211142024.1246"><vh>Components</vh></v>
<v t="ntallen.20120211142024.1247" a="E"><vh>Tree</vh>
<v t="ntallen.20120211142024.1248" a="E"><vh>Component_Def</vh>
<v t="ntallen.20120211142024.1251"><vh>Generic_Def</vh></v>
<v t="ntallen.20120211142024.1250"><vh>Port_Def</vh></v>
</v>
<v t="ntallen.20120211142024.1249" a="E"><vh>Component_Inst</vh>
<v t="ntallen.20120211142024.1252"><vh>Generic_Mappping</vh></v>
<v t="ntallen.20120211142024.1253"><vh>Port_Map</vh></v>
</v>
</v>
<v t="ntallen.20120211142024.1254"><vh>Analysis</vh></v>
</v>
</vnodes>
<tnodes>
<t tx="ntallen.20120211141043.1565">@nocolor</t>
<t tx="ntallen.20120211141043.1566"></t>
<t tx="ntallen.20120211142024.1245">Project to analyze FPGA Synthesis by parsing VHDL version of NGC file.

Want to identify:
  FlipFlops with unregistered inputs combined with lots of logic
  FlipFlops with inputs registered with a different clock
  FlipFlops with inputs with lots of dependencies and many levels of logic
  RAM with inputs in any of these categories
  IOBUFs or IBUFs routed through combinatorial logic to more than one register

Outputs of FlipFlops and RAM are registered, but should note which clock
Outputs of IBUFs are unregistered
Outputs of IOBUFs are unregistered

Look at clocks
      C =&gt; dacs_i_Inst_syscon_Ctrl_int_2_BUFG_49,
      C =&gt; dacs_i_clk_66_6667MHz,
      C =&gt; dacs_i_clk_8_0000MHz,

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
</t>
<t tx="ntallen.20120211142024.1246">After synthesis, the components currently referenced by PDACS_Carbon include:
    IO:
        BUFG
        IOBUF
        IBUF
        OBUF
        
    Registers:
        FD
        FDC
        FDCE
        FDE
        FDP
        FDPE
        FDR
        FDRE
        FDS
        FDSE
        RAMB16BWER
        RAMB8BWER
        
    Constants:
        GND
        VCC

    Combinatorial Logic:
        INV
        LUT1
        LUT2
        LUT3
        LUT4
        LUT5
        LUT6
        MUXCY
        MUXF7
        MUXF8
        XORCY
</t>
<t tx="ntallen.20120211142024.1247"></t>
<t tx="ntallen.20120211142024.1248">Key will refer
Component_name?
component category (IO, Register, Combinatorial or Constant)
Generic Definitions
Port Definitions</t>
<t tx="ntallen.20120211142024.1249">Store:
    Component_Def Key (figure out how this works)
    Name

</t>
<t tx="ntallen.20120211142024.1250">Store:
    Component_Def Key
    Name: StringTableKey
    Dir: In, Out, INOUT
    Type:

Port_Signal: identifier
Port_Dir: In, Out, INOUT
Port_Type: std_logic or std_logic_vector()</t>
<t tx="ntallen.20120211142024.1251">Store:
    Component_Def Key
    Name
    Value?</t>
<t tx="ntallen.20120211142024.1252">Store:
    Generic_Def Key
    Value?</t>
<t tx="ntallen.20120211142024.1253">Store:
    Port_Def Key
    Signal_Def Key</t>
<t tx="ntallen.20120211142024.1254">Find all input I/O components:
    IBUF.O (output from component, input from pad)
    IOBUF.O (output from component, input from pad)
    BUFG.O

For each input, find the signal on that input and all component instances that signal connects to. If the component instance type is register, add it to the list of registers
    switch (component instance type):
        Register: Add it to the list of registers
        Constant: Error
        Combinatorial: Add all registers on this component's list of registers

Propogate Outputs: For each component instance:
    Register:
        Mark signals connected to output ports as being relative to the clock input
    Combinatorial:
        Need to know all inputs first, presumably need to analyze component
          driving each input
        set depth to one more than the maximum depth of the inputs. 
        If all inputs are registered relative to the same clock, mark the output
          as relative to that clock
        else
          mark output as relative to unknown clock
     IO/In:
         Mark signals connected to output ports as being relative to unknown clock,
         depth zero
     Processor:
         Figure out what outputs should be marked as. Probably relative to sys_clk or 66MHz.

     Register:
        If all inputs are registered relative to the same clock, we are happy.
        Otherwise we have a potential race condition.
</t>
</tnodes>
</leo_file>
