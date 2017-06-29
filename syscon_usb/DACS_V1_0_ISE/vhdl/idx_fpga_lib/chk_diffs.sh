#! /bin/bash
H=../../../idx_fpga/idx_fpga_lib/hdl

for i in *.vhd* ../*.vhd*; do
  echo
  echo $i
  j=${i#../}
  if [ -f $H/$j ]; then
    diff -b $i $H/$j | grep "^[<>] *[^- ]"
  else
    echo "  $H/$j not found"
  fi
done | less
