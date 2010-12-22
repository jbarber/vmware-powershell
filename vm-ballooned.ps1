# Find all of the VMs that have experienced ballooning in the last day
function VmBallooned? ($vm) {
  $d = Get-Stat -memory -entity $vm -start (Get-Date).AddDays(-1) |
    ?{ $_.MetricId -eq 'mem.vmmemctl.average' } |
    ?{ $_.value -ne 0 }
  return $d.count -ne 0
}

# Usage:
# get-view -viewtype virtualmachine | ?{ VmBallooned?( get-viobjectbyviview -moref $_.moref ) } | %{ $_.name }
