# Report how much space each VM is using

function VmSpaceUsed {
  get-view -view virtualmachine | %{
    $vm = $_ | select name, size
    $_.Config.Hardware.Device | %{ $_.CapacityInKB } | %{ $vm.size += $_ };
    $vm
  } | sort-object size
}
