#! /bin/bash
echo "Running ssp_wrapper script: '$*'"
cmd=$1
shift
PATH=/bin:/usr/bin:/usr/local/bin:$PATH
export SSP_HOSTNAME=10.0.0.211
case $cmd in
  ssp_cmd) :;;
  ssp_log) :;;
  *) echo "Invalid command '$cmd'" >&2; exit 1;;
esac
$cmd $*
echo "Result was $?"
