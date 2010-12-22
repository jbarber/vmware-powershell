# Find how much space the VMs on each ESX host are using
function VmPerHostSize {
  $hosts = @{}
  $sum = @{}

  $vms = get-view -viewtype virtualmachine
  get-view -viewtype hostsystem | %{ $hosts[ $_.MoRef.value ] = $_.Name }
  
  $vms | %{
    $esx = $hosts[ $_.Runtime.Host.value ]
    $_.Config.Hardware.Device | %{ $_.CapacityInKB } | %{ $sum[ $esx ] += $_ }
  }
  echo $sum
}
