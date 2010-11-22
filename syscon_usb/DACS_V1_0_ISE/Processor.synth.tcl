proc pnsynth {} {
  cd C:/Data/Xilinx/Archive/DACS_V1_0/Processor
  if { [ catch { xload xmp Processor.xmp } result ] } {
    exit 10
  }
  if { [catch {run netlist} result] } {
    return -1
  }
  return $result
}
if { [catch {pnsynth} result] } {
  exit -1
}
exit $result
