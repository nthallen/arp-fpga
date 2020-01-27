ELF=Processor/SDK/subbus/Debug/subbus.elf
.PHONY : all
# all : spi_prom.mcs htw_spi_prom.mcs cti_spi_prom.mcs
all : pdacs_hcl.mcs

pdacs_hcl.mcs : pdacs_hcl.bit
	promgen -spi -w -p mcs -o pdacs_hcl.mcs -s 8192 -u 0 pdacs_hcl.bit
pdacs_hcl.bit : $(ELF)
	@echo pdacs_hcl.bit is out of date with respect to $?
	@ls -lt pdacs_hcl.mcs pdacs_hcl.bit $(ELF)
	@false

spi_prom.mcs : dacsbd_download.bit
	promgen -spi -w -p mcs -o spi_prom.mcs -s 8192 -u 0 dacsbd_download.bit
dacsbd_download.bit : dacsbd.bit $(ELF)
	@echo dacsbd_download_bit is out of date with respect to $?
	@ls -lt *.mcs *.bit $(ELF)
	@false

pdacs_es96.mcs : pdacs_es96.bit
	promgen -spi -w -p mcs -o pdacs_es96.mcs -s 8192 -u 0 pdacs_es96.bit

# 7/1/14: Changing name from htw_spi_prom.mcs to PDACS_HTW.mcs
PDACS_HTW.mcs : PDACS_HTW.bit
	promgen -spi -w -p mcs -o PDACS_HTW.mcs -s 8192 -u 0 PDACS_HTW.bit

pdacs_carbon.mcs : pdacs_carbon.bit
	promgen -spi -w -p mcs -o pdacs_carbon.mcs -s 8192 -u 0 pdacs_carbon.bit

# 7/23/19: Change name to PDACS_HWV
PDACS_HWV.mcs : PDACS_HWV.bit
	promgen -spi -w -p mcs -o PDACS_HWV.mcs -s 8192 -u 0 PDACS_HWV.bit

pdacs_bench.mcs : pdacs_bench_download.bit
	promgen -spi -w -p mcs -o pdacs_bench.mcs -s 8192 -u 0 pdacs_bench_download.bit
pdacs_bench_download.bit : pdacs_bench.bit $(ELF)
	@echo pdacs_bench_download_bit is out of date with respect to $?
	@ls -lt *.mcs *.bit $(ELF)
	@false

# For programming with Impact, DACS boards to date have been assembled with
# U4 M25P64 installed (identified on the chip as 25P64V. Data width is 1.
