ELF=Processor/SDK/SDK_Workspace_35/subbus/Debug/subbus.elf
.PHONY : all
all : spi_prom.mcs htw_spi_prom.mcs
spi_prom.mcs : dacsbd_download.bit
	promgen -spi -w -p mcs -o spi_prom.mcs -s 8192 -u 0 dacsbd_download.bit
dacsbd_download.bit : dacsbd.bit $(ELF)
	@echo dacsbd_download_bit is out of date with respect to $?
	@ls -lt *.mcs *.bit $(ELF)
	@false

htw_spi_prom.mcs : pdacs_htw_download.bit
	promgen -spi -w -p mcs -o htw_spi_prom.mcs -s 8192 -u 0 pdacs_htw_download.bit
pdacs_htw_download.bit : pdacs_htw.bit $(ELF)
	@echo pdacs_htw_download_bit is out of date with respect to $?
	@ls -lt *.mcs *.bit $(ELF)
	@false

