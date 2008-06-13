ACE = ssp_V1a_r1.ace
SW_APP = ssp_fpga_sw
BIT = implementation/system.bit
ELF = SDK_projects/$(SW_APP)/Debug/$(SW_APP).elf
$(ACE) : $(BIT) $(ELF)
	xmd -tcl genace.tcl -opt genace.opt

