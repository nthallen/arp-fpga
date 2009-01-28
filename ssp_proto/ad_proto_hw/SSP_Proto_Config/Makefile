BIT = implementation/system.bit
ELF = SDK_projects/SSP_Config/Debug/SSP_Config.elf
ACE = ProtoCfg.ace

$(ACE) : $(BIT) $(ELF)
	xmd -tcl genace.tcl -target mdm -board ml401 -hw $(BIT) -elf $(ELF) -ace $(ACE)

