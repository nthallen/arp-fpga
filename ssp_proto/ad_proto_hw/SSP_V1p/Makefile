BIT = implementation/system.bit
ELF = SDK_projects/ssp_proto_b/Debug/ssp_proto_b.elf
ACE = ssp_V1p_r2.ace

$(ACE) : $(BIT) $(ELF)
	xmd -tcl genace.tcl -target mdm -board ml401 -hw $(BIT) -elf $(ELF) -ace $(ACE)

