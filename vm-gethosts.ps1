# Create /etc/hosts style output of IPs - VM names
function VmGetHosts {
  get-view -viewtype virtualmachine | ?{ $_.guest.ipaddress } | format-table -hideTableHeaders {$_.guest.ipaddress},name
}
