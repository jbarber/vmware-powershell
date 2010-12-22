# Set the advanced configuration option sched.mem.maxmemctl to zero to prevent ballooning
function VmDeballoon ($vmname) {
  # Set "sched.mem.maxmemctl" to 0
  $opt = new-object Vmware.Vim.OptionValue -Property @{ Key = "sched.mem.maxmemctl"; Value = 0 }
  $vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
  $vmConfigSpec.extraconfig += $opt

  # Use a filter to find the particular VM
  $vm = get-view -viewtype "VirtualMachine" -filter @{ "Name" = $vmname }

  # And update the config on the server
  $vm.ReconfigVM( $vmConfigSpec )
}
