ACE = ssp_V1a_r2.ace
SW_APP = ssp_fpga_sw
BIT = implementation/system.bit
ELF = SDK_projects/$(SW_APP)/Release/$(SW_APP).elf
$(ACE) : $(BIT) $(ELF)
	xmd -tcl genace.tcl -opt genace.opt

