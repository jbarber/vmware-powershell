# Find all VMs without the tools at the latest version/enabled

function VmToolsOld {
  get-view -viewtype virtualmachine `
    | ?{ $_.runtime.powerstate -like 'poweredOn' } `
    | ?{ $_.guest.toolsstatus -notlike 'toolsok' } `
    | Sort-Object {$_.guest.toolsstatus} `
    | format-table name, {$_.guest.toolsstatus}
}
