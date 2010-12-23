## Overview
This is a collection of powershell scripts which I find useful to quickly enumerate VMware host information.

I've put them in git as an aide memoire for both the VMware API and for the PowerShell syntax.

## Usage
Each file has a function which has a roughly similar name to the filename, starting with "Vm" and followed by the CamelCased name of the file.

To use them, connect to your ESX server/vCenter with:
  connect-viserver -server hostname -username administrator -password sekret

Then source the function file and run the function:
  . .\vm-gethosts.ps1
  VmGetHosts
