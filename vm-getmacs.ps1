# Report on all the MAC addresses for all the VMs
function VmGetMacs {
  get-view -viewtype virtualmachine | select-object name,@{ Name="MAC"; Expression = { $_.config.hardware.device | ?{ $_.macaddress } | %{ $_.macaddress } } } | format-table -wrap -hidetableheaders
}
