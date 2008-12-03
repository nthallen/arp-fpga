ACE = SSP_Config_r1.ace
SW_APP = SSP_Config
BIT = implementation/system.bit
ELF = SDK_projects/$(SW_APP)/Debug/$(SW_APP).elf
$(ACE) : $(BIT) $(ELF)
	xmd -tcl genace.tcl -opt genace.opt

