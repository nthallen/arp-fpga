ELF=Processor/SDK/SDK_Workspace_35/subbus/Debug/subbus.elf
.PHONY : all
# all : spi_prom.mcs htw_spi_prom.mcs cti_spi_prom.mcs
all : cti_spi_prom.mcs hwv_spi_prom.mcs pdacs_bench.mcs
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

cti_spi_prom.mcs : pdacs_carbon_download.bit
	promgen -spi -w -p mcs -o cti_spi_prom.mcs -s 8192 -u 0 pdacs_carbon_download.bit
pdacs_carbon_download.bit : pdacs_carbon.bit $(ELF)
	@echo pdacs_carbon_download_bit is out of date with respect to $?
	@ls -lt *.mcs *.bit $(ELF)
	@false

hwv_spi_prom.mcs : pdacs_hwv_download.bit
	promgen -spi -w -p mcs -o hwv_spi_prom.mcs -s 8192 -u 0 pdacs_hwv_download.bit
pdacs_hwv_download.bit : pdacs_hwv.bit $(ELF)
	@echo pdacs_hwv_download_bit is out of date with respect to $?
	@ls -lt *.mcs *.bit $(ELF)
	@false

pdacs_bench.mcs : pdacs_bench_download.bit
	promgen -spi -w -p mcs -o pdacs_bench.mcs -s 8192 -u 0 pdacs_bench_download.bit
pdacs_bench_download.bit : pdacs_bench.bit $(ELF)
	@echo pdacs_bench_download_bit is out of date with respect to $?
	@ls -lt *.mcs *.bit $(ELF)
	@false

# For programming with Impact, DACS boards to date have been assembled with
# U4 M25P64 installed (identified on the chip as 25P64V. Data width is 1.