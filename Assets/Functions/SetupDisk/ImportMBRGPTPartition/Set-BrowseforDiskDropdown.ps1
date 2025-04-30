function Set-BrowseforDiskDropdown {
    param (
        [Switch]$TransferFiles,
        [Switch]$ImportPartition
    )   
    
    if (-not ($Script:GUIActions.ListofRemovableMedia)){
        $Script:GUIActions.ListofRemovableMedia = Get-RemovableMedia
    }

    if ($ImportPartition){
        if ($WPF_DP_ID_BrowseforDisk_DropDown){
            foreach ($Disk in $Script:GUIActions.ListofRemovableMedia){
                $WPF_DP_ID_BrowseforDisk_DropDown.AddChild($Disk.FriendlyName)       
            }
        }
    }
    elseif ($TransferFiles){
        if ($WPF_TFRDB_BrowseforDisk_DropDown){
            foreach ($Disk in $Script:GUIActions.ListofRemovableMedia){
                $WPF_TFRDB_BrowseforDisk_DropDown.AddChild($Disk.FriendlyName)       
            }
        }
    }
       
       
    
}
