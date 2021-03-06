12/14/12 Started new development for per-point noise and ringdown

V3.01b
  Added SSP_Reset output port to support PMT input circuit.

V3.01a
  Recompiled for EDK 12.1 using PLD instead of FSL
  
V3.00
  Used in initial release on the SSP Board Rev 1
  Flew during TILDE test flights

New features in V2.2:
  dynamically configurable coadd circuit

New features in V2.1:
  dynamically configurable pre-addr circuit

ssp_ad_scan pcore supports:
  dynamically configurable scan length
  dynamically configurable triggering unit
  dynamic configuration for pre-addr circuit
  dynamically configurable coadd circuit
  FIFO contains entire scan
  interrupt at end of scan
  interfaces to SSP Proto board hardware
  requires the external pcore arp_ssp_v1_00_a

ssp_ad_preaddr pcore supports:
  interface to A/D
  dynamically configurable pre-adding

ssp_ad_preaddr circuit description:

  This circuit is clocked by the inverse of the A/D sample clock, then 
  adds (NA+1)*2 consecutive samples, producing a 50% duty cycle output 
  clock, DV_out, which goes high at the same time the summed data is 
  written to the Signal_out register. 

  Hence, the minimum number of samples summed is 2. This circuit should be 
  able to handle input speeds somewhat in excess of the Microblaze system 
  clock, so long as the input clock rate divided by the number of samples 
  summed is slow enough for the follow-on circuit. In the case of 
  ssp_ad_scan V2.1, the output frequency must be less than one half the 
  system clock rate. When more channels are involved, this limit may need 
  to be somewhat lower. 

  When the Enable is not asserted, DV_Out is held high, and Signal values 
  are clocked straight through to Signal_Out. This allows the following 
  circuit to use the raw signal if no pre adding is desired.
  
  DV_Out is delayed by two clocks where S0T+S1T+Reset is true in order 
  that the first output clock does not occur until the first summed sample 
  is complete. Extra circuitry was added to ensure that DV_Out goes high 
  and remains high when Enable is removed.
  
  The intent is that the Enable will stay low until the trigger is observed.
  This means that triggering jitter is limited to one A/D sample, not a pre-added
  sample.

ssp_trigger.mdl

  This is an XPS wrapper around the Triggering library block. We generate
  VHDL from this (no pcore) and then used some tool or other to make it
  into a pcore.
  
ssp_system.mdl

  This is simply a schematic diagram to show how the components should be
  interconnected in XPS. It does not show how ScanProcessing is connected
  to the CPU. (Note also that in 12.1, the connection was changed from FSL
  to PLB)
