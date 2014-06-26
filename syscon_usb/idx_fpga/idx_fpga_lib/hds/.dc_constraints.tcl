#
# DesignChecker code/rule exclusions for library 'idx_fpga_lib'
#
# Created:
#          by - nort.UNKNOWN (NORT-NBX200T)
#          at - 09:48:20 01/11/2013
#
# using Mentor Graphics HDL Designer(TM) 2012.1 (Build 6)
#

dc_exclude -design_unit {syscon_tick} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {gxidx} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {system} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {decode} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {dacs} -check {RuleSets\Essentials\Code Reuse\Non-Portable Constructs}
dc_exclude -design_unit {syscon} -check {RuleSets\Essentials\Code Reuse\Non-Portable Constructs}
dc_exclude -design_unit {syscon_tick} -check {RuleSets\Essentials\Code Reuse\Non-Portable Constructs}
dc_exclude -design_unit {gxidx} -check {RuleSets\Essentials\Code Reuse\Non-Portable Constructs}
dc_exclude -design_unit {decode} -check {RuleSets\Essentials\Code Reuse\Non-Portable Constructs}
dc_exclude -design_unit {decode} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {syscon} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {dacs} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {syscon} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {DigIO} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {DigIO_Addr} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {DigIO_Addr} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {syscon} -check {RuleSets\Essentials\Downstream Checks\Constrained Ranges & Bounds}
dc_exclude -design_unit {syscon_tick} -check {RuleSets\Essentials\Downstream Checks\Constrained Ranges & Bounds}
dc_exclude -design_unit {DigIO} -check {RuleSets\Essentials\Code Reuse\Non-Portable Constructs}
dc_exclude -design_unit {DigIO_Addr} -check {RuleSets\Essentials\Code Reuse\Non-Portable Constructs}
dc_exclude -design_unit {bench_ana_addr} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {ana_hwside} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ana_ram} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ana_hwside} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {ana_ram} -check {RuleSets\Essentials\Downstream Checks\Constrained Ranges & Bounds}
dc_exclude -design_unit {bench_decode} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ctr_ungated} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ctr_ugctr} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ctr_addr} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ctr_ugctr} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {ctr_lx4gen} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {ctr_addr} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {ctr_addr} -check {RuleSets\Essentials\Downstream Checks\Register IO}
dc_exclude -design_unit {ctr_ungated} -check {RuleSets\Essentials\Coding Practices\Unused Declarations}
dc_exclude -design_unit {syscon_tick} -check {RuleSets\Essentials\Downstream Checks\Initialization Assignments}
dc_exclude -design_unit {bench_syscon} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_syscon} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {ana_addr} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {bench_ana_input_tester} -check {RuleSets\Essentials\Coding Practices\Unused Declarations}
dc_exclude -design_unit {bench_ana_input} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ana_input_tester} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {mock_ad7687_chain} -check {RuleSets\Essentials\Downstream Checks\Latch Inference}
dc_exclude -design_unit {Processor} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {DACSbd} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_syscon_tick_tb} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ctr_ungated} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ctr_ungated_tester} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ctr_ungated_tester} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {bench_ctr_ungated_tester} -check {RuleSets\Essentials\Downstream Checks\Constrained Ranges & Bounds}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ana_s5_beh.vhdl} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\cmd_proc_beh.vhdl} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\bench_cmd_proc_tb_rtl.vhd} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\bench_digio_tb_rtl.vhd} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\DigIO_beh.vhdl} -check {RuleSets\Essentials\Code Reuse}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ao_ram_beh.vhdl} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ao_ram_beh.vhdl} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\i2c_master_byte_ctrl.vhd} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ana_acquire_fsm.vhd} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ana_data_ram_beh.vhdl} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ana_data_ram_beh.vhdl} -check {RuleSets\Essentials\Downstream Checks\Constrained Ranges & Bounds}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\bench_dacs_ctrs_tb_rtl.vhd} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\system_simulation.vhdl} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\test_syscon_beh.vhdl} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\bench_test_syscon_tb_rtl.vhd} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\idx_addr_beh.vhdl} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\idx_addr_beh.vhdl} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\bench_gxidx_sim.vhd} -check {RuleSets\Essentials\Code Reuse}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\bench_ana_input_tester_sim.vhdl} -check {RuleSets\Essentials\Code Reuse}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ana_s16_fsm.vhd} -check {RuleSets\Essentials\Coding Practices}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\bench_digio_tb_rtl.vhd} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ptrh_dprams_beh.vhdl} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ptrh_acq_sm_fsm.vhd} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ptrh_tester_sim.vhdl} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ptrh_tester_sim.vhdl} -check {RuleSets\Essentials\Coding Practices\Unused Declarations}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ptrh_tester_sim.vhdl} -check {RuleSets\Essentials\Coding Practices\Sub-Program Body}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\PDACS_HTW_beh.vhdl} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\dacs.vhdl} -check {RuleSets\Essentials\Downstream Checks\Constrained Ranges & Bounds}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\DigIO_beh.vhdl} -check {RuleSets\Essentials\Downstream Checks\Constrained Ranges & Bounds}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\PDACS_HTW_beh.vhdl} -check {RuleSets\Essentials\Downstream Checks\Constrained Ranges & Bounds}
dc_exclude -design_unit {vm_dprams} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {vm_acq_sm} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {i2c_master_byte_ctrl} -check {RuleSets\Essentials\Coding Practices\Internally Generated Resets}
dc_exclude -design_unit {i2c_master_bit_ctrl} -check {RuleSets\Essentials\Coding Practices\Internally Generated Resets}
dc_exclude -design_unit {i2c_master_top} -check {RuleSets\Essentials\Downstream Checks\Initialization Assignments}
dc_exclude -design_unit {vm} -check {RuleSets\Essentials\Downstream Checks\Initialization Assignments}
dc_exclude -design_unit {bench_ptrhm_dprams} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\bench_ptrhm_dprams_tb_rtl.vhd} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ptrhm_dprams} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {ptrhm} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ptrhm_dprams} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {i2c_half_switch} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\bench_i2c_half_switch_tb_rtl.vhd} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_i2c_half_switch} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ptrhm_addr} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ptrhm_addr} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {ptrhm_i2c_sm} -check {RuleSets\Essentials\Code Reuse\VITAL Port Types}
dc_exclude -design_unit {ptrhm_i2c_sm} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ptrhm_i2c_sm} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ptrhm_i2c_sm_tester} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ptrhm_sw_sm} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ptrhm_sw_sm} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {bench_ptrhm_sw_sm} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ptrhm_acq_sm} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ptrhm_acq_sm} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ptrhm_acq_sm} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {ptrhm_acquire} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ptrhm_acquire} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ptrhm_acquire_tb} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {i2c_ext_switch} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ptrhm_acquire_tester} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ao_addr} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ao} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ao_sm} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {dacs_v2} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {PDACS_Carbon} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {qclic_ram} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {qclic_ser} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {qclic_ser} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {qclic_timer} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {qclictrl} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {qclictrl} -check {RuleSets\Essentials\Downstream Checks\Constrained Ranges & Bounds}
dc_exclude -design_unit {qclic_ser} -check {RuleSets\Essentials\Downstream Checks\Constrained Ranges & Bounds}
dc_exclude -design_unit {mock_qcli} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {bench_ao} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_ao} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {vm_tester} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\vm_struct.vhd} -check {RuleSets\Essentials\Code Reuse\Reserved Words}
dc_exclude -source_file {C:\HDS\idx_fpga\idx_fpga_lib\hdl\ptrh_i2c_sm_fsm.vhd} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {fifo} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {fifo} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {bench_fifo} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {lk204_wd} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {lk204_i2c_tb} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {lk204_i2c_tester} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {lk204_i2c} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {lk204} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {lk204_stat} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {lk204_to} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {lk204_tb} -check {RuleSets\Essentials\Code Reuse\Use IEEE types only}
dc_exclude -design_unit {ptrhm_i2c_sm} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}
dc_exclude -design_unit {ao_sm} -check {RuleSets\Essentials\Downstream Checks\Non Synthesizable Constructs}