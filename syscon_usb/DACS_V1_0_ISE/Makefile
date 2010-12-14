ELF=Processor/SDK/SDK_Workspace_35/subbus/Debug/subbus.elf
spi_prom.mcs : dacsbd_download.bit
	promgen -spi -w -p mcs -o spi_prom.mcs -s 8192 -u 0 dacsbd_download.bit
dacsbd_download.bit : dacsbd.bit $(ELF)
	@echo dacsbd_download_bit is out of date with respect to $?
	@ls -lt *.mcs *.bit $(ELF)
	@false

