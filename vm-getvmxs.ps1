# Find all the VMX files on all of the Datastores and download them. This is currently unusable (at least on my system) as the speed of copying files from the datastores is intolerable. I can only think that this is a bug.

function VmGetVMXs {
  # First find the .vmx files
  $fileQueryFlags = new-object VMware.Vim.FileQueryFlags -property @{ FileSize = $true; FileType = $true; Modification = $true }
  $searchSpec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec -property @{ details = $fileQueryFlags; sortFoldersFirst = $true; matchPattern = "*.vmx" }
  
  $files = Get-Datastore | %{
    $ds_store = $_
    $ds = Get-View -viobject $_
    $res = @()
    $dsBrowser = Get-View $ds.browser
  
    $rootPath = "["+$ds.summary.Name+"]"
    $searchResult = $dsBrowser.SearchDatastoreSubFolders($rootPath, $searchSpec)
    foreach ($folder in $searchResult) {
      foreach ($fileResult in $folder.File) {
        if ($fileResult.Path -eq $null) { continue } 
        $file = "" | select Name, Size, Modified, FullPath, DataStore
        $file.DataStore = $ds_store
        $file.Name = $fileResult.Path
        $file.Size = $fileResult.Filesize
        $file.Modified = $fileResult.Modification
        $file.FullPath = $folder.FolderPath + $file.Name
        $res += $file
      }
    }
  
    $res
  }

  # Now group the VMX files by datastore so we don't have to constantly create and destroy PSDrives
  $agg = @{}
  $files | %{
    if ($agg.containskey($_.datastore)) {
      $agg[ $_.datastore ] += $_
    }
    else {
      $agg[ $_.datastore ] = @()
      $agg[ $_.datastore ] += $_
    }
  }

  # This is the bit that actually does the copying... It's increadably slow
  $drive = "source"
  foreach ($ds in $agg.keys) {
    New-PSDrive -Location $ds -Name $drive -PSProvider VimDatastore -Root '\'
    foreach ($vmx in $agg[ $ds ]) {
      Copy-DatastoreItem ("${source}:/", ($vmx.fullpath -split " ")[1] -join "") -Destination ./
    }
    Remove-PSDrive source
  }
}
